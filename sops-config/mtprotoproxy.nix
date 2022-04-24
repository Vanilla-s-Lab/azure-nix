{ config, ... }:
{
  sops.secrets."mtprotoproxy/Vanilla".sopsFile = ../secrets/mtprotoproxy.yaml;
  sops.secrets."mtprotoproxy/Akisamu".sopsFile = ../secrets/mtprotoproxy.yaml;
  sops.secrets."mtprotoproxy/MidAutumnMoon".sopsFile = ../secrets/mtprotoproxy.yaml;

  sops.templates."mtprotoproxy".content = ''
    PORT = 3256
    SECURE_ONLY = False

    USERS = {
        'Vanilla': '${config.sops.placeholder."mtprotoproxy/Vanilla"}',
        'Akisamu': '${config.sops.placeholder."mtprotoproxy/Akisamu"}',
        'MidAutumnMoon': '${config.sops.placeholder."mtprotoproxy/MidAutumnMoon"}'
    }
  '';
}
