function duet {
  source <(/home/kkiess/workspace/nousefornixpkg/duet.sh $1)
}
export GPG_TTY=$(tty)
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}
export EDITOR=nvim
ssh-add ~/keybase/private/nouseforaname/GITHUB/nouseforaname.pem
source <(kubectl completion bash)
alias vpn='gpu -c'
function __file_search {
  RG_PREFIX="rg --line-number -S --no-heading --ignore-case --no-ignore --hidden --follow -g \"!{.git,node_modules,vendor,.bosh,tmp}/*\" -g \"!*/{.git,node_modules,vendor,.bosh,tmp,*.html}/*\""
  INITIAL_QUERY=""
  FZF_DEFAULT_COMMAND="$RG_PREFIX \"''${INITIAL_QUERY}\" | cut -f1-2 -d: " \
    fzf \
      --bind "change:reload:$RG_PREFIX {q} | cut -f1-2 -d: || true" \
      --preview 'echo {} | xargs -n 3 -d: bash -c "LINE=\$1; if [[ \$LINE -gt 10 ]]; then PREV_LINE=\$((\$LINE-10)); else PREV_LINE=0; fi; bat \$0 -r \$PREV_LINE: --highlight-line \$LINE:\$LINE --color always --paging never"'  \
      --ansi --phony --query "$INITIAL_QUERY" | sed 's/:/ +/g'
}
function __open_in_vim {
  path=$(__file_search)
  if [[ ! "$path" == "" ]]; then
    history -s "nvim -p $path"
    nvim -p $path
  fi
}
export __open_in_vim
bind -x '"\C-f":"__open_in_vim"'
export TERM='screen'
export PATH=${PATH}:~/go/bin
