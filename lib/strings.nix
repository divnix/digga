{ lib, ... }:
{
  # returns matching part of _regex_ _string_; null indicates failure.
  rgxToString = regex: string:
    let
      match =
        let
          head = lib.substring 0 1 regex;
          sec = lib.substring 1 2 regex;
        in
        if head == "^"
          || head == "."
          || (sec == "*" || sec == "+" || sec == "?")
        then builtins.match "(${regex}).*" string
        else builtins.match ".*(${regex}).*" string;
    in
    if lib.isList match
    then lib.head match
    else null;
}
