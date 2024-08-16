{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../hardware/hardware-laptop.nix
    ];
  
  # nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  # Boot
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    copyKernels = true;
    devices = [ "nodev" ];
  };

  boot.plymouth = {
    enable = true;
    theme = "breeze";
    logo = "${pkgs.nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake-white.png";
  };

  # network
  networking.hostName = "earendil"; # Define your hostname.
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  networking.firewall.enable = false;
  services.tailscale.enable = true;

  # pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # other system services
  services.fwupd.enable = true;
  services.printing.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # locale
  i18n.defaultLocale = "de_AT.UTF-8";

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

  # X11 and console keymap
  services.xserver = {
    xkb.layout = "jp";
    xkb.variant = "";
  };

  console.keyMap = "jp106";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.markus = {
    isNormalUser = true;
    description = "markus";
    extraGroups = [ "networkmanager" "wheel" ];
    #packages = with pkgs; []; # should be done by home-manager
  };

  # global packages
  environment.systemPackages = with pkgs; [
    git
    wget
    mc
    curl
    git
    duf
    tmux
    htop
    xdg-desktop-portal-hyprland
    catppuccin-sddm
    catppuccin-plymouth
  ];

  # nvim - global
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    vimAlias = true;
    viAlias = true;
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # fonts - global
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
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

  # kmscon - better TTY
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
    hwRender = true;
  };

  # global installation of compositor
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
  };
  programs.dconf.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  # enable container virtualisation (podman)
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}
