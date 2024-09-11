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

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/programs/games.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

#   boot.loader.grub = {
#     enable = true;
# #     device = "/dev/sda";
#     useOSProber = true;
#
#     devices = ["nodev"];
#     efiSupport = true;
#   };

# Power Management Settings (START)
  powerManagement.enable = true;
  #Enable powertop to track power info
  powerManagement.powertop.enable = true;
  #Better scheduling for CPU cycles from System76
  services.system76-scheduler.settings.cfsProfiles.enable = true;
  
  # tlp Settings (START)
  services.tlp = {
    enable = true;
    settings = {
        # Always runs on Battery (peformance mode on AC is making laptop run hot)
        TLP_DEFAULT_MODE = "BAT";
        TLP_PERSISTENT_DEFAULT = 1;

        # CPU_SCALING_GOVERNOR_ON_AC = "performance";
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
  #Disables power profiles daemon (needed to no conflict with tlp)
  services.power-profiles-daemon.enable = false;
  # tlp Settings (END)

  # auto-cpufreq Settings (START)
  # services.auto-cpufreq.enable = true;
  # services.auto-cpufreq.settings = {
  #   battery = {
  #     governor = "powersave";
  #     turbo = "never";
  #   };
  #   charger = {
  #     governor = "performance";
  #     turbo = "auto";
  #   };
  # };
  # auto-cpufreq Settings (END)
# Power Management Settings (END)

  environment.systemPackages = [
    # This one is simpler, configured with json and css
    pkgs.waybar

    (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )

    # You can make your own crazy bar with Elkowar's widgets
    # It has it's own markup language
    # pkgs.eww

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
    # wofi      # gtk rofi
    # bmenu
    # fuzzel
    # tofi

  ];

  hardware = {
    # Opengl? (options were renamed)
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  
# NVIDIA SETTINGS (START)
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" "displaylink" "modesetting" ];

  hardware.nvidia = {
    # Most wayland compositors need this
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;  

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;


    # FOR LAPTOP ONLY (Hybrid Graphics Nvidia Optimus PRIME)
    prime = {
      # Enable sync mode (better performance, use when plugged in to wall)
      # sync.enable = true;

      # Enable offload mode (generally for normal use)
      offload = {
        enable = true;
        # provides wrapper shell script that will tell the dedicated gpu (nvidia) to take over
        # GENERAL: $ nvidia-offload some-game
        # STEAM: $ nvidia-offload %command%
        enableOffloadCmd = true;
      };

      # Make sure to use the correct Bus ID values for your system! (check nixos nvidia wiki)
      # Get PCI info using this command: $ nix shell nixpkgs#pciutils -c lspci | grep ' VGA '
      # integrated
      amdgpuBusId = "PCI:7:0:0";
      # dedicated
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # specialisation that generates two entries for every generation/boot that allows you to choose between sync and offload modes
  specialisation = {
    gaming-time.configuration = {
      hardware.nvidia = {
        prime = {
          sync.enable = true;
          offload = {
            enable = lib.mkForce false;
            enableOffloadCmd = lib.mkForce false;
          };
        };
      };
    };
  };

# Hyprland (START) (search Hyprland for all related sections)
  # for NON-nvidia ONLY THIS LINE REQUIRED
  # programs.hyprland.enable = true;

  # Desktop portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # If your cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
# Hyperland (END) (not really - parts in other sections)

# Apps Settings (START)
  # asusctl (START)
  services.asusd = {
    enable = true;
    # enableUserService = true;   # don't know what this does so check
  };
# Apps Settings (END)
}
