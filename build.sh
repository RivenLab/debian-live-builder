#!/bin/bash

# build.sh by RivenLab
# Builds custom Debian iso.
# IMPORTANT: this script should never be run as root.
# Only the lb clean and lb build commands require root privileges.
# By default, doas is called from the script. If sudo is installed instead,
# replace /usr/bin/sudo with /usr/bin/sudo in the do_build() and do_rebuild() functions.

BUILDER=RivenLab
FLAVOUR=bookworm
REPODIR="$HOME"/.local/src/debian-live-builder/config
WORKDIR="$HOME"/.build/deb-dragon-live

mk_dir() {
	mkdir -p "$WORKDIR"
}

conf() {
	cd "$WORKDIR" || exit
	lb config \
		-d "$FLAVOUR" \
		--debian-installer none \
		--iso-publisher "$BUILDER" \
		--checksums sha512 \
		--image-name deb-dragon-live-"$(date +"%Y%m%d")" \
		--archive-areas "main contrib non-free non-free-firmware" \
		--debootstrap-options "--variant=minbase" \
		--bootappend-live "boot=live slab_nomerge init_on_alloc=1 init_on_free=1 page_alloc.shuffle=1 pti=on randomize_kstack_offset=on vsyscall=none debugfs=off lockdown=confidentiality"
}

copy_files() {
	cp -r "$REPODIR"/includes.chroot_after_packages/ "$WORKDIR"/config/
	cp "$REPODIR"/package-lists/pkgs.list.chroot "$WORKDIR"/config/package-lists/
}

do_deploy() {
	mk_dir
	conf
	copy_files
}

do_build() {
	cd "$WORKDIR" || exit
	/usr/bin/sudo lb build
	gen_sums_sig

}

do_rebuild() {
	cd "$WORKDIR" || exit
	/usr/bin/sudo lb clean
	lb config
	/usr/bin/sudo lb build
}

gen_sums_sig() {
	local _isoname=deb-dragon-live-"$(date +"%Y%m%d")"-amd64.iso

	cd "$WORKDIR" || exit
	touch checksums-"$_isoname".txt
	sha256sum "$_isoname" > checksums-"$_isoname".txt
	sha512sum "$_isoname" >> checksums-"$_isoname".txt
	# Generate a key pair with gpg beforehand or comment out this part
	gpg --detach-sign "$_isoname"
}

# Accepted arguments:
# -c: only run do_deploy
# -r: rebuilds the iso without re-deploying (NOT TESTED YET)
# No arguments provided assumes we want to deploy and build the iso from scratch.
case "$1" in
	-c) do_deploy ;;
	-r) do_rebuild
		gen_sums_sig ;;
	*) do_deploy
		do_build
		gen_sums_sig ;;
esac
