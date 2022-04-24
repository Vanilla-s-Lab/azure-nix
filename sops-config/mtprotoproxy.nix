{ config, ... }:
{
  sops.secrets."mtprotoproxy/vanilla".sopsFile = ../secrets/mtprotoproxy.yaml;
  sops.secrets."mtprotoproxy/akisamu".sopsFile = ../secrets/mtprotoproxy.yaml;

  sops.templates."mtprotoproxy".content = ''
    PORT = 3256
    SECURE_ONLY = False
    USERS = {'vanilla': '${config.sops.placeholder."mtprotoproxy/vanilla"}',
             'akisamu': '${config.sops.placeholder."mtprotoproxy/akisamu"}'}
  '';
}
