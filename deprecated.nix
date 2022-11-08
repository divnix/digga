{
  lib,
  importers,
}:
lib.warn ''
  You are accessing a deprecated item of the digga lib.
  Please update timely, it will be remove soon.
''
rec {
  importModules =
    lib.warn ''
      Deprecated Function: lib.importModules.

      Use lib.importExportableModules instead to set `exportedModules` option
    ''
    importers.importExportableModules;
}
