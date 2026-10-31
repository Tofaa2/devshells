{
  description = "Reusable dev shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zls.url = "github:zigtools/zls/0.17.0";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    zig-overlay,
    zls,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells = {
        rust = pkgs.mkShell {
          packages = with pkgs; [cargo rustc rust-analyzer rustfmt clippy];
        };

        java = pkgs.mkShell {
          packages = with pkgs; [jdk25 gradle];
        };

        zig = pkgs.mkShell {
          packages = [
            zig-overlay.packages.${system}."0.17.0"
            zls.packages.${system}.default
            pkgs.lldb
          ];
        };

        odin = pkgs.mkShell {
          packages = with pkgs; [odin ols lldb];
        };

        python = pkgs.mkShell {
          packages = with pkgs; [python312 python312Packages.pip poetry];
        };

        node = pkgs.mkShell {
          packages = with pkgs; [nodejs_22 nodePackages.pnpm];
        };

        go = pkgs.mkShell {
          packages = with pkgs; [go gopls];
        };

        default = self.devShells.${system}.rust;
      };
    });
}
