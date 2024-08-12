{
  programs.i3status-rust = {
    enable = true;
    bars.bottom = {
      blocks = [
        {
          block = "disk_space";
          path = "/";
          format = " $icon $used/$total ";
          info_type = "available";
          interval = 60;
          warning = 20.0;
          alert = 10.0;
          alert_unit = "GB";
        }

        {
          block = "memory";
          format = " $icon $mem_used.eng(prefix:G)/$mem_total.eng(prefix:G) ";
          warning_mem = 70.0;
          critical_mem = 90.0;
        }

        {
          block = "cpu";
          format = " $icon $utilization ";
          format_alt = " $icon $barchart ";
          interval = 1;
        }

        {
          block = "temperature";
          interval = 10;
          format = " $icon $max ";
        }

        {
          block = "nvidia_gpu";
          format = " $icon $utilization $temperature ";
        }

        {block = "net";}

        {
          block = "sound";
          driver = "pulseaudio";
          format = " $icon $output_description{ $volume|} ";
          max_vol = 200;
          mappings = {
            "alsa_output.usb-0b0e_Jabra_SPEAK_510_USB_305075A7C4D0022000-00.analog-stereo" = "Speaker";
            "alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1.[0-9]+" = "Monitor";
          };
        }

        {
          block = "time";
          interval = 1;
          format = " $icon $timestamp.datetime(f:'%a %Y-%m-%d %T') ";
        }

        {block = "watson";}

        {
          block = "menu"; # System menu
          text = " hi ";
          items = [
            {
              display = " Sleep ";
              cmd = "systemctl suspend";
            }
            {
              display = " Power off ";
              cmd = "poweroff";
              confirm_msg = "Confirm poweroff";
            }
            {
              display = " Reboot ";
              cmd = "reboot";
              confirm_msg = "Confirm reboot";
            }
          ];
        }
      ];
      theme = "ctp-mocha";
      icons = "material-nf";
    };
  };
}
