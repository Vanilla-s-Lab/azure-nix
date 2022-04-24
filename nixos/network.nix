{ lib, ... }:
{
  networking.firewall.allowPing = false;

  services.fail2ban.enable = true;
  services.fail2ban.bantime-increment.enable = true;

  services.nginx.enable = true;
  services.nginx.virtualHosts."vanilla.scp.link" =
    ({ /* addSSL = true; */ enableACME = true; } // { onlySSL = true; });
  networking.firewall.allowedTCPPorts = (lib.singleton 443);

  security.acme.acceptTerms = true;
  security.acme.email = "osu_Vanilla@126.com";
}
