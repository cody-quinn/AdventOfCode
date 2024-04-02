{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { 
    self, 
    nixpkgs, 
    flake-utils, 
    rust-overlay, 
    ... 
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };

      rust = (pkgs.rust-bin.nightly."2024-03-27".default.override {
        extensions = [ "rust-src" "rust-analyzer" ];
      });
    in 
      {
        devShell = pkgs.mkShell rec {
          buildInputs = with pkgs; [
            rust
            dotnet-sdk_8
          ];

          DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
        };
      });
}
