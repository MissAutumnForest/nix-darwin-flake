{
  description = "Autumn's MacBook Pro Darwin system flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes repl-flake";

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;

      # Enable Touch ID for sudo
      security = {
        pam.enableSudoTouchIdAuth = true;
      };

      system = {
        defaults = {
	  NSGlobalDomain = {
	    AppleInterfaceStyle = "Dark";
	    AppleInterfaceStyleSwitchesAutomatically = false;
	  };

	  WindowManager = {
	    GloballyEnabled = true;
	    EnableStandardClickToShowDesktop = false;
	  };

	  menuExtraClock = {
	    Show24Hour = true;
	    ShowDayOfMonth = true;
	    ShowDayOfWeek = true;
	    ShowDate = 1;
	  };

	  dock = {
	    appswitcher-all-displays = true;
            autohide = true;
            mru-spaces = false;
	    show-recents = false;
	    launchanim = true;
	    mouse-over-hilite-stack = true;
	    orientation = "bottom";
	    tilesize = 48;

	    persistent-apps = [
	      "/Applications/Safari.app"
	      "/Applications/Nix Apps/Kitty.app"
	    ];

	    persistent-others = [
	      "/Users/autumn"
	    ];
	  };

	  finder = {
	    CreateDesktop = true;
            AppleShowAllExtensions = true;
	    AppleShowAllFiles = true;
            FXPreferredViewStyle = "clmv";
	    ShowPathbar = true;
	    ShowStatusBar = true;
	    QuitMenuItem = true;
	  };

	  loginwindow = {
	    GuestEnabled = false;
            LoginwindowText = "\"Somewhere, something incredible is waiting to be known.\" ― Carl Sagan";
	  };

          screencapture = {
	    location = "~/Pictures/screenshots";
	    show-thumbnail = false;
	  };

	  spaces = {
	    spans-displays = false;
	  };

	  trackpad = {
	    Clicking = false;
	    Dragging = false;
	    TrackpadThreeFingerDrag = false;
	  };
        };
        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToEscape = true;
        };

        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        stateVersion = 5;
      };

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.tree
        pkgs.wget
        pkgs.tmux
        pkgs.neovim
        pkgs.stow
        pkgs.fzf
	pkgs.oh-my-posh
	pkgs.zoxide
	pkgs.ripgrep
	pkgs.bc
	pkgs.jq
	pkgs.nerdfonts
	pkgs.kitty
      ];

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina

      #programs.git.config = {
      #  user.name = "Autumn Peacock";
      #  user.email = "MissAutumnForest@gmail.com";
      #};

      users.users.autumn = {
        name = "autumn";
        home = "/Users/autumn";
	packages = [
	  pkgs.gh
	];
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#autumn-mbp.local
    darwinConfigurations."autumn-mbp" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."autumn-mbp".pkgs;
  };
}
