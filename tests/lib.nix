{ self, pkgs }:
let inherit (self.inputs.nixos) lib; in
with self.lib;
lib.runTests {
  testConcatAttrs = {
    expr = concatAttrs [{ foo = 1; } { bar = 2; } { baz = 3; }];

    expected = { foo = 1; bar = 2; baz = 3; };
  };

  testGenAttrs' = {
    expr = genAttrs'
      [ "/foo/bar" "/baz/buzz" ]
      (path: {
        name = baseNameOf path;
        value = "${path}/fizz";
      });

    expected = { bar = "/foo/bar/fizz"; buzz = "/baz/buzz/fizz"; };
  };

  testMapFilterAttrs = {
    expr = mapFilterAttrs
      (n: v: n == "foobar" && v == 1)
      (n: v: lib.nameValuePair ("${n}bar") (v + 1))
      { foo = 0; bar = 2; };

    expected = { foobar = 1; };
  };

  testPathsIn =
    let testPaths = pkgs.runCommandNoCC "test-paths-in" { } ''
      mkdir -p $out/{foo,bar,baz}
    '';
    in
    {
      expr = pathsIn testPaths;

      expected = [
        "${testPaths}/bar"
        "${testPaths}/baz"
        "${testPaths}/foo"
      ];
    };

  testPathsToImportedAttrs = {
    expr =
      pathsToImportedAttrs [
        ./testPathsToImportedAttrs/foo.nix
        ./testPathsToImportedAttrs/bar.nix
        ./testPathsToImportedAttrs/t.nix
        ./testPathsToImportedAttrs/f.nix
      ];

    expected = {
      foo = { bar = 1; };
      bar = { foo = 2; };
      t = true;
      f = false;
    };
  };
}
