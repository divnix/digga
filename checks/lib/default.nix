{
  pkgs,
  lib,
}:
with lib;
  lib.runTests {
    testRakeLeaves = {
      expr = rakeLeaves ./profiles;
      expected = {
        f = ./profiles/f.nix;
        foo = ./profiles/foo;
        t = {
          bar = ./profiles/t/bar.nix;
        };
      };
    };

    testFlattenTree = {
      expr = flattenTree (rakeLeaves ./profiles);
      expected = {
        f = ./profiles/f.nix;
        foo = ./profiles/foo;
        "t.bar" = ./profiles/t/bar.nix;
      };
    };
  }
