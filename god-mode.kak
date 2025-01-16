# plagiarized from emacs god mode:
# https://github.com/emacsorphanage/god-mode
#
# ALSO plagiarized from extend-mode
# https://github.com/alexherbo2/dotfiles/blob/master/.local/share/kak/autoload/user_modes/extend_mode/extend_mode.kak
# https://github.com/alexherbo2/dotfiles/blob/master/.local/share/kak/autoload/user_modes/extend_mode/extend_mode_commands.kak#L27-L32
#
# credits:
# to screwtape for telling me about `:on-key` :)
# to taupiqueur_/alexherbo2 for
#	1. telling me about `-lock` in `enter-user-mode`
#	2. the ENTIRETY of the `god-mode-change-reenter`
#	3. MANY of the concerns and considerations in the q&a
#	4. encouraging me to make this into a fully fledged repository
#	5. sharing extend-mode and its genius :)

declare-option -docstring %{
	These are the alt-prefixed keys that don't require any user interaction

	Example:
	```
	set-option global god_alt_bindings \
		'n' 'u' 'o' ',' 's' 'p' '.' \
		'N' 'U' 'O' '(' ')' 'C' 'R'

	set-option -add global god_alt_bindings '+'
	```
} str-list god_alt_bindings \
	'n' 'u' 'o' ',' 's' 'p' '.' \
	'N' 'U' 'O' '(' ')' 'C' 'R'

declare-option -docstring %{
	These are the alt-prefixed keys that require a single character input

	Example:
	```
	set-option global god_alt_to_char_bindings \
		'f' 't' \
		'F' 'T'
	```
} str-list god_alt_to_char_bindings \
	'f' 't' \
	'F' 'T'

declare-option -docstring %{
	These are the alt-prefixed keys that require a prompt

	Example:
	```
	set-option global god_alt_prompt_bindings \
		'/' 'k' \
		'?' 'K'
	```
} str-list god_alt_prompt_bindings \
	'/' 'k' \
	'?' 'K'

declare-user-mode god-mode

# a utility comand for the to-char keys and prompt keys
define-command -hidden god-mode-change-reenter -params 2 %{
	hook -once window ModeChange "\Qpop:%arg{1}:normal\E" %{
		enter-user-mode god-mode
	}

	execute-keys -with-hooks %arg{2}
}

define-command -docstring %{
	This is the command you run after you modify the options for `god-mode`
	and configure the key for entering the user mode.

	The ordering of this command is very significant. Make sure it is
	called last.
} god-mode-activate-mappings %{
	evaluate-commands %sh{
		mappings=""

		eval set -- "$kak_quoted_opt_god_alt_bindings"

		while [ $# -ne 0 ]; do
			mappings="$mappings \n map global god-mode $1 '<a-$1>:enter-user-mode god-mode<ret>'"

			shift 1
		done

		# below is where we start to use <lt> and <gt> since it outputs a regex
		# error if we dont :(

		eval set -- "$kak_quoted_opt_god_alt_to_char_bindings"

		while [ $# -ne 0 ]; do
			mappings="$mappings \n map global god-mode $1 ':god-mode-change-reenter \"next-key[to-char]\" <lt>a-$1<gt><ret>'"

			shift 1
		done

		eval set -- "$kak_quoted_opt_god_alt_prompt_bindings"

		while [ $# -ne 0 ]; do
			mappings="$mappings \n map global god-mode $1 ':god-mode-change-reenter \"prompt\" <lt>a-$1<gt><ret>'"

			shift 1
		done

		printf "$mappings"
	}
}
