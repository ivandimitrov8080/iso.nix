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
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.configuration.nixosModules.default
          inputs.home-manager.nixosModules.default
          (import ./host.nix { inherit inputs; })
        ];
      };
    };
}
