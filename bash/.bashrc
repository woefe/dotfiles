#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

random-string(){
   case $1 in
      -u) 
         < /dev/urandom tr -dc [:print:] | head -c $2
         echo
         ;;
      -r)
         < /dev/random tr -dc [:print:] | head -c $2
         echo
         ;;

      *)
         echo -e "Usage:\nrandom-string -r <length>\nrandom-string -u <length>\n -r uses /dev/random (more secure)\n -u uses /dev/urandom (faster)"
         ;;
   esac
}

# Set default texteditor
export EDITOR="vim"

alias ls='ls --color=auto'
alias l='ls -lah'
alias pacu='sudo -E pacman -Syu'
alias paci='sudo -E pacman -S'
alias pacs='pacsearch'
alias cd..='cd ..'
alias ed="$EDITOR"

