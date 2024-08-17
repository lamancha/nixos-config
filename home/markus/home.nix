{ config, pkgs, anyrun, ... }:

{
  home.username = "markus";
  home.homeDirectory = "/home/markus";

  home.packages = with pkgs; [
    waybar
    mako
    kdePackages.polkit-kde-agent-1
    catppuccin
    hyprpaper
    wofi
    distrobox
    nyancat
    texliveFull
    firefox
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
  
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font.name = "JetBrainsMono Nerd Font";
    settings = {
      background_opacity = "0.75";
      enable_audio_bell = false;
      tab_bar_edge = "top";
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      #palette = "catppuccin-mocha";
    };
  };
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    #plugins = with pkgs.vimPlugins; [
    #  catppuccin-nvim
    #  feline-nvim
    #  julia-vim
    #  nvim-cursorline
    #  nvim-scrollbar
    #];
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      # extra .bashrc config goes here
    '';
  };

  programs.anyrun = {
    enable = true;
    config = {
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.symbols
        inputs.anyrun.packages.${pkgs.system}.translate
        inputs.anyrun.packages.${pkgs.system}.dictionary
      ];
    };
  };

#  programs.steam = {
#    enable = true;
#    remotePlay.openFirewall = true;
#    dedicatedServer.openFirewall = true;
#    gamescopeSession.enable = true;
#    package = pkgs.steam.override {
#      extraPkgs = pkgs:
#        with pkgs; [
#	  xorg.libXcursor
#	  xorg.libXi
#	  xorg.libXinerama
#	  xorg.libXScrnSaver
#	  libpng
#	  libpulseaudio
#	  libvorbis
#	  stdenv.cc.cc.lib
#	  libkrb5
#	  keyutils
#	];
#    };
#  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.variables = ["--all"];
    settings = {

      env = [
        "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
        "MOZ_WEBRENDER,1"
        # misc
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland"
      ];      

      monitor = ",preferred,auto,auto";

      general = {
        gaps_in = "5";
	gaps_out = "10";
	border_size = "2";
	#col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
	#col.inactive_border = "rgba(595959aa)";
	resize_on_border = false;
	allow_tearing = true;
	layout = "dwindle";
      };

      decoration = {
        rounding = "10";
	active_opacity = "1.0";
	inactive_opacity = "0.7";
	drop_shadow = true;
	shadow_range = "4";
	shadow_render_power = "3";
	#col.shadow = "rgba(1a1a1aee)";
	blur.enabled = true;
	blur.size = "3";
	blur.passes = "1";
	blur.vibrancy = "0.1696";
      };

    animations = {
      enabled = true;
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
	  ];
    };

    exec-once = [
      "waybar"
      "hyprpaper"
      "mako"
      "/usr/lib/polkit-kde-authentication-agent-1"
    ];

    "$mainMod" = "ALT";
    "$menu" = "anyrun";
    bind = [
      "$mainMod, Q, exec, kitty"
      "$mainMod, C, killactive"
      "$mainMod, M, exit"
      "$mainMod, V, togglefloating"
      "$mainMod, R, $menu"
      "$mainMod, P, pseudo"
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
    ];
    bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
    ];

      input = {
        kb_layout = "jp";
        follow_mouse = "1";
      };

      windowrulev2 = "suppressevent maximize, class:.*";

    };
  };
}
