_tmux()
{
  local subcommands="list-sessions attach new-session"
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"

  case $prev in
    -t)
      local sessions=$(tmux list-sessions 2>/dev/null | awk -F ':' '{printf("%s ", $1)}')
      if [[ -z $sessions ]]; then
        COMPREPLY=()
      else
        COMPREPLY=( $(compgen -W "$(echo $sessions | awk -F ':' '{print $1}')" -- $cur) )
      fi
      return 0
      ;;
  esac

  local commands=$(tmux list-commands 2>/dev/null | awk '{printf("%s ",$1)}')
  if [[ -z $commands ]]; then
    COMPREPLY=( $(compgen -W "$subcommands" -- $cur))
  else
    COMPREPLY=( $(compgen -W "$commands" -- $cur))
  fi
  return 0
}

complete -F _tmux tmux
