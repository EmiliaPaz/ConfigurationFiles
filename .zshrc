###############################################################################
# Personal configuration
###############################################################################

###  Plugins
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Enables fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

### Themes
# p10K
source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### Main dev
alias python='python3'

### Aliases
# Common commands
alias c='clear'
alias q='exit'
alias ..='cd ..'
alias ..2='cd ../ ..'
alias ..3='cd ../../..'
alias ls='ls -GFh'
alias g='git'

# Shortcuts
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias gitcfg='vim ~/.gitconfig'

###############################################################################
# Work configuration
###############################################################################

### Chromium
# Path
export PATH=~/Crx/cr/depot_tools:$PATH

# Chrome Remote Desktop
alias crd='sudo switch-graphical-session crd'
alias crd-local='sudo switch-graphical-session local'

# Aliases
alias src='cd ~/Crx/cr/c2/src'
alias sshots='python ~/Crx/cr/c2/src/tools/translation/upload_screenshots.py'
alias goma='goma_ctl ensure_start'
alias run='out/Default/chrome'
alias run='out/Default/chrome --enable-features=ExtensionsMenuAccessControl'
alias ext='cd ~/Extensions'
alias snippets='cd ~/Crx/ChromiumTools && python gerrit-cls.py'

# Dev workflow

# Instruction for rebase-update all branches
# 1. `update-main`
#    Checkout to main, pull origin/main, sync dependencies and build most common
#    targets.
#    This should be done the night before the first week work day to avoid
#    losing time. Should not be any conflicts, so can be simply run before going
#    to bed.
# 2. `rebase-ind <ind_branch_1> ... <ind_branch_2>`
#    Rebase individual branches onto main.
#    Each branch is passed as an argument, and each rebased separately onto
#    main.
# 3. `rebase-nes <nes_branch_parent> <nes_branch_child_1> ...
# <nes_branch_child_n>` for each nested group
#    Rebase nested branches onto main.
#    Run this command for each group of nested branches. The order of command
#    MUST match parent - child1 - ... - childn
#
# Example:
#   $git map-branches
#     origin/main
#       A
#       B
#       C1
#         C2
#       D1
#         D2
#           D3
#   $update-main
#   $rebase-ind A B
#   $rebase-nes C1 C2
#   $rebase-nes D1 D2 D3

# Build the targets passed.
# Usage:
#   an <target_1> <target_2> ... <target_n>
# Example:
#   `an browser_tests unit_tests`
an()
{
  for target in "$@"
  do
    echo "Building $target"
    autoninja -C out/Default "$target"
    echo ""
  done
}

# Build most common Chromium targets.
# Usage:
#   an-all
an-all()
{
  builds=(chrome browser_tests unit_tests extensions_unittests)
  for i in $builds
  do
    echo "Building $i"
    autoninja -C out/Default "$i"
    echo ""
  done
}

# Update main branch to origin and dependencies.
# Usage:
#   update-main
update-main()
{
  git checkout main
  git pull origin main
  gclient sync -fD
  ulimit -n 50000 # Uncomment this for macOS development.
  goma_ctl ensure_start
  # an-all
}

# Rebase individual branches on top of main.
# Usage:
#   rebase-ind <branch_1> <branch_2> ... <branch_n>
# Example:
#   origin/main           origin/main'
#     A
#     B
#     C1
#       C2
#   `rebase-ind A B`:
#   origin/main`          origin/main'
#     C1                    A
#       C2                  B
rebase-ind()
{
  for branch in "$@"
  do
    echo "Rebasing $branch"
    git rebase main "$branch"
    echo ""
  done
}

# Rebase nested branches on top of main.
# Usage: rebase-nes <top_branch> <child_branch_1> ... <child_branch_n>
#        MUST be in order. Function will asume top_branch - child_branch_1 - ...
#        order.
# Example:
#   origin/main           origin/main'
#     A
#     B
#     C1
#       C2
#         C3
#   `rebase-nes C1 C2 C3`:
#   origin/main           origin/main'
#     A                     C1
#     B                       C2
#                               C3
# TODO(NOT WORKING, WILL FIX IT TODO(NOT WORKING, WILL FIX IT WITH DUMMY
# BRANCHES ON MAC. PROBLEMS: ZSH ARRAYS START AT 1, LOOPS ARE DIFFERENT)
rebase-nes()
{
  echo "beginning..."
  branches=("$@")
  last_commit=()
  # Store the last commit of each branch.
  for ((i=1; i<=$#branches; i++))
  do
    echo "..."
    last_commit+=$(git rev-parse ${branches[$i]})
  done

  echo "Done storing"

  # Rebase top branch to main.
  echo "Rebasing $1 on top of main"
  git rebase main "$1"

  # Rebase children branches to their parent branch (that is already rebased to
  # main).
  for ((i=1; i<"$#"; i++))
  do
    echo ""
    echo "Rebasing ${branches[i]} on top of ${branches[i-1]} starting after commit ${last_commit[i-1]}"
    git rebase --onto ${branches[i-1]} ${last_commit[i-1]} ${branches[i]}
  done
}
