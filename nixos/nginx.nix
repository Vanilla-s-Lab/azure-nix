{ ... }:
{
  services.nginx.enable = true;
  services.nginx.virtualHosts."vanilla.scp.link" =
    ({ addSSL = true; enableACME = true; } // {
      # https://github.com/yujincheng08/BiliRoaming/wiki/%E8%87%AA%E5%BB%BA%E8%A7%A3%E6%9E%90%E6%9C%8D%E5%8A%A1%E5%99%A8
      locations."/pgc/player/api/playurl".proxyPass = "https://api.bilibili.com";
    });

  security.acme.defaults.email = "osu_Vanilla@126.com";
  security.acme.acceptTerms = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
