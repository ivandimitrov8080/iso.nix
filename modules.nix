# NixOS modules for the installer image. Kept local to this flake (it used to
# live in hosts.nix/src) so iso.nix evaluates on its own.
{
  inputs,
  hostOverlays ? [ ],
}:
let
  system = "x86_64-linux";
in
{
  default =
    { pkgs, ... }:
    {
      imports = [ inputs.configuration.nixosModules.default ];
      nix.registry = {
        self.flake = inputs.self;
        nixpkgs.flake = inputs.nixpkgs;
        p.flake = inputs.nixpkgs;
      };
      nixpkgs = {
        hostPlatform = system;
        overlays = hostOverlays ++ [
          inputs.configuration.overlays.default
          inputs.emacs-overlay.overlays.default
        ];
      };
      system.stateVersion = pkgs.lib.trivial.release;
      users.defaultUserShell = pkgs.nushell;
    };
  minimal =
    { pkgs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.default ];
      nix = {
        settings = {
          substituters = [
            "https://nix-community.cachix.org"
            "https://cache.nixos.org/"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
      };
      security.sudo-rs.enable = true;
      environment = {
        systemPackages = with pkgs; [
          ffmpeg
          gcc
        ];
        wordlist.enable = true;
        variables = {
          SUDO_ASKPASS = "${pkgs.askpass}/bin/askpass";
          NIX_SUDOOPTS = "-A";
        };
        etc."libinput/local-overrides.quirks".text = ''
          [KMonad Virtual Keyboard]
          MatchName=kmonad-laptop
          AttrKeyboardIntegration=internal
        '';
      };
      fonts = {
        fontDir.enable = true;
        packages = with pkgs; [
          nerd-fonts.fira-code
          nerd-fonts.symbols-only
          noto-fonts
          noto-fonts-color-emoji
          noto-fonts-lgc-plus
          emacs-all-the-icons-fonts
          inter
        ];
      };
      programs = {
        git.enable = true;
        zoxide.enable = true;
        zsh.enable = true;
        nix-ld.enable = true;
        nix-ld.libraries = with pkgs; [
          alsa-lib
          at-spi2-atk
          cairo
          cups
          dbus
          expat
          glib
          gtk3
          libgbm
          libx11
          libxcb
          libxcomposite
          libxdamage
          libxext
          libxfixes
          libxkbcommon
          libxrandr
          libxrender
          libxtst
          libxi
          freetype
          vulkan-loader
          libGL
          nspr
          nss
          pango
        ];
        ladybird.enable = true;
      };
      services = {
        pipewire.enable = true;
        dbus.enable = true;
        locate.enable = true;
        resolved.enable = true;
        guix.enable = true;
        libretranslate.enable = true;
        transmission.enable = true;
        kmonad = {
          enable = true;
          keyboards.laptop = {
            device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
            defcfg.enable = true;
            config = ''
              (defsrc
                esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  ssrq pause ins del
                grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
                tab  q    w    e    r    t    y    u    i    o    p    [    ]
                caps a    s    d    f    g    h    j    k    l    ;    '    \    ret
                lsft z    x    c    v    b    n    m    ,    .    /    rsft       pgup up   pgdn
                lctl lmet lalt           spc                 ralt rctl            left down rght
              )
              (deflayer base
                esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  ssrq pause ins del
                grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
                tab  q    w    e    r    t    y    u    i    o    p    [    ]
                caps a    s    d    f    g    h    j    k    l    ;    '    \    ret
                lsft z    x    c    v    b    n    m    ,    .    /    rsft       left up   right
                lctl lmet lalt           spc                 ralt rctl            left down rght
              )
            '';
          };
        };
      };
      hardware.uinput.enable = true;
      meta = {
        graphicalBoot.enable = true;
        shells.enable = true;
        swayland.enable = true;
      };
    };
}
