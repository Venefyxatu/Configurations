#!/usr/bin/env zsh
#
# venefyxatu.zsh-theme
#
# Author: Erik Heeren
# URL: http://tech.venefyxatu.be/
#
# Created on:		September 28, 2012
# Last modified on:	October 24, 2012


# Load required modules.
autoload -U add-zsh-hook
autoload -Uz vcs_info

# Customizable parameters.
PROMPT_PATH_MAX_LENGTH=30
PROMPT_DEFAULT_END=">"
PROMPT_ROOT_END="# "
if [ `hostname` = 'abclaptop' ]
then
    PROMPT_SUCCESS_COLOR=$FG[300]
else
    PROMPT_SUCCESS_COLOR=$FG[024]
fi

PROMPT_FAILURE_COLOR=$FG[124]
PROMPT_VCS_INFO_COLOR=$FG[100]

if [ $UID -eq 0 ]; then NCOLOR="124"; else NCOLOR="045"; fi

# Set required options.
setopt promptsubst

# Add hook for calling vcs_info before each command.
add-zsh-hook precmd vcs_info

# Set vcs_info parameters.
zstyle ':vcs_info:*' enable hg git
zstyle ':vcs_info:*:*' check-for-changes true # Can be slow on big repos.
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'

#In normal formats and actionformats the following replacements are done:
#
#       %s     The VCS in use (git, hg, svn, etc.).
#       %b     Information about the current branch.
#       %a     An identifier that describes the action. Only makes sense in actionfor‐
#              mats.
#       %i     The current revision number or identifier. For hg the hgrevformat style
#              may be used to customize the output.
#       %c     The  string from the stagedstr style if there are staged changes in the
#              repository.
#       %u     The string from the unstagedstr style if there are unstaged changes  in
#              the repository.
#       %R     The base directory of the repository.
#       %r     The repository name. If %R is /foo/bar/repoXY, %r is repoXY.
#       %S     A     subdirectory     within     a     repository.    If    $PWD    is
#              /foo/bar/repoXY/beer/tasty, %S is beer/tasty.
#       %m     A "misc" replacement. It is at the discretion of the backend to  decide
#              what  this  replacement  expands to. It is currently used by the hg and
#              git backends to display patch information from the mq and stgit  exten‐
#              sions.


zstyle ':vcs_info:*:*' actionformats "%u%c(%s) %r %S [%b] %a"
zstyle ':vcs_info:*:*' formats "%u%c(%s) %r %S [%b]"
zstyle ':vcs_info:*:*' nvcsformats "%~" ""
zstyle ':vcs_info:hg*:netbeans' use-simple true

PROMPT="
$FG[$NCOLOR]------------------------------------------------------------%{$reset_color%}
%(0?.%{$PROMPT_SUCCESS_COLOR%}.%{$PROMPT_FAILURE_COLOR%})[%n@%m]%{$FX[bold]%} %(!.$PROMPT_ROOT_END.$PROMPT_DEFAULT_END)%{$FX[no-bold]%}%{$FX[reset]%} "
RPROMPT="%d%  [%{$PROMPT_VCS_INFO_COLOR%}"'${vcs_info_msg_0_}'"%{$FX[reset]%}]"
