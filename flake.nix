{
  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  };

  outputs = { self, darwin, home-manager, nixpkgs }:
    let
      darwinSystem = { system, username }:
        darwin.lib.darwinSystem {
          modules = [
            {
              users.users.${username}.home = "/Users/${username}";
            }

            ./system/darwin.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" =
                import ./home-manager/darwin.nix;
            }
          ];

          system = system;
        };
    in {
      darwinConfigurations = {
        macbookpro-personal = darwinSystem {
          system = "aarch64-darwin";
          username = "daimyo";
        };

        macbookpro-work = darwinSystem {
          system = "aarch64-darwin";
          username = "daimyo";
        };
      };

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          modules = [
            ./system/nixosDesktop.nix
            ./system/nixos.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."daimyo" =
                import ./home-manager/nixos.nix;
            }
          ];

          system = "x86_64-linux";
        };
      };
    };
}
