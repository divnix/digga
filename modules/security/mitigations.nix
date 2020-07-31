{ config, lib, ... }:
with lib;
let
  inherit (builtins) readFile fetchurl;

  cfg = config.security.mitigations;

  cmdline = ''
    ibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier mds=off tsx=on tsx_async_abort=off mitigations=off
  '';
in
{
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
