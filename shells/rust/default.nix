{ config, lib, ... }: {
  options.nixflk.rust = {
    enable = lib.mkEnableOption "nixflk.rust";
    openssl = lib.mkEnableOption "nixflk.rust.openssl";
  };
  config = lib.optionalAttrs nixflk.rust.enable {
    name = "Nixflk Rust DevShell";

    packages = [
      latest.rustChannels.stable.rust
      wasm-bindgen-cli
      binaryen

      ncurses
      pkgconfig
    ] ++ lib.mkIf options.nixflk.rust.openssl [
    openssl
    openssl.dev
    ];

    env.RUST_BACKTRACE = "1";

    commands = [
      {
        name = "hello";
        help = "say hello";
        category = "fun";
        command = "echo '''hello''' ";
      }
    ];
  };
}
