# Debian-live-builder !BOOKWORM!

## Usage

**Install Packges**
```
sudo apt install live-build git
```

**Create dir & Clone repo**
```
mkdir -p .local/src
mkdir .build/
cd .local/src
git clone git@github.com:RivenLab/debian-live-builder.git
cd debian-live-builder
chmod u+x build.sh
cd ~
```
---
**Build ISO : Execute The Script**
```
.local/src/debian-live-builder/build.sh  
```
**Iso Location**
```
cd .build/deb-dragon-live
```
