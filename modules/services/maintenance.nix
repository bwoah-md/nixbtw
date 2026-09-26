{ pkgs, ... }:

{
  systemd.user.services.arkenfox-autoupdate = {
    description = "Weekly Arkenfox user.js updater for Firefox Beta";
    path = with pkgs; [ bash curl git gnutar gzip coreutils ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "update-arkenfox" ''
        FF_DIR="$HOME/.config/mozilla/firefox/okskq1om.betabtw"

        if [ -d "$FF_DIR" ]; then
          cd "$FF_DIR"
          if [ ! -f "updater.sh" ]; then
            ${pkgs.curl}/bin/curl -s -O https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh
          fi
          ${pkgs.bash}/bin/bash updater.sh -s -d
          rm -rf userjs_diffs user.js.orig user.js.bak
        fi
      '';
    };
  };

  systemd.user.timers.arkenfox-autoupdate = {
    description = "Run Arkenfox updater weekly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}
