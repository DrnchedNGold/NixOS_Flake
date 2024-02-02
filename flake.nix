#
#  flake.nix *
#   ├─ ./hosts
#   │   └─ default.nix
#   ├─ ./darwin
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix
#

{
  description = "Varun's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixos-hardware.url = "github:nixos/nixos-hardware/master";            # Hardware Specific Configurations
    
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {                                   # Fixes OpenGL With Other Distros.
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {                                           # Official Hyprland Flake
      url = "github:hyprwm/Hyprland";                      # Requires "hyprland.nixosModules.default" to be added the host modules
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixgl, ... }@inputs:  # selects what to evaluate from inputs section
    let                                        # Variables that can be used in the config files
      vars = {
        user = "varun";
        location = "$HOME/nixos-config";
        terminal = "kitty";
        editor = "nvim";
      };
    in {                                      # Use above variables in ...

      nixosConfigurations = (                 # NixOS Configurations
        import ./hosts {                      # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager vars;   # Inherit inputs so that they can be used in ./hosts to evaluate the files there
        }
      );

      homeConfigurations = (                                                # Nix Configurations
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager nixgl vars;
        }
      );

    };

}
