# termux-in-termux
An isolated environment of Termux inside Termux.

## Introduction
Termux-in-Termux (`tit`) allows installing an isolated environment of Termux inside Termux.

## How on earth is Termux-in-Termux useful?
It is extremely useful. Trust me. Anyway, here are some applications:
- A testing environment (you won't screw up your main Termux environment again 😀)
- Multi-user support (vanilla Termux doesn't support multi-user currently)
- Install different versions of the same package ("Hey, I am running 2 versions of Python!")

## I'm sold! But how can I install Termux-in-Termux?
Installing Termux-in-Termux is as easy as a piece of cake (add `sudo` if necessary):
```bash
apt update
apt upgrade
apt install git wget unzip proot # install dependencies for Termux-in-Termux
apt install python3 # optional dependency for fuzzy string matching to suggest commands
git clone https://github.com/marquis-ng/termux-in-termux # clone this repository
cd termux-in-termux # cd to cloned directory
./install.sh install # run install script
tit --help # get help
```
That's all! What will greet you is a nice, clean, new Termux environment.

## Documentation
### Run Termux-in-Termux:
```bash
tit install
tit login
tit remove
# see details by running 'tit --help'
```

### Run a command in the sandbox:
```bash
# tit login -- program [arguments]
tit login -- ls -lA "/data/data/com.termux/files"
```

### Remove Termux-in-Termux:
```bash
./install.sh uninstall # go to the dirctory of the cloned repository beforehand
```

### Ideas for the project:
- Add emulated CPU architecture support (QEMU)
- Linux PC support
- Self-updating script
