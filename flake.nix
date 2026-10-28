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
    let
      modules = import ./modules.nix { inherit inputs; };
    in
    {
      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        modules = [
          modules.default
          modules.minimal
          (import ./host.nix { inherit inputs; })
        ];
      };
    };
}
