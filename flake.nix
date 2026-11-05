{
  inputs = {
    configuration.url = "git://idimitrov.dev/configuration.nix";
    nixpkgs.url = "git://idimitrov.dev/nixpkgs/nixos-unstable";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";

      host = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.configuration.nixosModules.default
          inputs.home-manager.nixosModules.default
          (import ./host.nix { inherit inputs; })
          {
            nixpkgs = {
              hostPlatform = system;
              overlays = [
                inputs.emacs-overlay.overlays.default
                inputs.configuration.overlays.default
              ];
            };
            nix.registry = {
              self.flake = inputs.self;
              nixpkgs.flake = inputs.nixpkgs;
              p.flake = inputs.nixpkgs;
            };
          }
        ];
      };
    in
    {
      nixosConfigurations.default = host;
    };
}
