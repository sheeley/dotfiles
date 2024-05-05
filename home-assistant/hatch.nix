{ pkgs, ... }: let
  buildPythonPackage = pkgs.python312Packages.buildPythonPackage;
  setuptools = pkgs.python312Packages.setuptools;
      # (let
        aiohttp = pkgs.python312Packages.aiohttp;
        awscrt = pkgs.python312Packages.awscrt;
        awsiotsdk = buildPythonPackage rec {
          pname = "awsiotsdk";
          version = "1.21.0";

          pyproject = true;

          nativeBuildInputs = [setuptools];
          propagatedBuildInputs = [
            awscrt
          ];

          src = pkgs.fetchPypi {
            inherit pname version;
            hash = "sha256-w+idl0zg+C8uftz6EFLYND1oAC2HtQr8RwyFpvOFSFg=";
          };
        };

        hatch_rest_api = buildPythonPackage rec {
          pname = "hatch_rest_api";
          version = "1.21.0";

          pyproject = true;

          nativeBuildInputs = [setuptools];
          propagatedBuildInputs = [
            awsiotsdk # >=1.21.0
            aiohttp # >=3.8.1
          ];

          src = pkgs.fetchPypi {
            inherit pname version;
            hash = "sha256-GUsy1TsK+KW9yhi/2TD8eGWmB0UF0Uau+msEVAee4k4=";
          };
        };
      in {
        pkgs.buildHomeAssistantComponent {
          owner = "dahlb";
          domain = "ha_hatch";
          version = "1.17.1";
          src = pkgs.fetchFromGitHub {
            owner = "dahlb";
            repo = "ha_hatch";
            rev = "v1.17.1";
            hash = "sha256-YUBBSoPMe5bghsUJ2jpRHWvLQftkgWNaMuHqTZ5wZQg=";
          };
          propagatedBuildInputs = [
            hatch_rest_api # ==1.21.0"
          ];
        }
        # )
      }
