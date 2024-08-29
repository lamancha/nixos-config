{ config, pkgs, lib,... }:
{    
    
    imports = [
        #nixvim.nixosModules.nixvim
        nixvim.homeManagerModules.nixvim
    ];

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
};
