{ pkgs, lib }:
with lib;
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

  testPathsIn = {
    expr = pathsIn (toString ./testPathsIn);

    expected = map toString [
      ./testPathsIn/bar
      ./testPathsIn/baz
      ./testPathsIn/foo
    ];
  };

  testPathsToImportedAttrs = {
    expr =
      pathsToImportedAttrs [
        (toString ./testPathsToImportedAttrs/dir)
        ./testPathsToImportedAttrs/foo.nix
        ./testPathsToImportedAttrs/bar.nix
        ./testPathsToImportedAttrs/t.nix
        ./testPathsToImportedAttrs/f.nix
      ];

    expected = {
      dir = { a = 5; };
      foo = { bar = 1; };
      bar = { foo = 2; };
      t = true;
      f = false;
    };
  };

  testRgxToString = lib.testAllTrue [
    (rgxToString ".+x" "vxk" == "vx")
    (rgxToString "^fo" "foo" == "fo")
    (rgxToString "a?" "a" == "a")
    (rgxToString "hat" "foohatbar" == "hat")
  ];

  testSafeReadDir = {
    expr = safeReadDir ./profiles // safeReadDir ./nonexistentdir;
    expected = {
      foo = "directory";
      t = "directory";
    };
  };

  testSuites = {
    expr = os.mkSuites {
      suites = { profiles, ... }: with profiles; {
        bar = [ foo ];
      };
      profiles = [ (./profiles) ];
    };
    expected = {
      bar = [ (toString ./profiles/foo) ];
      allProfiles = [
        (toString ./profiles/foo)
        (toString ./profiles/t)
      ];
    };
  };
}
