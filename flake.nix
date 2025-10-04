{
  description = "Ops - Build and run nanos unikernels";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        
        ops = pkgs.callPackage ./package.nix { };
      in
      {
        packages = {
          default = ops;
          ops = ops;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            ops
            pkgs.qemu
          ];
          
          shellHook = ''
            echo "╔════════════════════════════════════════╗"
            echo "║  Ops Development Environment           ║"
            echo "╚════════════════════════════════════════╝"
            echo ""
            echo "Available commands:"
            echo "  ops     - Build and run unikernels"
            echo "  qemu    - QEMU emulator"
            echo ""
            echo "Ops version: $(ops version 2>&1 || echo 'checking...')"
            echo "QEMU version: $(qemu-system-x86_64 --version | head -n1)"
          '';
        };

        apps.default = {
          type = "app";
          program = "${ops}/bin/ops";
        };
      }
    );
}