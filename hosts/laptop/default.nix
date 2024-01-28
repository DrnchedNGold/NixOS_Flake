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

  # Power Management
  #Better scheduling for CPU cycles from System76
  services.system76-scheduler.settings.cfsProfiles.enable = true;
  
  services.tlp = {
    enable = true;
    settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # CPU_BOOST_ON_AC = 1;
        # CPU_BOOST_ON_BAT = 0;

        # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        # CPU_MIN_PERF_ON_AC = 0;
        # CPU_MAX_PERF_ON_AC = 100;
        # CPU_MIN_PERF_ON_BAT = 0;
        # CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
      #  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

    };
  };

  #Enable powertop to track power info
  powerManagement.powertop.enable = true;

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
