# file: make-linux-fast-again.nix
{ pkgs, config, ... }:
let
  inherit (builtins) readFile fetchurl;
  cmdline = readFile (fetchurl {
    url = "https://make-linux-fast-again.com";
    sha256 = "sha256:10diw5xn5jjx79nvyjqcpdpcqihnr3y0756fsgiv1nq7w28ph9w6";
  });
in { boot.kernelParams = pkgs.lib.splitString " " cmdline; }
