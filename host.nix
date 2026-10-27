{ src, inputs }:
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
  services.openssh.settings.PermitRootLogin = "yes";
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  home-manager = {
    backupFileExtension = "bak";
    useUserPackages = true;
    useGlobalPkgs = true;
    users.iso = lib.mkMerge [
      (import (src + "/modules/home-manager") { inherit inputs pkgs; })
      {
        home = {
          username = "iso";
          homeDirectory = "/home/iso";
          pointerCursor.enable = true;
        };
      }
    ];
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
