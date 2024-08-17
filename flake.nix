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
    };

    outputs = { self, nixpkgs, home-manager, nixvim, anyrun, ... }@inputs: {
        nixosConfigurations.virtnix = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./hosts/virtnix.nix
                home-manager.nixosModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.markus = import ./home/markus/home.nix;
                        extraSpecialArgs = {
                            inherit nixvim;
                        };
                    };
                }
            ];
        };

        nixosConfigurations.earendil = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./hosts/earendil.nix
                home-manager.nixosModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.markus = import ./home/markus/home.nix;
                        extraSpecialArgs = {
                            inherit nixvim;
                            inherit anyrun;
                        };
                    };
                }
            ];
        };
    };
}
