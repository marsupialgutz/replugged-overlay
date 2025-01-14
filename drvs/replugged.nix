{ lib
, replugged-unwrapped
, runCommandLocal
, plugins
, themes
}:
let
  readName = file: lib.strings.sanitizeDerivationName (builtins.fromJSON (builtins.readFile file)).name;

  intoAddons = list: manifestName: builtins.map (element:
  let
    # We're relying on nix to coerce this into something we can use
    path = "${element}";
  in {
    inherit path;
    name = readName "${path}/${manifestName}";
  }) list;

  map = type: addons: lib.concatMapStringsSep "\n" (addon: ''cp -a "${addon.path}" "./${type}/${addon.name}"'') addons;

  mappedPlugins = map "plugins" (intoAddons plugins "manifest.json");
  mappedThemes = map "themes" (intoAddons themes "powercord_manifest.json");
in
runCommandLocal "replugged" {
  passthru.unwrapped = replugged-unwrapped;
  meta = replugged-unwrapped.meta // {
    priority = (replugged-unwrapped.meta.priority or 0) - 1;
  };
} ''
  cp -a "${replugged-unwrapped}" "$out"
  chmod u+w "$out"
  ln -s "${replugged-unwrapped.deps}/node_modules" "$out/node_modules"

  cd "$out/src/Powercord"
  chmod u+w ./plugins ./themes
  ${mappedPlugins}
  ${mappedThemes}
''
