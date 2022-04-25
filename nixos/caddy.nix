{ lib, pkgs, config, ... }:
{
  services.caddy.enable = true;
  networking.firewall.allowedTCPPorts = [ 443 ];

  # https://caddyserver.com/docs/getting-started
  systemd.services.caddy.serviceConfig.ExecStart = lib.mkForce ''
    ${pkgs.caddy}/bin/caddy run \
      --config ${config.sops.templates."caddy".path} \
      --adapter caddyfile
  '';
}
