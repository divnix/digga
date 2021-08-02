{ lib
, vscode-utils
, vscode
, namespace ? false
}:

with lib;

let
  isVsix = hasSuffix ".vsix";

  isVsixPackage = hasSuffix ".VSIXPackage";

  isVscodeExt = name: (isVsix name) || (isVsixPackage name);

  isNaiveJSONList = string: (hasPrefix "[" string) && (hasSuffix "]" string);

  toJSONString = string:
    if isNaiveJSONList string
    then string
    else ''"${string}"'';

  mkVscodeExtUniqueId = ext:
    let uniqueIds =
      if isVsix ext.src.name
      then splitString "." (getName ext.src.name)
      else
        builtins.match
          # 1st & 2nd match: publisher
          # 3rd match: name
          "https://(.*).gallery.vsassets.io/_apis/public/gallery/publisher/(.*)/extension/(.*)/${ext.version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
          (head ext.src.urls);
    in
    { publisher = head uniqueIds; pname = last uniqueIds; };

  mkVscodeExtMetaLink = name: publisher: pname: { openVsxPath ? "/", vscodeMarketplacePath ? "/" }:
    if isVsix name
    then "https://open-vsx.org/extension/${publisher}/${pname}${openVsxPath}"
    else "https://marketplace.visualstudio.com/items/${publisher}.${pname}${vscodeMarketplacePath}";

  mkVscodeMetaOption = ext:
    if isVsix ext.src.name
    then { inherit (ext) homepage description; }
    else { };

  mkVscodeExtension = ext: publisher: pname:
    vscode-utils.buildVscodeExtension ((builtins.removeAttrs ext [ "pname" "src" "version" "homepage" "description" ]) // rec {
      inherit (ext) version;

      name = "${publisher}-${pname}-${version}";

      vscodeExtUniqueId = "${publisher}.${pname}";

      src = "${publisher}-${pname}.zip";

      preUnpack = ''ln -s "${ext.src}" $src'';

      meta = with lib; {
        inherit (vscode.meta) platforms;
        downloadPage = mkVscodeExtMetaLink ext.src.name publisher pname { };
        changelog = mkVscodeExtMetaLink ext.src.name publisher pname {
          openVsxPath = "/changes";
          vscodeMarketplacePath = "/changelog";
        };
        license = assert asserts.assertMsg (ext ? license) "Specify a license for ${vscodeExtUniqueId} VS Code extension!";
          forEach
            (toList (builtins.fromJSON (toJSONString ext.license)))
            (license: licenses."${license}");
        maintainers =
          if ext ? maintainers
          then
            forEach
              (toList (builtins.fromJSON ext.maintainers))
              (maintainer: maintainers."${maintainer}")
          else [ maintainers.danielphan2003 ];
      } // (mkVscodeMetaOption ext);
    });

  mkVscodeExtensions = sources:
    mapAttrs'
      (name: ext:
        let inherit (mkVscodeExtUniqueId ext) publisher pname; in
        nameValuePair
          "${optionalString namespace "${publisher}."}${name}" # follows user-defined source name
          (mkVscodeExtension ext publisher pname))
      sources;
in
{
  inherit
    isVsix isVscodeExt isVsixPackage
    mkVscodeExtUniqueId mkVscodeExtMetaLink
    mkVscodeExtension mkVscodeExtensions
    ;
}
