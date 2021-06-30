{ pkgs, lib }:
with lib;
lib.runTests {
  testRakeLeaves = {
    expr = importers.rakeLeaves ./profiles;
    expected = {
      f = ./profiles/f.nix;
      foo = ./profiles/foo;
      t = {
        bar = ./profiles/t/bar.nix;
      };
    };
  };

  testFlattenTree = {
    expr = importers.flattenTree (importers.rakeLeaves ./profiles);
    expected = {
      f = ./profiles/f.nix;
      foo = ./profiles/foo;
      "t.bar" = ./profiles/t/bar.nix;
    };
  };
}
