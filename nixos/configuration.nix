{ modulesPath, lib, ... }:
{
  imports = [ "${modulesPath}/virtualisation/azure-image.nix" ]
    ++ [ ./users.nix ./network.nix ./packages.nix ];
}
