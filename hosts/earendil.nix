{ config, pkgs, lib,... }:

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
    boot.loader.efi.canTouchEfiVariables = true;
    # gummiboot
    #boot.loader.systemd-boot.enable = true;
    # grub
    #boot.loader.grub = {
    #    enable = true;
    #    efiSupport = true;
    #    copyKernels = true;
    #    devices = [ "nodev" ];
    #};
    # lanzaboote
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
    };
    boot.plymouth.enable = true;

    # network
    networking.hostName = "earendil"; # Define your hostname.
    networking.networkmanager.enable = true;
    programs.nm-applet.enable = true;
    networking.firewall.enable = false;
    services.tailscale.enable = true;

    services.openssh = {
        enable = true;
        settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
        };
    };

    services.avahi = {
        enable = true;
        nssmdns4 = true;
    };

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
    security.pam.services.hyprlock = {};
    security.polkit.enable = true;

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
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkmLEEft5rCh1lA58aeI0OStmg09w7AsOgf+EKlfj4u markus@bazzite"
        ];
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
        wofi
        sbctl
        hyprland
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xwayland
        meson
        wayland-protocols
        wayland-utils
        wl-clipboard
        wlroots
    ];
    catppuccin = {
        enable = true;
        flavor = "mocha";
    };

    # nvim - global
    # nvim config for user in home-manager config (nixvim)
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
            jetbrains-mono
            fira-code
            fira-code-symbols
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

        fontconfig = {
            defaultFonts = {
                serif = [ "DejaVu Serif" "Noto Serif CJK JP" "Noto Sans Symbols" "Noto Color Emoji" ];
                sansSerif = [ "DejaVu Sans" "Noto Sans CJK JP" "Noto Sans Symbols" "Noto Color Emoji" ];
                monospace = [ "Jet Brains Mono" "Fira Code" "Noto Sans Mono CJK JP" "Noto Sans Symbols" "Noto Color Emoji" ];
            };
        };
    };

    # kmscon - better TTY
    services.kmscon = {
        enable = true;
        fonts = [{
            name = "Source Code Pro";
            package = pkgs.source-code-pro;
        }];
        extraOptions = "--term xterm-256color";
        extraConfig = "font-size=12";
        hwRender = true;
    };

    # global installation of compositor
    #services.displayManager.sddm = {
    #    enable = true;
    #    wayland.enable = true;
    #    theme = "catppuccin-mocha";
    #    settings = {
    #        Autologin = {
    #            Session = "hyprland";
    #            User = "markus";
    #        };
    #    };
    #};
    services.greetd = {
        enable = true;
        #settings = {
        #    default_session = {
        #        command = "${pkgs.greetd.greetd}/bin/cage -s -- regreet"
        #    };
        #}
    };
    programs.regreet = {
        enable = true;
        settings = {
            GTK = {
                application_prefer_dark_theme = true;
                theme_name = "Adwaita";
            };
#            commands = {
#                
#            };
        };
    };
    programs.dconf.enable = true;
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    # enable container virtualisation (podman)
    virtualisation = {
        containers.enable = true;
        podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
        };
    };

    # steam
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        package = pkgs.steam.override {
            extraPkgs = pkgs: with pkgs; [
	            xorg.libXcursor
	            xorg.libXi
	            xorg.libXinerama
	            xorg.libXScrnSaver
	            libpng
	            libpulseaudio
	            libvorbis
	            stdenv.cc.cc.lib
	            libkrb5
	            keyutils
	        ];
        };
    };

    # flatpak
    services.flatpak.enable = true;
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [
            pkgs.xdg-desktop-portal-gtk
        ];
    };

    system.stateVersion = "24.05"; # Did you read the comment?

}
