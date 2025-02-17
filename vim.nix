{ ... }:
let
  pkgs = import ( <unstable> ) {};
in
{
  environment.systemPackages = with pkgs; [
    #LSPs implementation
    gopls
    rust-analyzer
    nil
    #linters
    golint
    statix #nix-linter
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    configure = {
      customRC = builtins.readFile ./vimrc;
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
          vim-vsnip
          vim-vsnip-integ

          # config helper
          nvim-lspconfig

          #completion plugin
          nvim-cmp

          #completion sources
          cmp-nvim-lsp
          cmp-vsnip
        ];
      };
    };
  };
}
