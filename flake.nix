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
      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        # meta.host.* and meta.minimal.* read nixpkgs/emacs-overlay from here.
        specialArgs = { inherit inputs; };
        modules = [
          inputs.configuration.nixosModules.default
          inputs.home-manager.nixosModules.default
          (import ./host.nix { inherit inputs; })
        ];
      };
    };
}
