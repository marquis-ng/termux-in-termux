#!/bin/bash
installer() {
	printf "Installing files to system...\n"
	mkdir -p "$PREFIX/bin"
	cp -f tit "$PREFIX/bin/tit"
	chmod +x "$PREFIX/bin/tit"
	mkdir -p "$PREFIX/etc/bash_completion.d"
	cp -f tit-completion.bash "$PREFIX/etc/bash_completion.d/tit-completion.bash"
	mkdir -p "$PREFIX/share/doc/tit"
	cp -f README.md "$PREFIX/share/doc/tit/README.md"
	printf "Done. Run 'tit-- help' to start using Termux-in-Termux.\n"
}

uninstaller() {
	printf "Reverting changes to system...\n"
	rm -rf "$PREFIX/bin/tit"
	rm -rf "$PREFIX/etc/bash_completion.d/tit-completion.bash"
	rm -rf "$PREFIX/share/doc/tit/README.md"
	rm -rf "$HOME"/termux{,-pacman}-fs{,32}
	printf "Done.\n"
}

# shellcheck disable=SC2155
export PREFIX="$(realpath -- "${PREFIX:-/usr}")"
cd "$(realpath -- "$(dirname -- "$0")")" || exit
case "$1" in
	install)
		installer
		;;
	uninstall)
		uninstaller
		;;
	*)
		printf "Usage: %s [install | uninstall]" "$0"
		;;
esac