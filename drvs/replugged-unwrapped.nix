{ inputs
, lib
, mkYarnPackage
}:
(mkYarnPackage {
  name = "replugged-unwrapped";
  src = inputs.replugged;
  yarnLock = "${inputs.self}/misc/yarn.lock";

  patches = [ ../misc/replugged.patch ];

  installPhase = ''
    runHook preInstall

    mv deps/replugged $out
    rm $out/node_modules

    runHook postInstall
  '';

  meta = {
    homepage = "https://replugged.dev";
    license = lib.licenses.mit;
    description = "A lightweight discord mod focused on simplicity and performance";
  };
}).overrideAttrs (_: {
  doDist = false;
})
