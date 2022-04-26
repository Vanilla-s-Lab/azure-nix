{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # https://github.com/serokell/deploy-rs
    deploy-rs.url = "github:serokell/deploy-rs";

    # https://github.com/Mic92/sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/nixos-cn/flakes/tree/main/modules/sops
    nixos-cn.url = "github:nixos-cn/flakes";
    nixos-cn.inputs.nixpkgs.follows = "nixpkgs";

    # https://nixpk.gs/pr-tracker.html?pr=169829
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
  };

  outputs = { self, nixpkgs, deploy-rs, nixpkgs-unstable, sops-nix, nixos-cn, nixpkgs-master, ... }: rec {
    system = "x86_64-linux";

    azure-image = azure.config.system.build.azureImage;
    azure = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./nixos/configuration.nix ]
        ++ [ sops-nix.nixosModules.sops ]
        ++ [ nixos-cn.nixosModules.nixos-cn ];
    };

    pkgs = import nixpkgs { inherit system; };
    pkgsUnstable = import nixpkgs-unstable { inherit system; };
    pkgsMaster = import nixpkgs-master { inherit system; };

    devShell."${system}" = pkgs.mkShell {
      name = "Terraform_Azure";
      nativeBuildInputs = (with pkgsUnstable;
        [ terraform azure-storage-azcopy gh ])
      ++ pkgs.lib.singleton (pkgsMaster.azure-cli);
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
