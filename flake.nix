{
  description = "Reusable dev shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
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
          packages = with pkgs; [zls zig lldb];
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
