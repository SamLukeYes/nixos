{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    onedrivegui
    (makeAutostartItem {
      name = "OneDriveGUI";
      package = onedrivegui;
    })
  ];
}