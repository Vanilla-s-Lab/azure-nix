{ pkgs, ... }:
{
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
    }
  '';
}
