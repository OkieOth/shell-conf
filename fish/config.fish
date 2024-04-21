if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx PATH $PATH ~/.local/bin
end

if status --is-login
    set -gx PATH $PATH ~/.local/bin
end

set -g fish_greeting

function ssh_pwd --wraps ssh --description 'alias for ssh with enforced password auth'
    ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password $argv
end

function cat --wraps cat --description 'alias to wrap cat with bat'
    bat $argv
end

function gdb --wraps git --description 'alias wrapper to combine git diff with bat'
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
end

function ll
    eza -l $argv
end

function la
    eza -l -a $argv
end

function lld
    eza -l -D $argv
end

function lad
    eza -l -a -D $argv
end

function lltd
    eza --tree -D $argv
end

function llt
    eza --tree -L 3 $argv
end

function gs
    git status
end

function gd
    git diff $argv
end

function gc
    git commit $argv
end

function gt
    git tag $argv
end

function gp
    git push $argv
end
