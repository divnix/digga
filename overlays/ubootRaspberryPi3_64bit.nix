final: prev: {
  ubootRaspberryPi3_64bit = prev.ubootRaspberryPi3_64bit.overrideAttrs (o: { patches = [ ../pkgs/misc/uboot/0001-configs-rpi-allow-for-bigger-kernels.patch ]; });
}
