inputs: final: prev: rec {
  replugged-unwrapped = prev.callPackage ./drvs/replugged-unwrapped.nix { inherit inputs; };

  replugged = prev.callPackage ./drvs/replugged.nix {
    inherit replugged-unwrapped;
    plugins = [ ];
    themes = [ ];
  };

  discord-plugged = prev.callPackage ./drvs/discord.nix {
    inherit inputs replugged;
    plugins = [ ];
    themes = [ ];
  };
}
