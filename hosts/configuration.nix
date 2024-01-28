#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ configuration.nix *
#   └─ ./modules
#       ├─ ./desktops
#       │   └─ default.nix
#       ├─ ./editors
#       │   └─ default.nix
#       ├─ ./hardware
#       │   └─ default.nix
#       ├─ ./programs
#       │   └─ default.nix
#       ├─ ./services
#       │   └─ default.nix
#       ├─ ./shell
#       │   └─ default.nix
#       └─ ./theming
#           └─ default.nix
#
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, unstable, inputs, vars, ... }:


let 
  terminal = pkgs.${vars.terminal};
in
{
  imports = ( import ../modules/desktops ++
              import ../modules/editors ++
              import ../modules/hardware ++
              import ../modules/programs ++
              import ../modules/services ++
              import ../modules/shell ++
              import ../modules/theming );

  
# UEFI (used for larger boot drives and dual booting with Windows)
  
  # Default UEFI setup
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # boot.loader = {
  #   # efi = {
  #     # canTouchEfiVariables = true;
  #     # efiSysMountPoint = "/boot/efi";   # /boot will probably work too
  #   # };
  #   grub = {
  #     # lines in default setup can be removed
  #     enable = true;
  #     #device = ["nodev"];    # Generate boot menu but not actually installed
  #     devices = ["nodev"];    # Install grub
  #     efiSupport = true;
  #     useOSProber = true;     #  or use extraEntries
  #     # extraEntries = ''
  #     #   menuentry "Windows 10" {
  #     #     chainloader (hd0,1)+1
  #     #   }
  #     # '';
  #   };
  #   # OSProber will probably not find Windows partition on first install
  # };
# UEFI setup end

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${vars.user} = {
    isNormalUser = true;
    description = "${vars.user}";
    extraGroups = [ "networkmanager" "wheel"   "video" "audio" "camera" "lp" "scanner" ];
    #shell = pkgs.zsh;             # Default shell

    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "varun";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };

    systemPackages = with pkgs; [       # System-Wide Packages
    
     # Essentials
     kitty            # Terminal Emulator
     btop             # Resource Manager
     git              # Version Control
     ranger           # File Manager
     lshw             # Hardware Config
     wget             # Retriever
     neofetch         # Cool System Info
     curl
     unzip

     # Hardware
     bluez    # Bluetooth support
     ntfs3g   # NTFS driver to allow writing to Windows
     
     # Editors
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     neovim
     vscode

     # Browsers
     chromium
     vivadli

     # Apps
     discord

     # Programming Languages
     
     # Other Packages Found @
     # - ./<host>/default.nix
     # - ../modules
    ] ++
    (with unstable; [
      # Apps
      #firefox        # Browser
    ]);
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

######## MY CHANGES ###################################################################################

nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Home-Manager Settings
home-manager.users.${vars.user} = {
  home = {
    stateVersion = "23.11";
  };
  programs = {
    home-manager.enable = true;
  };
};

# Bluetooth
hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  package = pkgs.bluez;
};

# Garbage Collection

# Overlays
nixpkgs.overlays = [

  # update Discord faster
  (self: super: {
    discord = super.discord.overrideAttrs (
      _: { src = builtins.fetchTarball {
        url = "https://discord.com/api/download?platform=linux&format=tar.gz";
        sha256 = "15pf4nmmawfc5zcpb0dkychxb8z7bvd0ssc84czjmnh3x07wz770";  # 52 0's and run if sha256 is unknown
      }; }
    );
  })

  # other overlays

];


}
