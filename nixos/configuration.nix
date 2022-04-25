{ modulesPath, lib, ... }:
{
  imports = [ "${modulesPath}/virtualisation/azure-image.nix" ]
    ++ [ ./users.nix ./network.nix ./packages.nix ]
    ++ [ ./v2ray.nix ./caddy.nix ]
    ++ [ ../sops-config/mtprotoproxy.nix ]
    ++ [ ../sops-config/caddy.nix ]
    ++ [ ../sops-config/v2ray.nix ]
    ++ [ ../sops-config/telegraf.nix ];

  networking.hostName = "NixOS-Azure";
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

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
