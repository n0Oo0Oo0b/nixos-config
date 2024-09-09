{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../home/vscode.nix
    ../../home/git.nix
    ../../home/ranger.nix
    ../../home/i3
    # ../../home/nvim
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  home.username = "danielgu";
  home.homeDirectory = "/home/danielgu";

  # i18n.inputMethod.fcitx5.catppuccin.apply = true;

  # NOTE: Check home-manager release notes before changing
  home.stateVersion = "23.11";

  nix.settings = {
    keep-outputs = true;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;
  nixpkgs.overlays = [
    (final: prev: {
      opencv = prev.opencv.override {enableCuda = false;};
    })
  ];

  home.packages = with pkgs; [
    # General use
    firefox
    obsidian
    youtube-music
    libreoffice
    slack
    (pkgs.discord.override {withTTS = true;})
    zoom-us
    zotero
    anki-bin

    # Dev
    python311
    # neovide
    zed-editor

    # Commandline
    porsmo
    ripgrep
    du-dust
    mprocs
    neovim

    # Misc
    ffmpeg
    pandoc
    texliveFull
    alejandra
    pulseaudio
    osu-lazer-bin

    # Scripts
    (writeShellScriptBin "set-sink" ''
      NAME=$1
      ''${NAME:="hdmi"}

      OUTPUT=$(pactl list short sinks | rg -S "$NAME" | head -n1 | awk '{print $2}')
      if [ -n "$OUTPUT" ]; then
        pactl set-default-sink $OUTPUT
        echo "Default sink set to '$OUTPUT'"
      else
        echo "Sink not found"
      fi
    '')
  ];

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  gtk = {
    enable = true;
    catppuccin.enable = true;
    catppuccin.icon.enable = true;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    gtk2.extraConfig = "gtk-application-prefer-dark-theme=true";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 12;
    };
    settings = {
      disable_ligatures = "cursor";
    };
  };

  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.eza.enable = true;
  programs.gitui.enable = true;
  programs.sioyek.enable = true;
  programs.starship.enable = true;
  programs.starship.settings = let
    nerdfont = builtins.fromTOML (builtins.readFile ../../extras/starship-nerdfont.toml);
  in
    lib.recursiveUpdate nerdfont {
      os.disabled = false;
    };
  programs.watson.enable = true;
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      input-overlay
    ];
  };

  # Dotfiles
  home.file = {
    ".ideavimrc".text = ''
      imap <C-Space> <Right><Esc>
      vmap <C-Space> <Esc>

      nmap H ^
      nmap L $

      imap <C-l> <Right><BS>

      nmap g<CR> :action ShowIntentionActions<CR>
      :command! R action Run
      :command! RC action RunClass
      :command! Fmt action ShowReformatFileDialog

      set ideajoin
    '';

    ".bashrc".text = ''
      eval $(ssh-agent) &>/dev/null

      eval "$(starship init bash)"

      alias ls=eza
      alias cat=bat
      alias glo="git log --oneline"
    '';

    ".background-image".source = ../../extras/wallpapers/nixos-nord.jpg;
  };

  xdg.configFile = {
    # "nvim" = {
    #   source = ../../extras/nvim;
    #   recursive = true;
    # };

    "zellij/config.kdl".source = ../../extras/zellij.kdl;

    "zoomus.conf".source = ../../extras/zoomus.conf;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # home.shellAliases = {
  #   "ls" = "eza";
  #   "cat" = "bat";
  #
  #   "glo" = "git log --oneline";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
