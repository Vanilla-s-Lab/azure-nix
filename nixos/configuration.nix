{ modulesPath, lib, ... }:
{
  imports = [ "${modulesPath}/virtualisation/azure-image.nix" ]
    ++ [ ./users.nix ./network.nix ./packages.nix ]
    ++ [ ./nginx.nix ./v2ray.nix ];

  networking.hostName = "NixOS-Azure";

  services.openssh.passwordAuthentication = false;
  services.openssh.challengeResponseAuthentication = false;

  # https://github.com/NixOS/nixpkgs/issues/93032
  fileSystems = lib.mkForce {
    "/" = ({ device = "/dev/disk/by-label/nixos"; }
      // { fsType = "ext4"; autoResize = true; });
  };

  # https://sysctl-explorer.net/net/ipv4/tcp_fastopen/
  boot.kernel.sysctl = { "net.ipv4.tcp_fastopen" = 2; };
}
