

{
  description = "Ops - Build and run nanos unikernels";

  inputs = {
    # Use latest nixpkgs-unstable which has Go 1.25+
    nixpkgs.url = "github:NixOS/nixpkgs/7df7ff7d8e00218376575f0acdcc5d66741351ee";
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
			  
			  # Check if setup is needed
			  if [ ! -d "$HOME/.ops/kernels" ] || [ -z "$(ls -A $HOME/.ops/kernels 2>/dev/null)" ]; then
				 echo "⚠️  First time setup required!"
				 echo "   Run: ops-setup"
				 echo ""
			  fi
			  
			  echo "Available commands:"
			  echo "  ops-setup   - Download Nanos kernels (run once)"
			  echo "  ops         - Build and run unikernels"
			  echo "  qemu        - QEMU emulator"
			  echo ""
			  echo "Ops version: $(ops version 2>&1 | grep 'Ops version' || echo 'checking...')"
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