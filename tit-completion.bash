# completion for tit (Termux-in-Termux) made by marquis-ng

if ! command -v tit > /dev/null; then
	return
fi

_tit_completions_filter() {
	local words="$1"
	local cur=${COMP_WORDS[COMP_CWORD]}
	local result=()

	for word in "${COMP_WORDS[@]:1:COMP_CWORD-1}"; do
		if [ "$word" = "--" ]; then
			return 0
		fi
	done

	if [ "${cur:0:1}" = "-" ]; then
		echo "$words"
	else
		for word in $words; do
			[ "${word:0:1}" != "-" ] && result+=("$word")
		done
		echo "${result[*]}"
	fi
}

_tit_completions() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	local compwords=("${COMP_WORDS[@]:1:$COMP_CWORD-1}")
	local compline="${compwords[*]}"

	case "$compline" in
		backup*-o|backup*--output|restore*-a|restore*--archive)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -A file -- "$cur")
			;;
		login*-b|login*--bind)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -A file -A directory -- "$cur")
			;;
		login*-w|login*--workdir)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -A directory -- "$cur")
			;;
		-h*|--help*|help*)
			:
			;;
		install*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_tit_completions_filter "--32-bit -p --pacman --reset")" -- "$cur")
			;;
		login*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_tit_completions_filter "--32-bit -p --pacman -b --bind -w --workdir")" -- "$cur")
			;;
		remove*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_tit_completions_filter "--32-bit -p --pacman -y --yes")" -- "$cur")
			;;
		du*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_tit_completions_filter "-i --installed")" -- "$cur")
			;;
		backup*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_tit_completions_filter "--32-bit -p --pacman -f --force -o --output")" -- "$cur")
			;;
		restore*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_tit_completions_filter "-y --yes -a --archive")" -- "$cur")
			;;
		*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_tit_completions_filter "install login remove du backup restore -h --help help")" -- "$cur")
			;;
	esac
}

complete -F _tit_completions tit
