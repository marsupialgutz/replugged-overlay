{ symlinkJoin
, discord-canary
, inputs
, replugged
, plugins
, themes
}:
let
  repluggedWithAddons = replugged.override {
    inherit plugins themes;
  };
in
symlinkJoin {
  name = "discord-plugged";
  paths = [ discord-canary.out ];

  postBuild = ''
    cp -r ${inputs.self}/plugs $out/opt/DiscordCanary/resources/app
    substituteInPlace $out/opt/DiscordCanary/resources/app/index.js --replace 'POWERCORD_SRC' '${repluggedWithAddons}'

    cp -a --remove-destination $(readlink "$out/opt/DiscordCanary/.DiscordCanary-wrapped") "$out/opt/DiscordCanary/.DiscordCanary-wrapped"
    cp -a --remove-destination $(readlink "$out/opt/DiscordCanary/DiscordCanary") "$out/opt/DiscordCanary/DiscordCanary"
    substituteInPlace $out/opt/DiscordCanary/DiscordCanary --replace '${discord-canary.out}' "$out"
  '';
}
