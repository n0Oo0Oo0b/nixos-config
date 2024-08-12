{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./i3status-rust.nix
  ];

  xsession = {
    enable = true;

    windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        fonts = {
          names = ["JetBrains Mono Nerd Font"];
          style = "Regular";
          size = 11.0;
        };
        terminal = "kitty";

        gaps.inner = 10;
        gaps.outer = 5;

        keybindings = let
          pactl = "${pkgs.pulseaudio}/bin/pactl";
          playerctl = "${pkgs.playerctl}/bin/playerctl";
          mod = config.xsession.windowManager.i3.config.modifier;
        in
          lib.mkOptionDefault {
            "XF86AudioRaiseVolume" = "exec --no-startup-id ${pactl} set-sink-volume 0 +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id ${pactl} set-sink-volume 0 -5%";
            "XF86AudioMute" = "exec --no-startup-id ${pactl} set-sink-mute 0 toggle";

            "XF86AudioPlay" = "exec ${playerctl} play";
            "XF86AudioPause" = "exec ${playerctl} pause";
            "XF86AudioNext" = "exec ${playerctl} next";
            "XF86AudioPrev" = "exec ${playerctl} previous";

            "${mod}+i" = "focus up";
            "${mod}+shift+i" = "move up";
            "${mod}+j" = "focus left";
            "${mod}+shift+j" = "move left";
            "${mod}+k" = "focus down";
            "${mod}+shift+k" = "move down";
            "${mod}+l" = "focus right";
            "${mod}+shift+l" = "move right";
          };

        bars = [
          {
            position = "bottom";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
          }
        ];
      };

      extraConfig = ''
        exec_always --no-startup-id ${pkgs.feh}/bin/feh --bg-fill $HOME/.background-image
        exec --no-startup-id ${pkgs.picom}/bin/picom -b
        exec --no-startup-id ${pkgs.flameshot}/bin/flameshot
        exec --no-startup-id fcitx5 -d
      '';
    };

    initExtra = ''
      LEFT='DP-2'
      RIGHT='DP-4'
      ${pkgs.xorg.xrandr}/bin/xrandr --output $RIGHT --primary --right-of $LEFT --mode 2560x1440 --rate 144 --output $LEFT --mode 1920x1080 --rate 75 --rotate left
      ${pkgs.xorg.xrandr}/bin/xrandr --output $RIGHT --pos 1080x240
    '';
    profileExtra = ''
      ${pkgs.noisetorch}/bin/noisetorch -i
      ${pkgs.openrgb}/bin/openrgb -p default
    '';
  };

  services.picom = {
    enable = true;
    activeOpacity = 0.95;
    inactiveOpacity = 0.9;
    menuOpacity = 0.9;
  };

  services.flameshot.enable = true;
}
