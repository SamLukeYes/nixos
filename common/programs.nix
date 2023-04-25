{ config, pkgs }:

{
  programs = {
    adb.enable = true;

    bash.interactiveShellInit = ''
      exec ${config.programs.xonsh.package}/bin/xonsh
    '';

    command-not-found.enable = false;

    firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
      policies.DisableAppUpdate = true;
    };

    git.enable = true;

    gnupg.agent.enable = true;

    nix-index.enable = true;

    wireshark.enable = true;

    xonsh = {
      enable = true;
      package = pkgs.xonsh.overrideAttrs (oldAttrs: {
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ (with pkgs; [
          yes.xonsh-direnv
        ]);
      });
    };
  };
}
