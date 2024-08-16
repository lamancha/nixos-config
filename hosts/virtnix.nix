{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../hardware/hardware-virtualbox.nix
    ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "virtnix"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "gb";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.markus = {
    isNormalUser = true;
    description = "markus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    mc
    curl
    git
    duf
    tmux
    xdg-desktop-portal-hyprland
    catppuccin-sddm
    catppuccin-plymouth
  ];

  services.openssh.enable = true;
  networking.firewall.enable = false;
  environment.variables.EDITOR = "nvim";

  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts-emoji
      source-sans
      source-serif
      (nerdfonts.override {
        fonts = [
	  "NerdFontsSymbolsOnly"
	  "FiraCode"
	  "JetBrainsMono"
	];
      })
      julia-mono
      dejavu_fonts
    ];
  };

  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "Source Code Pro";
	package = pkgs.source-code-pro;
      }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=12";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  programs.dconf.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?

}
