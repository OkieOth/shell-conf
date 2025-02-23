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
end


function dsecret2 --wraps kubectl --description 'decodes a selected secret from k8s'
    set -x SECRET (kubectl get secret -n tms -o name | fzf)
    set -x ENTRY_RAW (kubectl describe -n tms $SECRET | fzf)
    set -x ENTRY (echo $ENTRY_RAW | sed -e 's-:.*--')
    kubectl get -n tms $SECRET --template="'{{index .data \"$ENTRY\"}}'" | xargs echo | base64 -d
end

function dsecretns --wraps kubectl --description 'decodes a selected secret from k8s'
    set -x NAMESPACE (kubectl get namespace -o name | fzf | sed -e 's-.*/--')
    set -x SECRET (kubectl get secret -n $NAMESPACE -o name | fzf)
    set -x ENTRY_RAW (kubectl describe -n tms $SECRET | fzf)
    set -x ENTRY (echo $ENTRY_RAW | sed -e 's-:.*--')
    kubectl get -n tms $SECRET --template="'{{index .data \"$ENTRY\"}}'" | xargs echo | base64 -d
end

function fc --wraps fzf --description 'wrapper around fzf to put the selected text in the clipboard'
    eval "$argv" | fzf -e | xclip -r -selection clipboard
end

function createDirIfNotExists
    if not test -d "$argv[1]"
        if not mkdir "$argv[1]"
            echo "error while creating dir: $argv[1], cancel additional steps"
            exit 1
        else
            echo "  created: $argv[1]"
        end
    end
end

function initGolangRepo --description 'inits the current dir with the default golang repo structure'
    createDirIfNotExists api
    createDirIfNotExists assets
    createDirIfNotExists build
    createDirIfNotExists cmd
    createDirIfNotExists configs
    createDirIfNotExists docs
    createDirIfNotExists internal
    createDirIfNotExists internal/pkg
    createDirIfNotExists pkg
    createDirIfNotExists scripts
    createDirIfNotExists test
    createDirIfNotExists tools

    if not test -f "README.md"
        echo "# TODO - Describe the project" >README.md
    end

    if not test -f ".gitignore"
        begin
            echo "# If you prefer the allow list template instead of the deny list, see community template:" >.gitignore
            echo "# https://github.com/github/gitignore/blob/main/community/Golang/Go.AllowList.gitignore" >>.gitignore
            echo "#" >>.gitignore
            echo "# Binaries for programs and plugins" >>.gitignore
            echo "*.exe" >>.gitignore
            echo "*.exe~" >>.gitignore
            echo "*.dll" >>.gitignore
            echo "*.so" >>.gitignore
            echo "*.dylib" >>.gitignore
            echo "" >>.gitignore
            echo "# Test binary, built with \`go test -c\`" >>.gitignore
            echo "*.test" >>.gitignore
            echo "" >>.gitignore
            echo "# Output of the go coverage tool, specifically when used with LiteIDE" >>.gitignore
            echo "*.out" >>.gitignore
            echo "" >>.gitignore
            echo "# Dependency directories (remove the comment below to include it)" >>.gitignore
            echo "# vendor/" >>.gitignore
            echo "" >>.gitignore
            echo "# Go workspace file" >>.gitignore
            echo "go.work" >>.gitignore
            echo "go.work.sum" >>.gitignore
            echo "" >>.gitignore
            echo "# env file" >>.gitignore
            echo ".env" >>.gitignore
            echo "" >>.gitignore
            echo "*.tmp" >>.gitignore
            echo tmp >>.gitignore
            echo temp >>.gitignore
        end
    end
end
set -gx PATH /home/eikothomas/.krew/bin:/home/eikothomas/prog/git/fzf/bin:/home/eikothomas/.cargo/bin:/home/eikothomas/.local/bin:/home/eikothomas/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/eikothomas/.local/bin:/home/eikothomas/.local/bin /home/eikothomas/.krew/bin
