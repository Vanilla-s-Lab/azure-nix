{ lib, pkgs, config, ... }:
{
  networking.firewall.allowPing = false;

  services.fail2ban.enable = true;
  services.fail2ban.bantime-increment.enable = true;

  services.mtprotoproxy.enable = true;
  services.mtprotoproxy.users = { };

  systemd.services."mtprotoproxy".serviceConfig.ExecStart =
    lib.mkForce "${pkgs.mtprotoproxy}/bin/mtprotoproxy ${config.sops.templates."mtprotoproxy".path}";
  systemd.services."mtprotoproxy".serviceConfig.DynamicUser = lib.mkForce false;

  networking.firewall.allowedTCPPorts =
    (lib.singleton config.services.mtprotoproxy.port);

  services.influxdb2.enable = true;
  services.influxdb2.settings = {
    http-bind-address = "127.0.0.1:8086";
  };
}
