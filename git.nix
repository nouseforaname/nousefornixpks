{ ...}: {
  programs.git = {
    enable = true;
    config = {
      user = {
        name  = "nouseforaname";
        email = "34882943+nouseforaname@users.noreply.github.com";
      };
      pull = { rebase = true; };
      init = { defaultBranch = "main"; };
      push = { autoSetupRemote = true; };
      commit.verbose = true;
    };
    lfs.enable = true;
  };
}
