{
  inputs = {
    configuration.url = "github:ivandimitrov8080/configuration.nix";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neomacs.url = "github:eval-exec/neomacs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # the code shared by all hosts lives in the hosts.nix repo
    # src.url = "github:ivandimitrov8080/hosts.nix?dir=src";
    src = {
      url = "git+file:///home/ivand/src/hosts.nix?dir=src";
      flake = false;
    };
  };
  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      docsConfig = self.nixosConfigurations.iso;
      overlays = import (inputs.src + "/overlays.nix") { inherit inputs docsConfig; };
      nixosModules = import (inputs.src + "/modules") { inherit inputs overlays; };
    in
    {
      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        modules = with nixosModules; [
          default
          minimal
          (import ./host.nix {
            inherit inputs;
            src = inputs.src;
          })
        ];
      };
    };
}
