{
  description = "A simple feature-rich dynamic tiling window manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "sxwm";
        version = "1.7";

        src = pkgs.fetchFromGitHub {
          owner = "uint23";
          repo = "${pname}";
          tag = "v${version}";
          hash = "sha256-jpMa4NO78ttmr/VGJHjwOkGecwN4BSMvbCJFKjXd/ko=";
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
    };
}
