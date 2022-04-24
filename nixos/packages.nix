{ pkgs, ... }:
{
  # https://github.com/Mic92/sops-nix
  environment.systemPackages = with pkgs;
    [ htop age speedtest-cli ];
}
