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
    host = {
      stateVersion = "26.05";
    };
    minimal = {
      enable = true;
      workstation = false;
    };
  };

  # iso-image.nix does not enable sshd by itself, so do it explicitly.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = lib.mkForce true;
    };
  };
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
        stateVersion = "26.05";
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
      "ssh"
      "video"
      "wheel"
    ];
    password = "iso";
  };
}
