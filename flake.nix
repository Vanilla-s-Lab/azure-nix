{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";

    # https://github.com/serokell/deploy-rs
    deploy-rs.url = "github:serokell/deploy-rs";

    # https://github.com/Mic92/sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/nixos-cn/flakes/tree/main/modules/sops
    nixos-cn.url = "github:nixos-cn/flakes";
    nixos-cn.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, deploy-rs, sops-nix, nixos-cn, ... }: rec {
    system = "x86_64-linux";

    azure-image = azure.config.system.build.azureImage;
    azure = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./nixos/configuration.nix ]
        ++ [ sops-nix.nixosModules.sops ]
        ++ [ nixos-cn.nixosModules.nixos-cn ];
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
