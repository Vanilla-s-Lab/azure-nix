{ modulesPath, lib, ... }:
{
  imports = [ "${modulesPath}/virtualisation/azure-image.nix" ]
    ++ [ ./users.nix ./network.nix ./packages.nix ];

  # https://sysctl-explorer.net/net/ipv4/tcp_fastopen/
  boot.kernel.sysctl = { "net.ipv4.tcp_fastopen" = 2; };
}
