{ pkgs, ... }:

let
  syncthingtrayPkg = pkgs.syncthingtray-minimal;
in {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    systemService = false;
  };

  systemd.user.services.syncthing = {
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      RestartSteps = 3;
      RestartMaxDelaySec = 60;
    };
  };

  environment.systemPackages = with pkgs; [
    syncthing
    syncthingtrayPkg
    (makeAutostartItem {
      name = "syncthingtray";
      package = syncthingtrayPkg;
    })
  ];

  users.persistence = {
    directories = [
      ".config/syncthing"
    ];
    files = [
      {
        file = ".config/syncthingtray.ini";
        how = "symlink";
      }
    ];
  };
}