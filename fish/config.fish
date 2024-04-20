if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx PATH $PATH ~/.local/bin
end

if status --is-login
    set -gx PATH $PATH ~/.local/bin
end

function ssh_pwd --wraps ssh --description 'alias for ssh with enforced password auth'
    ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password $argv
end
