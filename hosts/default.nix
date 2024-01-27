#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix
#   └─ ./hosts
#       ├─ default.nix *
#       ├─ configuration.nix
#       └─ ./<host>.nix
#           └─ default.nix
#

{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, vars, ... }:  # import inherited inputs from flake.nix

let
  system = "x86_64-linux";                                  # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow Proprietary Software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in 
{
  laptop  = lib.nixosSystem {                   # Laptop profile
    inherit system;

    specialArgs = {
      inherit inputs unstable vars;
      host = {
        hostName = "laptop";
      };
    };

    modules = [                                  # Modules that are used
      ./laptop
      ./configuration.nix           # will be universal to all hosts

      home-manager.nixosModules.home-manager {   # Home-Manager module that is used
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        # home-manager.users.${vars.user} = {
        #   imports = [(import ./home.nix)] ++ [(import ./laptop/home.nix)];   # concatenates/uses both home.nix files
        # };
      }
   ];
  };

  # other hosts/configurations (ex. desktop, vm, etc.)

}
