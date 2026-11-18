{ ... }:
{
  programs.bash = {
    enable = true;
    completion.enable = true;
    blesh.enable = true;

    interactiveShellInit = ''
      # History
      HISTSIZE=10000
      HISTFILESIZE=100000
      HISTCONTROL=ignoredups:ignorespace
      shopt -s histappend

      # History Timestamps
      HISTTIMEFORMAT="%F %T "
    '';
  };
}
