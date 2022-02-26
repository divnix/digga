let
  rev = "e7e5d481a0e15dcd459396e55327749989e04ce0";
  flake = (import
    (
      fetchTarball {
        url = "https://github.com/edolstra/flake-compat/archive/${rev}.tar.gz";
        sha256 = "0zd3x46fswh5n6faq4x2kkpy6p3c6j593xbdlbsl40ppkclwc80x";
      }
    )
    {
      src = ../../.;
    });
in
flake
