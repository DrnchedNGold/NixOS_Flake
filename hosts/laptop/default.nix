#
#  Specific system configuration settings for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./laptop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ bspwm.nix
#           └─ ./virtualisation
#               └─ docker.nix
#

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
#     device = "/dev/sda";
    useOSProber = true;

    devices = ["nodev"];
    efiSupport = true;
  };

  # Hyprland
  # for NON-nvidia ONLY THIS LINE REQUIRED
  programs.hyprland.enable = true;

  environment.systemPackages = [
    # This one is simpler, configured with json and css
    pkgs.waybar

    (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )

    # You can make your own crazy bar with Elkowar's widgets
    # It has it's own markup language
    #pkgs.eww

    # notification daemon
    pkgs.dunst
    pkgs.libnotify

    # Wallpaper daemons
    # hyprpaper
    # swaybg
    # wpaperd
    # mpvpaper
    pkgs.swww

    # App Launchers
    pkgs.rofi-wayland    # Most popular
    # wofi
    # bmenu
    # fuzzel
    # tofi

  ];

  # Desktop portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # programs.hyprland = {
  #   enable = true;
  #   nvidiaPatches = true;
  #   xwayland.enable = true;
  # };

  # environment.sessionVariables = {
  #   # If your cursor becomes invisible
  #   # WLR_NO_HARDWARE_CURSORS = "1";
  #   # Hint electron apps to use wayland
  #   NIXOS_OZONE_WL = "1";
  # };

  # hardware = {
  #   # Opengl
  #   opengl = {
  #     enable = true;
  #     driSupport = true;
  #     driSupport32Bit = true;
  #   };

  #   # Load nvidia driver for Xorg and Wayland
  #   services.xserver.videoDrivers = [ "nvidia" ];

  #   nvidia = {
  #     # Most wayland compositors need this
  #     modesetting.enable = true;

  #     # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  #     powerManagement.enable = false;
  #     # Fine-grained power management. Turns off GPU when not in use.
  #     # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  #     powerManagement.finegrained = false;

  #     # Use the NVidia open source kernel module (not to be confused with the
  #     # independent third-party "nouveau" open source driver).
  #     # Support is limited to the Turing and later architectures. Full list of 
  #     # supported GPUs is at: 
  #     # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
  #     # Only available from driver 515.43.04+
  #     # Currently alpha-quality/buggy, so false is currently the recommended setting.
  #     open = false;

  #     # Enable the Nvidia settings menu,
  #     # accessible via `nvidia-settings`.
  #     nvidiaSettings = true;

  #     # Optionally, you may need to select the appropriate driver version for your specific GPU.
  #     package = config.boot.kernelPackages.nvidiaPackages.stable;


  #     # FOR LAPTOP ONLY (Hybrid Graphics Nvidia Optimus PRIME)
  #     prime = {
  #       # Make sure to use the correct Bus ID values for your system!

  #     };

  #   };

  # };

}
