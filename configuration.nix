# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the grub EFI boot loader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    # gfxmodeEfi = "1024x768";
    # font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMonoNL-Regular.ttf";
    font = "${pkgs.maple-mono-SC-NF}/share/fonts/truetype/MapleMono-SC-NF-Light.ttf";
    fontSize = 36;
    extraEntries = ''
      menuentry "Windows" {
        search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
        chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
      }'';
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  users.users.cube = {
    isNormalUser = true;
    home = "/home/cube";
    extraGroups = [ "wheel" "networkmanager" "audio" ];
  };
  networking.hostName = "nixos";
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons ];
  };
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Hack" "Source Han Mono SC" ];
        sansSerif = [ "Inter" "Liberation Sans" "Source Han Sans SC" ];
        serif = [ "Liberation Serif" "Source Han Serif SC" ];
      };
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      hack-font
      inter
      liberation_ttf
      # noto-fonts-emoji
      noto-fonts-color-emoji
      roboto
      # sarasa-gothic
      source-han-mono
      source-han-sans
      source-han-serif

      maple-mono-SC-NF
      jetbrains-mono
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    dpi = 192; # 200%
    upscaleDefaultCursor = true;
    videoDrivers = [ "nvdia" ];
    desktopManager.plasma5.enable = true;
  };
  services.displayManager.sddm = {
    enable = true;
    settings = {
      # see https://github.com/sddm/sddm/issues/894
      # -nolisten tcp
      X11.ServerArguments = "-dpi 192";
    };
  };
  environment.systemPackages = with pkgs; [ vim wget neofetch git clash-verge ];
  environment.variables = { XCURSOR_SIZE = "32"; };

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    tunMode = true;
  };

  sound.enable = true;
  nix.settings.substituters =
    [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}

