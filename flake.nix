{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
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

            doCheck = false;

            installPhase = ''
              install -D mysql2sqlite $out/bin/mysql2sqlite
            '';

            checkPhase = ''
              # Unit testing not yet fully implemented in mysql2sqlite
              ./unit_tests.sh
            '';

            checkInputs = with pkgs; [
              sqlite
            ];
          };
        };
      }
   );
}
