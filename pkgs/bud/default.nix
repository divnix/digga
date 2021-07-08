{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    get = {
      writer = budUtils.writeBashWithPaths [ nixUnstable git coreutils ];
      synopsis = "get (core|community) [DEST]";
      help = "Copy the desired template to DEST";
      script = ./get.bash;
    };
  };
}
