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
wget https://raw.githubusercontent.com/marquis-ng/termux-in-termux/main/tit.sh # download script
chmod +x tit.sh # make downloaded script executable
./tit.sh # activate Termux environment
```
or for people who prefer one-liners:
```
pkg install wget unzip proot; wget https://raw.githubusercontent.com/marquis-ng/termux-in-termux/main/tit.sh; chmod +x tit.sh; ./tit.sh
```
That's all! What will greet you is a nice, clean, new Termux environment.

## Documentation
### Run/install Termux-in-Termux:
```bash
./tit.sh
```

### Run a command in the sandbox:
```bash
# ./tit.sh 'program [arguments]'
./tit.sh 'ls -lA "/data/data/com.termux/files"'
```
OR
```bash
# ./tit.sh program [arguments]
# This way of running a command is NOT RECOMMENDED (see why below).
./tit.sh ls -lA /data/data/com.termux/files
```

**Warning ⚠️⚠️⚠️: the latter way has some issues (e.g. arguments with spaces). Use the former way to execute a command in the sandbox.**

### Environment variables:
| Variable name | Default | Usage | Example |
| :-- | :-- | :-- | :-- |
| `TERMUX_ROOTFS_PATH` | `$HOME/termux-fs` | Root directory of sandbox environment | `export TERMUX_ROOTFS_PATH="$HOME/sandbox"` |
| `TERMUX_BOOTSTRAP_PATH` | `[$TMPDIR /tmp]/termux-fs` | Path to bootstrap archive | `export TERMUX_BOOTSTRAP_PATH="/sdcard/Download/termux-bootstrap.zip"` |
| `TERMUX_APP_PATH` | `/data/data/com.termux` | Root directory of sandboxed Termux app | `export TERMUX_APP_PATH="/data/data/com.mytermux"` |
| `TERMUX_PROOT_ARGS` | `(empty)` | Root directory of sandboxed Termux app | `export TERMUX_PROOT_ARGS"-b \"/sdcard/my dir:/dir\""` |

**Warning ⚠️⚠️⚠️: Termux bootstrap may not play well with a custom `TERMUX_APP_PATH`.**


### Ideas for the project:
- Add emulated CPU architecture support (QEMU)
- Linux PC support
- Self-updating script
