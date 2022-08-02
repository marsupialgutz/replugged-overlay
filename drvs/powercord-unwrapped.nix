{ inputs
, lib
, mkYarnPackage
}:
(mkYarnPackage {
  name = "powercord-unwrapped";
  src = inputs.powercord;
  yarnLock = "${inputs.self}/misc/yarn.lock";

  patches = [ ../misc/powercord.patch ];

  installPhase = ''
    runHook preInstall

    substituteInPlace src/Powercord/plugins/pc-moduleManager/index.js --replace "const { SpecialChannels: { CSS_SNIPPETS, STORE_PLUGINS, STORE_THEMES } } = require('powercord/constants')" "const { SETTINGS_FOLDER, SpecialChannels: { CSS_SNIPPETS, STORE_PLUGINS, STORE_THEMES } } = require('powercord/constants')"
    substituteInPlace src/Powercord/plugins/pc-moduleManager/index.js --replace "this._quickCSSFile = join(__dirname, 'quickcss.css')" "this._quickCSSFile = join(SETTINGS_FOLDER, 'quickcss.css')" 

    mv deps/powercord $out
    rm $out/node_modules

    runHook postInstall
  '';

  meta = {
    homepage = "https://powercord.dev";
    license = lib.licenses.mit;
    description = "A lightweight discord mod focused on simplicity and performance";
  };
}).overrideAttrs (_: {
  doDist = false;
})
