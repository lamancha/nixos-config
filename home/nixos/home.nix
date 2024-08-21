{ config, pkgs, lib, ... }:

{

    home.username = "nixos";
    home.homeDirectory = "/home/nixos";

    home.packages = with pkgs; [
        catppuccin
        nyancat
        fzf
        gh
    ];

    catppuccin = {
        enable = true;
        flavor = "mocha";
    };

    home.stateVersion = "24.05";
    programs.home-manager.enable = true;

    programs.starship = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        settings = {
            add_newline = true;
            aws.disabled = true;
            gcloud.disabled = true;
        };
    };
  
    programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        colorschemes.catppuccin = {
            enable = true;
            settings.flavour = "mocha" ;
        };
        opts = {
            number = true;
            shiftwidth = 4;
            scrolloff = 8;
            tabstop = 4;
            expandtab = true;
            smartindent = true;
            wrap = false;
            cursorline = true;
            syntax = "on";
        };
        plugins = {
            cursorline = {
                enable = true;
                cursorline.timeout = null;
                cursorline.number = true;
                cursorword.enable = true;
                cursorword.minLength = 3;
            };
        };
        extraPlugins = with pkgs.vimPlugins; [
            feline-nvim
            nvim-scrollbar
            julia-vim
        ];
        extraConfigLua = "require('feline').setup() \n require('scrollbar').setup()";
    };

    programs.bash = {
        enable = true;
        enableCompletion = true;
        bashrcExtra = ''
            # extra .bashrc config goes here
        '';
    };
}
