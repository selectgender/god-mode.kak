# the creator of this code snippet is @alexherbo2 / @taupiqueur_
# make sure to say your thanks and send your flowers to them ^-^

# god_mode_commands.kak

define-command reenter_god_mode_after_key -params 1 %{
	execute-keys -with-hooks %arg{1}
	enter_god_mode
}

define-command reenter_god_mode_after_to_char_key -params 1 %{
	reenter_god_mode_after_mode_change 'next-key[to-char]' %arg{1}
}

define-command reenter_god_mode_after_prompt_key -params 1 %{
	reenter_god_mode_after_mode_change 'prompt' %arg{1}
}

define-command reenter_god_mode_after_goto_key -params 1 %{
	reenter_god_mode_after_mode_change 'next-key[goto]' %arg{1}
}

define-command reenter_god_mode_after_mode_change -params 2 %{
	hook -once window ModeChange "\Qpop:%arg{1}:normal\E" %{
		enter_god_mode
	}
	execute-keys -with-hooks %arg{2}
}

# god_mode.kak

declare-user-mode god

define-command enter_god_mode %{
	enter-user-mode god
}

map -docstring 'next search match' global god n ':reenter_god_mode_after_key <lt>a-n<gt><ret>'

map -docstring 'search forward for {char}' global god f ':reenter_god_mode_after_to_char_key <lt>a-f<gt><ret>'

map -docstring 'search forward for {pattern}' global god / ':reenter_god_mode_after_prompt_key <lt>a-/<gt><ret>'
