#!/bin/bash
run() {
	printf "RUN: %s\n" "$*"
	if ! "$@"; then
		printf "ERR\n" 1>&2
		exit 1
	fi
}

installer() {
	echo "Installing files to system..."
	run mkdir -p "$PREFIX/bin"
	run cp -f "$BASE/tit" "$PREFIX/bin/tit"
	run chmod +x "$PREFIX/bin/tit"
	run mkdir -p "$PREFIX/etc/bash_completion.d"
	run cp -f "$BASE/tit-completion.bash" "$PREFIX/etc/bash_completion.d/tit-completion.bash"
	run mkdir -p "$PREFIX/share/doc/tit"
	run cp -f "$BASE/README.md" "$PREFIX/share/doc/tit/README.md"
	echo "Done. Run 'tit --help' to start using Termux-in-Termux."
}

uninstaller() {
	echo "Reverting changes to system..."
	run rm -rf "$PREFIX/bin/tit"
	run rm -rf "$PREFIX/etc/bash_completion.d/tit-completion.bash"
	run rm -rf "$PREFIX/share/doc/tit/README.md"
	run rm -rf "$HOME"/termux{,-pacman}-fs{,32}
	echo "Done."
}

# shellcheck disable=SC2155
export PREFIX="$(realpath -- "${PREFIX:-/usr}")"
BASE="$(realpath -- "$(dirname -- "$0")")"
case "$1" in
	install)
		installer
		;;
	uninstall)
		uninstaller
		;;
	*)
		echo "Usage: $0 [install | uninstall]"
		;;
esac
