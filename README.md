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
Installing Termux-in-Termux is as easy as a piece of cake:
```bash
pkg install wget unzip proot # install dependencies for Termux-in-Termux
wget https://raw.githubusercontent.com/marquis-ng/termux-in-termux/main/tit # download script
chmod +x tit # make downloaded script executable
mv tit "$PREFIX/bin" # move it to $PATH
tit --help # get help
```
or for people who prefer one-liners:
```
pkg install wget unzip proot; wget https://raw.githubusercontent.com/marquis-ng/termux-in-termux/main/tit; chmod +x tit; mv tit "$PREFIX/bin"; tit --help
```
That's all! What will greet you is a nice, clean, new Termux environment.

## Documentation
### Run Termux-in-Termux:
```bash
tit install
tit login
# see more commands by running 'tit --help'
```

### Run a command in the sandbox:
```bash
# ./tit.sh command -- program [arguments]
tit login -- ls -lA "/data/data/com.termux/files"
```

### Remove Termux-in-Termux:
```bash
rm -rf "$PREFIX/bin/tit" "$HOME"/termux{,-pacman}-fs{,32} # Remove the script and the sandbox
```

### Ideas for the project:
- Add emulated CPU architecture support (QEMU)
- Linux PC support
- Self-updating script
