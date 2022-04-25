{ config, ... }:
{
  services.v2ray.enable = true;
  services.v2ray.configFile =
    config.sops.templates."v2ray".path;
}
