{
  description = "A nix overlay to install Discord Canary with Replugged";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    replugged.url = "github:replugged-org/replugged";
    replugged.flake = false;
  };

  outputs = { self, nixpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";
    overlay = import ./overlay.nix inputs;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ overlay ];
    };
  in {
    inherit overlay;
    packages.${system} = { inherit (pkgs) replugged-unwrapped replugged discord-plugged; };
  };
}
