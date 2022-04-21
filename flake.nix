{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, ... }@inputs: with inputs; rec {
    azure-image = azure.config.system.build.azureImage;
    azure = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit nixpkgs; };
      modules = [ ./configuration.nix ];
    };
  };
}
