{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

        anyrun = {
            url = "github:Kirottu/anyrun";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        wallpapers = {
            url = "github:ryan4yin/wallpapers";
            flake = false;
        };

        nixvim = {
            url = "github:nix-community/nixvim/nixos-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        lanzaboote = {
            url = "github:nix-community/lanzaboote/v0.4.1";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        catppuccin.url = "github:catppuccin/nix";
    };

    outputs = { self, nixpkgs, lanzaboote, home-manager, nixvim, catppuccin, anyrun, ... }@inputs: {
        nixosConfigurations.virtnix = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./hosts/virtnix.nix
                home-manager.nixosModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.markus = {
                            imports = [
                                ./home/markus/home.nix
                                catppuccin.homeManagerModules.catppuccin
                                nixvim.homeManagerModules.nixvim
                            ];
                        };
                    };
                }
            ];
        };

        nixosConfigurations.earendil = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                lanzaboote.nixosModules.lanzaboote
                catppuccin.nixosModules.catppuccin
                ./hosts/earendil.nix
                home-manager.nixosModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.markus = {
                            imports = [
                                ./home/markus/home.nix
                                catppuccin.homeManagerModules.catppuccin
                                nixvim.homeManagerModules.nixvim
                                #anyrun.homeManagerModules.default
                            ];
                        };
                        #extraSpecialArgs = {
                        #    inherit anyrun;
                        #};
                    };
                }
            ];
        };
    };
}
