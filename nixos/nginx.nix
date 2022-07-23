{ pkgs, ... }:
{
  services.nginx.enable = true;
  services.nginx.package = pkgs.nginxQuic;
  services.nginx.virtualHosts."vanilla.scp.link" =
    ({ addSSL = true; /* onlySSL = true; */ enableACME = true; }
      // { http2 = true; http3 = true; kTLS = true; });

  services.nginx.recommendedOptimisation = true;
  services.nginx.recommendedTlsSettings = true;
  services.nginx.recommendedGzipSettings = true;
  services.nginx.recommendedProxySettings = true;

  security.acme.defaults.email = "osu_Vanilla@126.com";
  security.acme.acceptTerms = true;

  # addSSL = true; onlySSL = false; for ACME auth!
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
