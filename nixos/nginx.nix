{ lib, ... }:
{
  services.nginx.enable = true;
  services.nginx.virtualHosts."vanilla.scp.link".enableACME = true;
  services.nginx.virtualHosts."vanilla.scp.link".addSSL = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme.acceptTerms = true;
  security.acme.email = "osu_Vanilla@126.com";

  # services.nginx.recommended*
  services.nginx.recommendedTlsSettings = true;
  services.nginx.recommendedProxySettings = true;
  services.nginx.recommendedOptimisation = true;
  services.nginx.recommendedGzipSettings = true;
}
