{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    get = {
      writer = budUtils.writeBashWithPaths [ nixUnstable git coreutils ];
      synopsis = "get [DEST]";
      help = "Copy the desired template to DEST";
      script = ./get.bash;
    };
    cfg = {
      writer = budUtils.writeBashWithPaths [ git coreutils exa gnugrep ];
      synopsis = "cfg [SUBCOMMAND]";
      help = "Manage profiles (add, remove, etc.) for your configuration";
      script = ./cfg.bash;
    };
  };
}
