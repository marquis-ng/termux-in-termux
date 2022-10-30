#!/bin/bash
run() {
	printf "\033[32m+ \033[34m%s\033[0m\n" "$*"
	if ! "$@"; then
		printf "\033[1;31mCommand returned an error. Abort.\n" 1>&2
		exit 1
	fi
}

msg() {
	printf "\033[1;36m%s\033[0m\n" "$@"
}

installer() {
	msg "Installing files to system..."
	run mkdir -p "$PREFIX/bin"
	run cp -f "$BASE/tit" "$PREFIX/bin/tit"
	run chmod +x "$PREFIX/bin/tit"
	run mkdir -p "$PREFIX/etc/bash_completion.d"
	run cp -f "$BASE/tit-completion.bash" "$PREFIX/etc/bash_completion.d/tit-completion.bash"
	run mkdir -p "$PREFIX/share/doc/tit"
	run cp -f "$BASE/README.md" "$PREFIX/share/doc/tit/README.md"
	msg "Done. Run 'tit --help' to start using Termux-in-Termux."
}

uninstaller() {
	msg "Reverting changes to system..."
	run rm -rf "$PREFIX/bin/tit"
	run rm -rf "$PREFIX/etc/bash_completion.d/tit-completion.bash"
	run rm -rf "$PREFIX/share/doc/tit/README.md"
	run rm -rf "$HOME"/termux{,-pacman}-fs{,32}
	msg "Done."
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
		msg "Usage: $0 [install | uninstall]"
		;;
esac
