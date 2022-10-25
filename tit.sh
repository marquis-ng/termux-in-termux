#!/bin/bash

# Termux in Termux (by marquis-ng)

TERMUX_ROOTFS_PATH="$(realpath -- "$HOME/termux-fs")"
TERMUX_BOOTSTRAP_PATH="$(realpath -- "${TMPDIR:-/tmp}/termux-fs.zip}")"
TERMUX_APP_PATH="$(realpath -- "${TERMUX_APP_PATH:-/data/data/com.termux}")"
TERMUX_FILES_PATH="$TERMUX_APP_PATH/files"
eval "TERMUX_PROOT_ARGS=(${TERMUX_PROOT_ARGS:-})"

info() {
	printf "\033[1;36m%s\033[0m\n" "$@"
}

error() {
	printf "\033[1;31m%s\033[0m\n" "$@" 1>&2
	exit 1
}

if [ "$(uname -o)"  != "Android" ]; then
	error "This program should only be ran on Termux."
fi

if [ "$(id -u)" = 0 ]; then
	error "This program should not be ran as root."
fi

for DEP in wget unzip proot; do
	if ! command -v "$DEP" > /dev/null; then
		error "\"$DEP\" not found."
	fi
done

case "$(uname -m)" in
	aarch64|arm64)
		ARCH="aarch64"
		IS64=true
		;;
	arm|armel|armhf|armhfp|armv7|armv7l|armv7a|armv8l)
		ARCH="arm"
		IS64=false
		;;
	x86_64|amd64)
		ARCH="x86_64"
		IS64=true
		;;
	x86|i*86)
		ARCH="i686"
		IS64=false
		;;
	*)
		error "Architecture \"$(uname -m)\" not supported."
		;;
esac

if [ "$TERMUX_32_BIT" = "true" ] && [ "$IS64" = "true" ]; then
	TERMUX_ROOTFS_PATH+="32"
	TERMUX_BOOTSTRAP_PATH+="32"
	if [ "$ARCH" = "aarch64" ]; then
		ARCH="arm"
	else
		ARCH="i686"
	fi
fi

if [ "$(find "$TERMUX_ROOTFS_PATH" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l)" = 0 ]; then
	if [ -f "$TERMUX_BOOTSTRAP_PATH" ]; then
		info "Using downloaded Termux bootstrap."
	else
		if [ -e "$TERMUX_BOOTSTRAP_PATH" ]; then
			rm -rf "$TERMUX_BOOTSTRAP_PATH"
		fi
		info "Downloading Termux bootstrap..."
		mkdir -p "$(dirname "$TERMUX_BOOTSTRAP_PATH")"
		if wget "https://github.com/termux/termux-packages/releases/latest/download/bootstrap-$ARCH.zip" -q --show-progress -O "$TERMUX_BOOTSTRAP_PATH"; then
			info "Termux bootstrap downloaded."
		else
			error "Failed to download Termux bootstrap."
		fi
	fi

	info "Verifying integrity of bootstrap..."
	if [ "$(wget -qO- https://github.com/termux/termux-packages/releases/latest/download/bootstraps.sha256sum | awk "\$2 == \"bootstrap-$ARCH.zip\" {printf(\$1)}")" != "$(sha256sum "$TERMUX_BOOTSTRAP_PATH" | awk "{printf(\$1)}")" ]; then
		if rm -f "$TERMUX_BOOTSTRAP_PATH"; then
			info "Removed corrupted/expired bootstrap. Rerunning script..."
			exec "$(realpath -- "$0")"
		else
			error "Failed to remove corrupted/outdated bootstrap. Abort."
		fi
	fi

	mkdir -p "$TERMUX_ROOTFS_PATH"
	if ! cd "$TERMUX_ROOTFS_PATH"; then
		error "Failed to change directory. Abort."
	fi
	info "Extracting Termux bootstrap..."
	if unzip -q "$TERMUX_BOOTSTRAP_PATH"; then
		info "Termux bootstrap extracted."
	else
		error "Failed to extract Termux bootstrap."
	fi

	info "Creating symlinks..."
	while read -r LINK; do
		(IFS="←"; read -r SRC DEST <<< "$LINK"; ln -sf "$SRC" "$DEST")
	done < SYMLINKS.txt
	info "Created $(wc -l < SYMLINKS.txt) symlinks."
	rm SYMLINKS.txt

	info "Making common directories..."
	mkdir -p home var/cache
	info "Directories successfully made."

	info "Setup is complete!"
	info "Starting Termux in Termux..."
fi

CMDLINE=(proot --kill-on-exit -r "$TERMUX_ROOTFS_PATH" -w "$TERMUX_FILES_PATH/home")
if [ "${#TERMUX_PROOT_ARGS[@]}" != 0 ]; then
	CMDLINE+=("${TERMUX_PROOT_ARGS[@]}")
fi

for DIR in /dev /proc /sys /system /vendor /apex /sdcard "$PREFIX/..:/host-rootfs"; do
	if [ -d "$DIR" ] || printf "%s\n" "$DIR" | grep -q "com\.termux"; then
		CMDLINE+=(-b "$DIR")
	fi
done

CMDLINE+=(-b "$TERMUX_ROOTFS_PATH:$TERMUX_FILES_PATH/usr"
	-b "$TERMUX_ROOTFS_PATH/home:$TERMUX_FILES_PATH/home"
	-b "$TERMUX_ROOTFS_PATH/var/cache:$TERMUX_APP_PATH/cache"
)

CMDLINE+=("$TERMUX_FILES_PATH/usr/bin/env" -i
	"HOME=$TERMUX_FILES_PATH/home"
	"PATH=$TERMUX_FILES_PATH/usr/bin"
	"PREFIX=$TERMUX_FILES_PATH/usr"
	"TMPDIR=$TERMUX_FILES_PATH/usr/tmp"
	"ANDROID_DATA=/data"
	"ANDROID_ROOT=/system"
	"EXTERNAL_STORAGE=/sdcard"
	"LD_PRELOAD=$TERMUX_FILES_PATH/usr/lib/libtermux-exec.so"
	"TERM=${TERM=-xterm-256color}"
	"COLORTERM=${TERM=-truecolor}"
	"LANG=${LANG=-en_US.UTF-8}"
	"TERMUX_APK_RELEASE=$TERMUX_APK_RELEASE"
	"TERMUX_VERSION=$TERMUX_VERSION"
)
if [ -n "${TERMUX_API_VERSION}" ]; then
	CMDLINE+=("TERMUX_API_VERSION=$TERMUX_API_VERSION")
fi

if [ -z "$1" ]; then
	CMDLINE+=("$TERMUX_FILES_PATH/usr/bin/login")
else
	if [ "$#" != 1 ]; then
		info "Command format is unrecommended. See https://github.com/marquis-ng/termux-in-termux/blob/main/README.md#run-a-command-in-the-sandbox for more."
	fi
	CMDLINE+=(sh -c "$*")
fi

unset LD_PRELOAD
exec "${CMDLINE[@]}"
