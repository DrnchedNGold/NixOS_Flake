#
#  Gaming: Steam + MC
#  Do not forget to enable Steam play for all title in the settings menu
#

{ config, pkgs, nur, lib, vars, ... }:

{
  environment = { 
    systemPackages = [
      pkgs.steam # Game Launcher
      pkgs.lutris # Game Launcher
      # pkgs.heroic # Game Launcher
      # pkgs.prismlauncher # MC Launcher
      # pkgs.retroarchFull # Emulator
      # pcsx2 # Emulator

      pkgs.mangohud  # Overlay System Info
      pkgs.protonup
    ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/varun/.steam/root/compatibilitytools.d";
    };

  };

  programs = {
    steam = {
      enable = true;
      # remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
    # Better Gaming Performance
    # Steam: Right-click game - Properties - Launch options: gamemoderun %command%
    # Lutris: General Preferences - Enable Feral GameMode
    #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so

    # NOTE: gamemode, gamescope, and mangohud need to be specifically added to each game's launch options
    # Ex. gamemoderun %commmand%, mangohud %command%, or gamescope %command% in "Launch Options" in steam
  };

#   nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
#     "steam"
#     "steam-original"
#     "steam-runtime"
#   ];
}