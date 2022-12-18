{ config, pkgs, ... }:

{
  programs = {

    adb.enable = true;

    command-not-found.enable = false;

    firefox = {
      enable = true;
      policies.ExtensionSettings = {
        "langpack-zh-CN@firefox.mozilla.org" = {
          installation_mode = "normal_installed";
          install_url = "https://releases.mozilla.org/pub/firefox/releases/${config.programs.firefox.package.version}/linux-x86_64/xpi/zh-CN.xpi";
        };
      };
    };

    git.enable = true;

    gnupg.agent.enable = true;

    wireshark.enable = true;

    xonsh.enable = true;

  };
}
