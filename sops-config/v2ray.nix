{ lib, config, ... }:
let home = "/var/lib/caddy"; in
let caddy = "/.local/share/caddy"; in
let acme = "acme-v02.api.letsencrypt.org"; in
let domain = "vanilla.scp.link"; in
{
  sops.secrets."v2ray/port".sopsFile = ../secrets/v2ray.yaml;
  sops.secrets."v2ray/id".sopsFile = ../secrets/v2ray.yaml;
  sops.secrets."v2ray/path".sopsFile = ../secrets/v2ray.yaml;

  sops.templates."v2ray".content = (builtins.toJSON {
    inbounds = (lib.singleton {
      port = config.sops.placeholder."v2ray/port";
      listen = "127.0.0.1";

      protocol = "vless";
      settings = {
        decryption = "none";
        clients = (lib.singleton {
          id = config.sops.placeholder."v2ray/id";
        });
      };

      streamSettings = {
        network = "h2";
        security = "tls";

        httpSettings = {
          path = config.sops.placeholder."v2ray/path";
          host = (lib.singleton "vanilla.scp.link");
        };

        tlsSettings = {
          serverName = "vanilla.scp.link";
          certificates = (lib.singleton {
            certificateFile = "${home}${caddy}/certificates/${acme}-directory/${domain}/${domain}.crt";
            keyFile = "${home}${caddy}/certificates/${acme}-directory/${domain}/${domain}.key";
          });
        };
      };
    });

    outbounds = (lib.singleton {
      protocol = "freedom";
      settings = {
        mux = {
          enabled = true;
        };
      };
    });
  });
}
