{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (charles.override { jdk11 = config.programs.java.package; })

    # CLI tools
    pdftk                         # required by Jasminum
  ] ++ (if config.services.xserver.desktopManager.gnome.enable
    then [ shimeji.fhs4gnome ]
    else [ shimeji.default ]);

  programs.java.enable = true;
}