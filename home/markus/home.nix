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
#    anyrun
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

    #palette = "catppuccin-mocha"
  };
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      feline-nvim
      julia-vim
      nvim-cursorline
      nvim-scrollbar
    ];
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      # extra .bashrc config goes here
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.variables = ["--all"];
  };

#  programs.anyrun = {
#    enable = true;
#    hideIcons = false;
#    layer = "overlay";
#  };

}
