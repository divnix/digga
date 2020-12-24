with pkgs;

mkDevShell {
  name = "Personal Rust DevShell";

  packages = [
    latest.rustChannels.stable.rust
    wasm-bindgen-cli
    binaryen

    ncurses
    pkgconfig
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
}
