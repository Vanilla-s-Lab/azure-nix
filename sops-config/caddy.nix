{ pkgs, config, ... }:
{
  sops.secrets."caddy/handle_path".sopsFile = ../secrets/caddy.yaml;
  sops.secrets."caddy/Port".sopsFile = ../secrets/caddy.yaml;

  sops.templates."caddy".owner = "caddy";
  sops.templates."caddy".content = ''
    {
      # https://caddyserver.com/docs/caddyfile/options
      auto_https disable_redirects
    }

    # https://caddyserver.com/docs/quick-starts/static-files
    https://vanilla.scp.link {
      root * ${pkgs.nginx}/html
      file_server

      # https://caddyserver.com/docs/caddyfile/directives/reverse_proxy
      reverse_proxy \
        ${config.sops.placeholder."caddy/handle_path"} \
        https://localhost:${config.sops.placeholder."caddy/Port"} {
          header_up Host "vanilla.scp.link"
          header_up X-Forwarded-Proto "https"

          # https://github.com/v2ray/discussion/issues/705
          transport http {
            tls_insecure_skip_verify
          }
        }
    }
  '';
}
