{
  description = "A simple feature-rich dynamic tiling window manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      name = "sxwm";
      ver = "1.7";
      pkgs = import nixpkgs { inherit system; };

      sxwm = pkgs.stdenv.mkDerivation {
        pname = name;
        version = ver;

        src = pkgs.fetchFromGitHub {
          owner = "uint23";
          repo = name;
          rev = "v${ver}";
          hash = "sha256-Gytop4YkQdVaYXWyXmlHotEFnaA0O8CZUmqfIe8X2w=";
        };

        nativeBuildInputs = with pkgs; [
          pkg-config
          gnumake
        ];

        buildInputs = with pkgs; [
          xorg.libX11
          xorg.libXinerama
          xorg.libXcursor
          xorg.xorgproto
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
      packages.${system}.default = sxwm;

      apps.${system}.default = {
        type = "app";
        program = "${sxwm}/bin/${name}";
      };     
    };
}
