{
  pkgs,
  lib,
  ...
}: let
  withIntegration = other:
    {
      enable = true;
      enableNushellIntegration = true;
    }
    // other;
in rec {
  # Base
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 12;
    };
    settings = {
      disable_ligatures = "cursor";
      shell = "nu";
    };
  };

  programs.nushell = {
    enable = true;
    # Manual shell stuff
    shellAliases = home.shellAliases;
    extraEnv = builtins.concatStringsSep "\n" (
      lib.attrsets.mapAttrsToList
      (name: value: "$env.${name} = \"${toString value}\"")
      home.sessionVariables
    );
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;
    ZELLIJ_AUTO_ATTACH = "true";
    ZELLIJ_AUTO_EXIT = "true";
    SHELL = "${pkgs.nushell}";
  };

  home.shellAliases = {
    glo = "git log --oneline";
    gs = "git status";
  };

  # Terminal programs
  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.carapace = withIntegration {};
  programs.direnv = withIntegration {nix-direnv.enable = true;};
  programs.eza = withIntegration {};
  programs.gitui.enable = true;
  programs.keychain = withIntegration {keys = ["id_ed25519"];};
  programs.nix-index.enable = true;
  programs.ranger.enable = true;
  programs.sioyek.enable = true;
  programs.starship = withIntegration {
    settings =
      lib.recursiveUpdate
      (builtins.fromTOML (builtins.readFile ../extras/starship-nerdfont.toml)) {
        os.disabled = false;
      };
  };
  programs.watson.enable = true;
  programs.zellij.enable = true;
  programs.zoxide = withIntegration {};
}
