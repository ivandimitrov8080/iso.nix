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
  };
  outputs =
    inputs@{ nixpkgs, ... }:
    {
      # hosts.nix passes in its shared tree (src) and the config to take the
      # nixos option docs from, so nothing has to be duplicated here
      mkHost =
        { src, docsConfig }:
        let
          overlays = import (src + "/overlays.nix") { inherit inputs docsConfig; };
          nixosModules = import (src + "/modules") { inherit inputs overlays; };
        in
        nixpkgs.lib.nixosSystem {
          modules = with nixosModules; [
            default
            minimal
            (import ./host.nix { inherit src inputs; })
          ];
        };
    };
}
