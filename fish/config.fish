function fish_prompt
    set_color cyan
    echo -n (prompt_pwd)
    set_color yellow
    echo -n (fish_vcs_prompt)
    set_color normal
    echo -n '> '
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx PATH $PATH ~/.local/bin ~/go/bin
    set -gx EDITOR hx
end

if status --is-login
    set -gx PATH $PATH ~/.local/bin ~/go/bin
    set -gx EDITOR hx
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

function pii
    nvm use v24.7.0 && pi $argv
end

function piu
    nvm use v24.7.0 && pi update
end

function opi
    # 1. Check argument count
    if test (count $argv) -lt 1
        echo "Error: missing model name"
        echo "Usage: opi <model>"
        return 1
    end

    set model $argv[1]

    # 2. Check if model exists in ollama
    if not ollama ls | grep -q -- $model
        echo "Error: model '$model' not found in ollama"
        return 1
    end

    # 3. Run command (only if previous checks passed)
    nvm use v24.7.0
    or begin
        echo "Error: failed to switch Node version"
        return 1
    end
    ollama launch pi --model $model
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
    set -x ENTRY_RAW (kubectl describe -n $NAMESPACE $SECRET | fzf)
    set -x ENTRY (echo $ENTRY_RAW | sed -e 's-:.*--')
    kubectl get -n $NAMESPACE $SECRET --template="'{{index .data \"$ENTRY\"}}'" | xargs echo | base64 -d
end

function fc --wraps fzf --description 'wrapper around fzf to put the selected text in the clipboard'
    eval "$argv" | fzf -e | xclip -r -selection clipboard
end

function containerlogs --wraps fzf --description 'uses fzf to pick a specific container and print its logs'
    docker ps | fzf -e | awk '{print $1}' | xargs docker logs -f
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

function createGolangGitIgnore
    if not test -f .gitignore
        printf "%s\n" "
