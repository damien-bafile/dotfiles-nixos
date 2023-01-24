{ config, pkgs, ... }:
let
  nix = import ./shared/nix.nix { inherit pkgs; };
  nixpkgs = import ./shared/nixpkgs.nix { enablePulseAudio = true; };
  systemPackages = import ./shared/systemPackages.nix {
    inherit pkgs;
    extraPackages = with pkgs; [
      dunst
      libnotify
      lxappearance
      pavucontrol
      xclip
    ];
  };
in {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
      };
    };

    fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Meslo" ]; }) ];
  };

  environment = {
    pathsToLink = [ "/libexec" "/share/zsh" ];
    systemPackages = systemPackages;
  };

  hardware = {
    nvidia = {
      modesetting.enable = false;
    };
  
    pulseaudio.enable = false;

    opengl = {
      enable = true;
      extraPackages = with pkgs; [ vaapiVdpau ];
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  
  # systemd.services.nvidia-control-devices = {
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
  # };

  # Set your time zone.
  time.timeZone = "Australia/Perth";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  networking = {
    firewall.enable = false;
    hostName = "daimyo-nixos";
    interfaces.ens33.useDHCP = true;
    networkmanager.enable = true;
    useDHCP = false;
  };

  nix = nix;

  nixpkgs = nixpkgs;

  programs = {
    dconf.enable = true;
    geary.enable = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services = {

    logind.extraConfig = ''
      RuntimeDirectorySize=20G
    '';
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    
    # openssh = {
    #   enable = true;
    #   passwordAuthentication = false;
    #   permitRootLogin = "no";
    # };

    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [
        "nvidia"
      ];

      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "fill";
      };

      displayManager = {
        autoLogin = {
          enable = true;
          user = "daimyo";
        };
        defaultSession = "none+i3";
        lightdm.enable = true;
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [ i3status i3lock i3blocks ];
      };
    };
  };

  sound.enable = true;

  system.stateVersion = "22.11";

  users = {
    mutableUsers = false;

    users.daimyo = {
      hashedPassword = "";
      extraGroups = [ "audio" "docker" "wheel" ];
      home = "/home/daimyo";
      isNormalUser = true;
      # openssh.authorizedKeys.keys = [
      #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJs7Z5a/QPZPaly3N79Ns4qL73k9XMACmqH8H03gHMXf" # iPad
      # ];
      shell = pkgs.zsh;
    };
  };

  virtualisation = {
    containerd = {
      enable = true;
    };
  };

  #docker.enable = true;
}
