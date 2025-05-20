export ZSH="$HOME/.oh-my-zsh" # Path to oh-my-zsh installation.
ZSH_THEME="half-life"

CASE_SENSITIVE="true"
zstyle ':omz:update' mode auto      # update automatically without asking
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
plugins=(git)

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"
setopt autocd
setopt autolist
setopt interactivecomments

# Source the aliases file if it exists
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# == POWERLINE GLYPH SETUP ====================================
PL_GIT_BRANCH_CHAR=""
PL_GIT_MODIFIED_CHAR="*"
PL_GIT_STAGED_CHAR="+"
PL_GIT_CONFLICTED_CHAR="x"
PL_GIT_STASHED_CHAR="$"
PL_GIT_UNTRACKED_CHAR="?"
PL_GIT_AHEAD_CHAR="⇡"
PL_GIT_BEHIND_CHAR="⇣"
PL_GIT_DIVERGED_CHAR="⇕"

PL_RIGHT_HARD_DIVIDER=""
PL_RIGHT_SOFT_DIVIDER=""

# '\uE0C6'
PL_RIGHT_FADE_DIVIDER=""

# u'\uE0C7'
PL_LEFT_FADE_DIVIDER=""

# == PROMPT CONFIGURATION =====================================

# prompt style and colors based on Steve Losh's Prose theme:
# https://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# https://briancarper.net/blog/570/git-info-in-your-zsh-prompt

#use extended color palette if available
if [[ $TERM = (*256color|*rxvt*) ]]; then
  cyan="%{${(%):-"%F{81}"}%}"
  orange="%{${(%):-"%F{166}"}%}"
  purple="%{${(%):-"%F{135}"}%}"
  hotpink="%{${(%):-"%F{161}"}%}"
  limegreen="%{${(%):-"%F{118}"}%}"
  blue="%{${(%):-"%F{blue}"}%}"
  yellow="%{${(%):-"%F{yellow}"}%}"
else
  cyan="%{${(%):-"%F{cyan}"}%}"
  orange="%{${(%):-"%F{yellow}"}%}"
  purple="%{${(%):-"%F{magenta}"}%}"
  hotpink="%{${(%):-"%F{red}"}%}"
  limegreen="%{${(%):-"%F{green}"}%}"
  blue="%{${(%):-"%F{blue}"}%}"
  yellow="%{${(%):-"%F{yellow}"}%}"
fi

autoload -Uz vcs_info
# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

zstyle ':vcs_info:*:prompt:*' check-for-changes true

PR_RST="%{${reset_color}%}"
FMT_BRANCH=" on ${hotpink}%b%u%c${PR_RST}"
FMT_ACTION=" performing a ${limegreen}%a${PR_RST}"
FMT_UNSTAGED="${orange} ●"
FMT_STAGED="${limegreen} ●"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function steeef_chpwd {
  PR_GIT_UPDATE=1
}

function steeef_preexec {
  case "$2" in
  *git*|*svn*) PR_GIT_UPDATE=1 ;;
  esac
}

function steeef_precmd {
  (( PR_GIT_UPDATE )) || return

  # check for untracked files or updated submodules, since vcs_info doesn't
  if [[ -n "$(git ls-files --other --exclude-standard 2>/dev/null)" ]]; then
    PR_GIT_UPDATE=1
    FMT_BRANCH="${PM_RST}on ${cyan}${PL_GIT_BRANCH_CHAR} %b%u%c${hotpink} ●${PR_RST}"
  else
    FMT_BRANCH="${PM_RST}on ${cyan}${PL_GIT_BRANCH_CHAR} %b%u%c${PR_RST}"
  fi
  zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"

  vcs_info 'prompt'
  PR_GIT_UPDATE=
}

# vcs_info running hooks
PR_GIT_UPDATE=1

autoload -U add-zsh-hook
add-zsh-hook chpwd steeef_chpwd
add-zsh-hook precmd steeef_precmd
add-zsh-hook preexec steeef_preexec

# ruby prompt settings
ZSH_THEME_RUBY_PROMPT_PREFIX="with%F{red} "
ZSH_THEME_RUBY_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_RVM_PROMPT_OPTIONS="v g"

# virtualenv prompt settings
ZSH_THEME_VIRTUALENV_PREFIX=" with%F{red} "
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}"

setopt prompt_subst
BLACK_CD=0
PURPLE_CD=128
BLUE_CD=51
GREEN_CD=47

CALENDAR="📅 "
CLOCK=" 🕟"
RPROMPT="${CALENDAR}%D${CLOCK}%t"

NEWLINE=$'\n'
SPACE=" "
CHECKMARK="✅"
CROSSMARK="❌"
LAST_COMMAND_STATUS="%(?.${CHECKMARK}.${CROSSMARK})"

PROMPT="${NEWLINE}"
PROMPT+="╭─${LAST_COMMAND_STATUS}${SPACE}${purple}%n%{$reset_color%}${SPACE}"  #------------- user
PROMPT+="💻${SPACE}${cyan}%M%{$reset_color%}${SPACE}" #---------------- host
PROMPT+="📁${SPACE}${limegreen}%~%{$reset_color%}${SPACE}" #----------- current directory
PROMPT+="\$(virtualenv_prompt_info)" #----------------- virtualenv
PROMPT+="\$(ruby_prompt_info)" #----------------------- ruby
PROMPT+="\$vcs_info_msg_0_" #-------------------------- git/svn
PROMPT+="%{$reset_color%}${NEWLINE}" #----------------- newline
PROMPT+="╰─%F{208}$%f " #-------------- prompt

# == UTF ENCODING ENVIRONMENT VARIABLES ============================
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# == ALIASES =======================================================
alias reload_zsh="install_dotfiles ~ .zshrc && exec zsh"

alias df-clone="git clone http://github.com/aaweaver-actuary/dotfiles"
alias df-edit="git clone http://github.com/aaweaver-actuary/dotfiles && cd dotfiles && code ."
alias df-sync="cd ~/dotfiles && git add . && git commit -m 'running auto-sync' && git push && cd ~ && rm -rf dotfiles && install_dotfiles ~ .zshrc && exec zsh"


# == MAKE AUTOCORRECT CHILL OUT ===================================
CORRECT_IGNORE="*test*"

# == AUTOCOMPLETION ===============================================
# make the directory if it doesn't exist
mkdir -p $HOME/.zsh/completions

# add the directory to the fpath
fpath=($HOME/.zsh/completions $fpath)