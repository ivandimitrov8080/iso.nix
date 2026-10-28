# Everything host specific about the installer image. The shared baseline
# (packages, fonts, kmonad, nix-ld, meta.* defaults) lives in
# configuration.nix's meta.minimal module.
{ inputs }:
{
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
  ];

  meta = {
    host.overlays = [ inputs.emacs-overlay.overlays.default ];
    minimal.enable = true;
  };

  services.openssh.settings.PermitRootLogin = "yes";
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  home-manager = {
    backupFileExtension = "bak";
    useUserPackages = true;
    useGlobalPkgs = true;
    users.iso = {
      imports = [ inputs.configuration.homeManagerModules.default ];
      home = {
        username = "iso";
        homeDirectory = "/home/iso";
      };
    };
  };

  users.users.iso = {
    isNormalUser = true;
    createHome = true;
    shell = pkgs.nushell;
    extraGroups = [
      "adbusers"
      "adm"
      "audio"
      "bluetooth"
      "dialout"
      "input"
      "kvm"
      "mlocate"
      "realtime"
      "render"
      "video"
      "wheel"
    ];
    password = "iso";
  };
}
