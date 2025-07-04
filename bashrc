
if [[ "$OSTYPE" == "darwin"* ]]; then
  bind -m emacs-standard '"ç": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
  bind -m vi-command '"ç": "\C-z\ec\C-z"'
  bind -m vi-insert '"ç": "\C-z\ec\C-z"'
fi

eval "$(fzf --bash)"
if command -v fzf-share >/dev/null; then
  source "$(fzf-share)/key-bindings.bash"
  source "$(fzf-share)/completion.bash"
fi

#gpg agent connect
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye > /dev/null

FZF_ALT_C_COMMAND='echo "$(find * -type d)\n$(find .* -type d -maxdepth 0)"'

function __file_search {
  RG_PREFIX="rg --line-number -S --no-heading --ignore-case --no-ignore --hidden --follow -g \"!{.direnv,.local,.steam,.git,node_modules,vendor,.bosh,tmp}/*\" -g \"!*/{.direnv,.git,.local,.steam,node_modules,vendor,.bosh,tmp,*.html}/*\""
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
eval "$(direnv hook bash)"
