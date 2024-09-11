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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";  # Nix Packages (Default)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Unstable Nix Packages
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05"; # Stable Nix Packages
    # nixos-hardware.url = "github:nixos/nixos-hardware/master";            # Hardware Specific Configurations
    
    # User Environment Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # # Unstable User Environment Manager
    # home-manager-unstable = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    # Stable User Environment Manager
    # home-manager-stable = {
    #   url = "github:nix-community/home-manager/release-24.05";
    #   inputs.nixpkgs.follows = "nixpkgs-stable";
    # };

    # NUR Community Packages
    nur = {
      url = "github:nix-community/NUR";
      # Requires "nur.nixosModules.nur" to be added to the host modules
    };

    nixgl = {                                   # Fixes OpenGL With Other Distros.
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland = {                                           # Official Hyprland Flake
    #   url = "github:hyprwm/Hyprland";                      # Requires "hyprland.nixosModules.default" to be added the host modules
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    
  };

  # replace all instances of nixpkgs-stable with nixpkgs-unstable depending on which is used above
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nur, nixgl, ... }@inputs:  # selects what to evaluate from inputs section
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
          inherit inputs nixpkgs nixpkgs-unstable home-manager nur vars;   # Inherit inputs so that they can be used in ./hosts to evaluate the files there
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