# If you prefer the allow list template instead of the deny list, see community template:
# https://github.com/github/gitignore/blob/main/community/Golang/Go.AllowList.gitignore
#
# Binaries for programs and plugins
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary, built with \`go test -c\`
*.test

# Output of the go coverage tool, specifically when used with LiteIDE
*.out

# Dependency directories (remove the comment below to include it)
# vendor/

# Go workspace file
go.work
go.work.sum

# env file
.env

*.tmp
tmp
temp
  " >.gitignore
    end
end

function createGolangMainAndVersion
    createDirIfNotExists cmd
    createDirIfNotExists cmd/sub
    if not test -f ./cmd/main.go
        set -x package $argv[1]
        printf "%s\n" "
package main

import (
	\"fmt\"

	\"github.com/okieoth/ic0bra\"
	\"github.com/spf13/cobra\"

	\"$package/cmd/sub\"
)

var rootCmd = &cobra.Command{
	Use:   CHANGE_ME_COMMAND,
	Short: \"Tool to update aac related files from git repositories\",
	Long:  \"Tool to update aac related files from git repositories\",
	Run: func(cmd *cobra.Command, args []string) {
		if cmdToCall, err := ic0bra.RunInteractiveWithHistory(cmd, CHANGE_ME_COMMAND); err == nil {
			if cmdToCall != nil {
				cmdToCall.Run(cmdToCall, args)
			}
		} else {
			fmt.Println(\"error while running in interactive mode:\", err)
		}
	},
}

func init() {
	rootCmd.AddCommand(sub.VersionCmd)
}

func main() {
	rootCmd.Execute()
}
" >./cmd/main.go
    end
    if not test -f ./cmd/sub/version.go
        printf "%s\n" '
package sub

import (
	"fmt"
	"github.com/spf13/cobra"
)

// variable is used to define the version of docker images
const Version = `0.0.0`

var VersionCmd = &cobra.Command{
	Use:   "version",
	Short: "Shows the version of the program",
	Long:  "Shows the version of the program",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(Version)
	},
}
    ' >./cmd/sub/version.go
    end
end


function logout --description 'logging out of KDE session from the terminal'
    qdbus org.kde.ksmserver /KSMServer logout 0 0 0
end

function initGolangRepo --description 'inits the current dir with the default golang repo structure'
    if not test -f "go.mod"
        if test (count $argv) -ge 1
            set -x name $argv[1]
        else
            set -x name dummy
        end
        go mod init $name
        go get github.com/okieoth/ic0bra
    end
    createDirIfNotExists api
    createDirIfNotExists assets
    createDirIfNotExists build
    createDirIfNotExists configs
    createDirIfNotExists docs
    createDirIfNotExists internal
    createDirIfNotExists internal/pkg
    createDirIfNotExists pkg
    createDirIfNotExists scripts
    createDirIfNotExists test
    createDirIfNotExists tools
    createGolangGitIgnore
    addLicense
    createEditorConfigIgnore
    createGolangMainAndVersion $name
    createReadme
end

function createRustGitIgnore
    if not test -f .gitignore
        printf "%s\n" "
  " >.gitignore
    end
end

function createReadme
  if not test -f "README.md"
      echo "# TODO - Describe the project" >README.md
  end
end

function createEditorConfigIgnore
    if not test -f .editorconfig
        printf "%s\n" "
  root = true

  # Applies to all files
  [*]
  indent_style = space
  indent_size = 4
  end_of_line = lf
  charset = utf-8
  trim_trailing_whitespace = true
  insert_final_newline = true

  [*.json]
  indent_style = space
  indent_size = 2
  end_of_line = lf
  charset = utf-8
  trim_trailing_whitespace = true
  insert_final_newline = true

  [*.yaml]
  indent_style = space
  indent_size = 2
  end_of_line = lf
  charset = utf-8
  trim_trailing_whitespace = true
  insert_final_newline = true

  [Makefile]
  indent_style = tab
  indent_size = 2
  end_of_line = lf
  charset = utf-8
  trim_trailing_whitespace = true
  insert_final_newline = true
  " >.editorconfig
    end
end

function addLicense
  # Ask the user whether to include the MIT license
  read -P "Include MIT license? [y/N] " include_license

  if not test -f LICENSE
    switch (string lower -- $include_license)
      case y yes
        printf "%s\n" \
"MIT License

Copyright (c) 2026 Eiko Thomas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE." > LICENSE
      case '*'
          echo "Skipping LICENSE creation."
    end
  end
end

function createCargoFile
  if not test -f ./Cargo.toml
      set -x package $argv[1]
      set -x packagelib "$argv[1]"lib
      printf "%s\n" "
[package]
name = \"oth_$package\"
version = \"0.1.0\"
edition = \"2024\"
description = \"TODO\"
license = \"MIT\"
repository = \"https://codeberg.org/okieoth/$package\"
keywords = [\"TODO\"]
categories = [\"todo\"]
readme = \"README.md\"
exclude = [
    \"resources/tests/*\",
]
[lib]
name = \"$packagelib\"
path = \"src/lib/lib.rs\"
crate-type = [\"lib\"]

[[bin]]
name = \"$package\"
path = \"src/bin/main.rs\"

[dependencies]
clap = { version = \"4\", features = [\"derive\"] }
" >./Cargo.toml
  end
end

function createMainRs
  if not test -f ./src/bin/main.rs
      set -x package $argv[1]
      set -x packagelib "$argv[1]"lib
      printf "%s\n" "
use $packagelib::dummy;

fn main() {
  let dummy_txt = dummy::dummy();
  println!(\"{dummy_txt}\")
}
" > src/bin/main.rs
  end
end

function createLibRs
  if not test -f ./src/lib/lib.rs
    createDirIfNotExists src/lib/dummy
    if not test -f ./src/lib/dummy/mod.rs
      printf "%s\n" "
pub fn dummy() -> String {
  String::from(\"TODO - I am coming from dummy\")
}
" > src/lib/dummy/mod.rs
    end

    printf "%s\n" "
pub mod dummy;
" > src/lib/lib.rs
  end
end

function initRustRepo --description 'inits the current dir with the default rust repo structure'
  if not test -f "Cargo.toml"
      if test (count $argv) -ge 1
        set -x name $argv[1]
      else
        read -P "what's the crate name?: " new_name
          set -x name $new_name
      end
  end

  createDirIfNotExists resources
  createDirIfNotExists resources/tests
  createDirIfNotExists tests
  createDirIfNotExists src
  createDirIfNotExists src/bin
  createDirIfNotExists src/lib
  createDirIfNotExists docs
  createEditorConfigIgnore
  createRustGitIgnore
  addLicense
  createCargoFile $name
  createMainRs $name
  createLibRs
  createReadme
end

set -gx PATH /home/eikothomas/.krew/bin:/home/eikothomas/prog/git/fzf/bin:/home/eikothomas/.cargo/bin:/home/eikothomas/.local/bin:/home/eikothomas/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/eikothomas/.local/bin:/home/eikothomas/.local/bin /home/eikothomas/.krew/bin /home/eikothomas/go/bin
