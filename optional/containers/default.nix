{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kubernetes-helm
  ];

  services.k3s.enable = true;
}