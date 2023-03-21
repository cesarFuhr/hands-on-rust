{
  description = "Rust latest workspace";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nci.url = "github:yusdacra/nix-cargo-integration";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.follows = "rust-overlay/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, nci }:
    # Add dependencies that are only needed for development
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ (import rust-overlay) ];
          lib = nci.inputs.nixpkgs.lib;
          pkgs = import nixpkgs {
            inherit system overlays;
          };
        in
        {
          devShells. default = let p = pkgs; in
            pkgs.mkShell {
              buildInputs =
                [
                  p.rust-bin.stable.latest.default
                  p.cmake
                  p.freetype
                  p.expat
                  p.openssl
                  p.pkgconfig
                  p.python3
                  p.alsaLib
                  p.fontconfig
                  p.python3
                  p.vulkan-validation-layers
                  p.xorg.libX11
                ];

              APPEND_LIBRARY_PATH = lib.makeLibraryPath [
                p.vulkan-loader
                p.xorg.libXcursor
                p.xorg.libXi
                p.xorg.libXrandr
                p.libGL
              ];

              shellHook = ''
                export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$APPEND_LIBRARY_PATH"
              '';
            };
        });
}

