#!/usr/bin/env nix-shell
#! nix-shell -i zsh

setopt extendedglob
setopt nullglob

rm -rf profiles/^(core|user)
rm -rf overlays/*
rm -rf cachix/*
rm -rf hosts/^(default.nix|niximg.nix|NixOS.nix)
rm -rf modules/*
rm -rf pkgs/*
rm -rf secrets
rm -rf users/^root
rm -rf *.md
rm -rf .github
rm -rf COPYING

mkdir -p users/profiles
mkdir -p users/nixos

echo "[ ./core ]" > profiles/list.nix
echo "[ ]" > modules/list.nix
echo "final: prev: { }" > pkgs/default.nix
echo "final: prev: { hello = prev.hello; }" > overlays/hello.nix
echo "{ }" > cachix/default.nix

cat << EOF > pkgs/override.nix
pkgs: final: prev: {
  inherit (pkgs)
    manix;
}
EOF

cat << EOF > users/nixos/default.nix
{
  users.users.nixos = {
    uid = 1000;
    password = "nixos";
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
EOF

