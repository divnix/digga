{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    get = {
      writer = budUtils.writeBashWithPaths [ nixUnstable git coreutils ];
      synopsis = "get [DEST]";
      help = "Copy the desired template to DEST";
      script = ./get.bash;
    };
    nvfetcher-github = {
      writer = budUtils.writeBashWithPaths [ nvfetcher-bin coreutils git ];
      synopsis = "nvfetcher-github";
      help = "Auto update with nvfetcher on github action";
      script = ./nvfetcher-github.bash;
    };
  };
}
