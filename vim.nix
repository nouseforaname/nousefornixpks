{ pkgs, ... }:
let
  english_dict = pkgs.hunspellDicts.en_US;
  german_dict = pkgs.hunspellDicts.de_DE;
in
{
  environment.systemPackages = with pkgs; [
    #LSPs implementation
    gopls
    rust-analyzer
    nil
    nixfmt

    #linters
    golint
    statix #nix-linter
    shellcheck

    # dicts
    german_dict
    english_dict
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    configure = {
      customRC = builtins.readFile ./vimrc + ''
        lua << EOS
          require('cmp_dictionary').setup({
            paths = { "${english_dict}/share/hunspell/en_US.dic","${german_dict}/share/hunspell/de_DE.dic" },
            exact_length = 3,
          })
        EOS
      '';
      packages.myVimPackage = with pkgs; {
        start = with vimPlugins; [
          # git
          git-blame-nvim

          # fonts
          nvim-web-devicons

          # navigation // search
          nvim-tree-lua
          fzf-vim

          # vim nix file highlighting & support
          vim-nix

          # markdown
          markdown-preview-nvim

          # snippets
          luasnip

          # config helper
          nvim-lspconfig

          # auto shell check
          vim-shellcheck

          #completion plugin
          nvim-cmp

          #completion sources
          cmp_luasnip
          cmp-nvim-lsp
          cmp-dictionary #dictionaries

        ];
      };
    };
  };
}
