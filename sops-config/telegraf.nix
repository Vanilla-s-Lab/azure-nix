{ config, ... }:
{
  sops.secrets."telegraf/EnvironmentFile".sopsFile = ../secrets/telegraf.yaml;

  # sops.templates."telegraf".owner = "telegraf";
  sops.templates."telegraf".content = ''
    ${config.sops.placeholder."telegraf/EnvironmentFile"}
  '';
}
