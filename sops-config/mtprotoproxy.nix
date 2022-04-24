{ ... }:
{
  sops.secrets."mtprotoproxy/vanilla".sopsFile = ../secrets/mtprotoproxy.yaml;
  sops.secrets."mtprotoproxy/akisamu".sopsFile = ../secrets/mtprotoproxy.yaml;
}
