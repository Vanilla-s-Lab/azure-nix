{ pkgs, lib, ... }:
{
  users.users.root.shell = pkgs.fish;
  users.users.root.openssh.authorizedKeys.keyFiles =
    (lib.singleton ../ssh-rsa.pub);
}
