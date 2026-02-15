{
  description = "A simple feature-rich dynamic tiling window manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    sxwm-src = {
      url = "https://github.com/uint23/sxwm/archive/v1.7.tar.gz";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, sxwm-src, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {

        pname = "sxwm";
        version = "1.7";

        src = sxwm-src;

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
    };
}
