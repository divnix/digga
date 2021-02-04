{ pkgs, ... }:
let inherit (pkgs) python3Packages;
in
{
  environment.systemPackages =
    let
      packages = pythonPackages:
        with pythonPackages; [
          numpy
          pandas
          ptpython
          requests
          scipy
        ];

      python = pkgs.python3.withPackages packages;

    in
    [ python ];
  environment.sessionVariables = {
    PYTHONSTARTUP =
      let
        startup = pkgs.writers.writePython3 "ptpython.py"
          {
            libraries = with python3Packages; [ ptpython ];
          } ''
          from __future__ import unicode_literals

          from pygments.token import Token

          from ptpython.layout import CompletionVisualisation

          import sys

          ${builtins.readFile ./ptconfig.py}

          try:
              from ptpython.repl import embed
          except ImportError:
              print("ptpython is not available: falling back to standard prompt")
          else:
              sys.exit(embed(globals(), locals(), configure=configure))
        '';
      in
      "${startup}";
  };
}
