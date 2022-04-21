{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }: rec {
    system = "x86_64-linux";

    azure-image = azure.config.system.build.azureImage;
    azure = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./nixos/configuration.nix ];
    };

    pkgsUnstable = import nixpkgs-unstable { inherit system; };
    devShell."${system}" = pkgsUnstable.mkShell {
      name = "Terraform_Azure";
      nativeBuildInputs = with pkgsUnstable;
        [ terraform azure-cli ];
    };
  };
}
