{ ...}: {
  programs.git = {
    enable = true;
    config = {
      user = {
        name  = "nouseforaname";
        email = "34882943+nouseforaname@users.noreply.github.com";
        signingkey = "167CB2D0B694AD60";
      };
      pull = { rebase = true; };
      init = { defaultBranch = "main"; };
      push = { autoSetupRemote = true; };
      commit= {
        verbose = true;
        gpgsign = true;
      };
    };
    lfs.enable = true;
  };
}
