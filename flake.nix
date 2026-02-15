{
  description = "A simple feature-rich dynamic tiling window manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      name = "sxwm";
      version = "1.7";
      pkgs = import nixpkgs { inherit system; };

      sxwm = pkgs.stdenv.mkDerivation {
        pname = "${name}";
        version = "${version}";

        src = pkgs.fetchFromGitHub {
          owner = "uint23";
          repo = "${name}";
          tag = "v${version}";
          hash = "sha256-Gytop4YkQdVaYXWyXmlHotEFnaA0O8CZUmqfIe8X2w=";
        };

        nativeBuildInputs = with pkgs; [
          xorg.libX11
          xorg.libXinerama
          xorg.libXcursor
          libgcc
          gnumake
        ];

        buildPhase = ''
          make clean sxwm
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp sxwm $out/bin/
        '';
      };

    in {
      packages.default = sxwm;

      apps.default = {
        type = "app";
        program = "${sxwm}/bin/${name}";
      };     
    };
}
