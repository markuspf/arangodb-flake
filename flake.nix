{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-22.05";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      arangodb = (with pkgs; stdenv.mkDerivation {
        meta = {
          homepage = "https://arangodb.com/";
        };
        pname = "arangodb";
        version = "git";
        src = pkgs.fetchgit {
          url = "https://github.com/arangodb/arangodb.git";
          sha256 = "sha256-NRBOFgcag9R7RTkBUHDqKjsNghUyk/Oq3XVMROsWry4=";
          rev = "569485bd10025c4d526fe535d94f4f97dab48d61";
        };
        nativeBuildInputs = [
          clang
          cmake
        ];
        buildPhase = "make -j $NIX_BUILD_CORES";
        installPhase = ''
          make install
        '';
      });
    in rec {
      devShell = pkgs.mkShell {
        buildInputs = [ arangodb ];
      };
      packages.default = arangodb;
    }
  );
}

