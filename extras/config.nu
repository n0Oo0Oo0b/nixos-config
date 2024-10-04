def start_zellij [] {
  if 'ZELLIJ' not-in ($env | columns) {
    if 'ZELLIJ_AUTO_ATTACH' in ($env | columns) and $env.ZELLIJ_AUTO_ATTACH == 'true' {
      zellij attach -c
    } else {
      zellij
    }
    if 'ZELLIJ_AUTO_EXIT' in ($env | columns) and $env.ZELLIJ_AUTO_EXIT == 'true' {
      exit
    }
  }
}

$env.PROMPT_INDICATOR_VI_NORMAL = " \n❮ "
$env.PROMPT_INDICATOR_VI_INSERT = " \n❯ "
$env.PROMPT_MULTILINE_INDICATOR = ""

$env.config = {
  show_banner: false,
  edit_mode: vi,
}
