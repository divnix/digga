{ config, lib, options, ... }:
with lib;
let
  inherit (builtins) readFile fetchurl;

  cfg = config.security.mitigations;

  cmdline = readFile (fetchurl {
    url = "https://make-linux-fast-again.com";
    sha256 = "sha256:10diw5xn5jjx79nvyjqcpdpcqihnr3y0756fsgiv1nq7w28ph9w6";
  });
in {
  options = {
    security.mitigations.disable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to disable spectre and meltdown mitigations in the kernel. Do
        not use this in mission critical deployments, or on any machine you do
        not have physical access to.
      '';
    };

    security.mitigations.acceptRisk = mkOption {
      type = types.bool;
      default = false;
      description = ''
        To ensure users know what they are doing, they must explicitly accept
        the risk of turning off mitigations by enabling this.
      '';
    };
  };

  config = mkIf cfg.disable {
    assertions = [{
      assertion = cfg.acceptRisk;
      message = ''
        You have enabled 'security.mitigations.disable' without accepting the
        risk of disabling mitigations.

        You must explicitly accept the risk of running the kernel without
        Spectre or Meltdown mitigations. Set 'security.mitigations.acceptRisk'
        to 'true' only if you know what your doing!
      '';
    }];

    boot.kernelParams = splitString " " cmdline;

  };
}
