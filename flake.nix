{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  };

  outputs = { self, ... }@inputs: with inputs; rec {
    system = "x86_64-linux";

    azure-image = azure.config.system.build.azureImage;
    azure = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit nixpkgs; };
      modules = [ ./nixos/configuration.nix ];
    };
  };
}
