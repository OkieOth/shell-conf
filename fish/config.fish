if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx PATH $PATH ~/.local/bin
    set -gx EDITOR nvim
end

if status --is-login
    set -gx PATH $PATH ~/.local/bin
    set -gx EDITOR nvim
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

<<<<<<< HEAD
function gl
    git pull $argv
end

function kc
    kubectl $argv
end

function dsecret --wraps kubectl --description 'decodes a selected secret from k8s'
    set -x SECRET (kubectl get secret -o name | fzf)
    set -x ENTRY_RAW (kubectl describe $SECRET | fzf)
    set -x ENTRY (echo $ENTRY_RAW | sed -e 's-:.*--')
    kubectl get $SECRET --template="'{{index .data \"$ENTRY\"}}'" | xargs echo | base64 -d
=======
function fc --wraps fzf --description 'wrapper around fzf to put the selected text in the clipboard'
    eval "$argv" | fzf -e | xclip -r -selection clipboard
>>>>>>> 825e8bf9081b571a1bb688bc877c8e23d00c9e22
end
