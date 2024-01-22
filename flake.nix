{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    mysql2sqlite_src.url = "github:dumblob/mysql2sqlite";
    mysql2sqlite_src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, mysql2sqlite_src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = mysql2sqlite;

          mysql2sqlite = pkgs.stdenv.mkDerivation rec {
            pname = "mysql2sqlite";
            version = "0.0.0";

            src = mysql2sqlite_src;

            installPhase = ''
              install -D mysql2sqlite $out/bin/mysql2sqlite
            '';

            checkPhase = ''
              ./unit_test.sh
            '';
          };
        };
      }
    );
}
