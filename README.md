# debian-live-builder

## Usage

**Install Packges**
```
sudo apt install live-build git
```

**Create dir & Clone repo**
```
mkdir -p .local/src
cd .local/src
git clone _repo_
cd debian-live-build
chmod u+x build.sh
cd ~
```

**Make Work Dirs**
```
mkdir .build/deb-live -p
cd .build/deb-live
```
**Simple Config command (example)**
```
lb config -d bookworm --debian-installer none --archive-areas "main contrib non-free" --debootstrap-options "--variant=minbase"
```

**Copy all files and configs**
```
cd ~
.local/src/debian-live-build/deploy.sh  
```
**Build iso**
```
cd .build/deb-live  
sudo lb build  
```
