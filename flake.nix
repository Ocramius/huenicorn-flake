{
  description = "openjowelsofts/huenicorn, packaged for usage on Nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    openjowelsofts-huenicorn = {
      url = "gitlab:openjowelsofts/huenicorn?ref=d050514e4040c574cc3b827d09012b0130f5971d";
      flake = false;
    };
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      openjowelsofts-huenicorn,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import nixpkgs) {
          inherit system;

          # to allow for rust-rover to be installed
          config.allowUnfree = true;
        };

        # https://gitlab.com/openjowelsofts/huenicorn/-/tree/0c3910ab43a64b87755ab500fbae9378376efb46/#dependencies-intallation
        buildDependencies = with pkgs; [
          curl
          gcc
          glib
          glm
          gnumake
          httplib
          mbedtls
          nlohmann_json
          opencv
          pkg-config
          libX11
          libXcursor
          libXrandr
          libXi
          cmake
          pipewire
        ];

        built = pkgs.stdenv.mkDerivation {
          name = "huenicorn";

          nativeBuildInputs = buildDependencies;

          src = openjowelsofts-huenicorn;

          buildPhase = ''
            cp -r $src ./src
            chmod +w src
            mkdir -p ./src/build
            cd ./src/build
            cmake ..
            make
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp huenicorn $out/bin/
          '';
        };
      in
      {
        packages = {
          default = built;
        };

        formatter = pkgs.nixfmt-tree;

        devShells = {
          default = pkgs.mkShell {
            name = "huenicorn build dev shell";

            nativeBuildInputs = [
              # dev environment
              pkgs.jetbrains.clion
              pkgs.nixd
            ]
            ++ buildDependencies;

            shellHook = ''
              cp -r "${openjowelsofts-huenicorn}" ./src;
              chmod +w src
              mkdir -p ./src/build
              cd ./src/build
            '';
          };
        };

        checks = {
          builds-an-executable = pkgs.stdenv.mkDerivation {
            name = "can run php with the extension loaded";

            src = ./.;

            doCheck = true;

            checkPhase = ''
               if [[ -f "${built}/bin/huenicorn" && -r "${built}/bin/huenicorn" && -x "${built}/bin/huenicorn" ]]; then
                 echo "OK" >> $out;
               else
                 echo "KO" >> $out;
                 exit 1;
              fi
            '';
          };
        };
      }
    );
}
