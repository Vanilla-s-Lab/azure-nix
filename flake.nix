{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # https://github.com/serokell/deploy-rs
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs, nixpkgs-unstable, ... }: rec {
    system = "x86_64-linux";

    azure-image = azure.config.system.build.azureImage;
    azure = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./nixos/configuration.nix ];
    };

    pkgs = import nixpkgs { inherit system; };
    pkgsUnstable = import nixpkgs-unstable { inherit system; };

    devShell."${system}" = pkgs.mkShell {
      name = "Terraform_Azure";
      nativeBuildInputs = (with pkgsUnstable;
        [ terraform azure-storage-azcopy gh ])
      # https://github.com/NixOS/nixpkgs/pull/169829
      ++ pkgs.lib.singleton (pkgs.azure-cli);
    };

    deploy.nodes.azure = {
      sshUser = "root";
      hostname = "20.24.195.187";

      profiles.system.path =
        deploy-rs.lib."${system}".activate.nixos
          azure;

      fastConnection = true;
    };
  };
}
