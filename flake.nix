{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.disko.url = github:nix-community/disko;
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-anywhere.url = "github:numtide/nixos-anywhere";
  inputs.nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, disko, nixos-anywhere,... }@attrs: {
     nixosConfigurations.vultr = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
           ./configs/vultr.nix
            disko.nixosModules.disko
           ./disk-config.nix
          {
          _module.args.disks = [ "/dev/sda" ];
          disko.devices = import ./disk-config.nix {
            lib = nixpkgs.lib;
          };
        }
      ];
    };

  };
}
