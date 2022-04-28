{ ... }:
{
  services.nginx.enable = true;
  services.nginx.virtualHosts."vanilla.scp.link" = {
    addSSL = true;
    enableACME = true;
  };

  security.acme.email = "osu_Vanilla@126.com";
  security.acme.acceptTerms = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
