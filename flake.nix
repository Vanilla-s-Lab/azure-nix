{
  inputs = {
    # https://github.com/NixOS/nixpkgs/issues/93032
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs, ... }: rec {
    system = "x86_64-linux";

    azure-image = azure.config.system.build.azureImage;
    azure = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./nixos/configuration.nix ];
    };

    pkgs = import nixpkgs { inherit system; };
    devShell."${system}" = pkgs.mkShell {
      name = "Terraform_Azure";
      nativeBuildInputs = with pkgs;
        [ terraform azure-cli azure-storage-azcopy gh ];
    };

    deploy.nodes.azure = {
      sshUser = "root";
      hostname = "20.239.149.117";

      profiles.system.path =
        deploy-rs.lib."${system}".activate.nixos
          azure;

      fastConnection = true;
    };
  };
}
