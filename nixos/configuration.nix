{ modulesPath, lib, pkgs, ... }:
{
  imports = [ "${modulesPath}/virtualisation/azure-image.nix" ]
    ++ [ ./network.nix ./v2ray.nix ./nginx.nix ]
    ++ [ ../sops-config/mtprotoproxy.nix ]
    ++ [ ../sops-config/v2ray.nix ];

  boot.kernelPackages = pkgs.linuxPackages_lqx;
  boot.initrd.availableKernelModules = [ "tcp_bbr2" ];
  boot.kernel.sysctl."net.core.default_qdisc" = "fq";
  boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr2";

  users.defaultUserShell = pkgs.fish;
  users.users.root.openssh.authorizedKeys.keyFiles =
    (lib.singleton ../ssh-rsa.pub);

  networking.hostName = "NixOS-Azure";
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

  services.openssh.passwordAuthentication = false;
  services.openssh.kbdInteractiveAuthentication = false;

  # https://github.com/Mic92/sops-nix
  environment.systemPackages = with pkgs;
    [ htop age speedtest-cli jq wget ];

  # https://github.com/NixOS/nixpkgs/issues/93032
  fileSystems = lib.mkForce {
    "/" = ({ device = "/dev/disk/by-label/nixos"; }
      // { fsType = "ext4"; autoResize = true; });
  };

  # https://sysctl-explorer.net/net/ipv4/tcp_fastopen/
  boot.kernel.sysctl = { "net.ipv4.tcp_fastopen" = 2; };
}
