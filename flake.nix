{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  
  inputs.libdragon.url = "github:DragonMinded/libdragon/unstable";
  inputs.libdragon.flake = false;

  outputs = { nixpkgs, flake-utils, libdragon, ... }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages."${system}".pkgs;
    pkgsOverlay = import ./overlay.nix {};
    n64Pkgs = import nixpkgs {
      inherit system;
      crossSystem.config = "mips64-elf";
      overlays = [pkgsOverlay];
    };

    libdragonPkgs = pkgs.callPackage ./libdragon.nix { inherit n64Pkgs libdragon; };

    tools = builtins.listToAttrs (map (pkg:
      { name = pkg.passthru.toolName; value = pkg; }
    ) libdragonPkgs.tools);

  in rec {
    packages = {
      libdragon-lib = libdragonPkgs.lib;
      libdragon-n64-inst = pkgs.callPackage ./n64-inst.nix { inherit n64Pkgs libdragonPkgs; };
    } // tools;

    devShells.default = import ./devshell.nix {
      inherit pkgs n64Pkgs libdragonPkgs;
      inherit (packages) libdragon-n64-inst;
    };
  });
}
