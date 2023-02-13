let
  mozilla = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ mozilla ]; };
  rust_overlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  pkgs = import <nixpkgs> { overlays = [ rust_overlay ]; };
  rustVersion = "1.62.0";
  rust = pkgs.rust-bin.stable.${rustVersion}.default.override {
    extensions = [
      "rust-src" # for rust-analyzer
    ];
  };
in

  with nixpkgs;

  mkShell {
    buildInputs = [
      rustup
      rustc
      rust-analyzer
      alsaLib
      cmake
      freetype
      expat
      openssl
      pkg-config
      fontconfig
      python3
      vulkan-validation-layers
      xorg.libX11
    ];

    APPEND_LIBRARY_PATH = lib.makeLibraryPath [
      vulkan-loader
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
      libGL
    ];

    shellHook = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$APPEND_LIBRARY_PATH"
      '';
  }
