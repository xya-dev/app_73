let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  packages = with pkgs; [
    beam.packages.erlang_27.elixir_1_18
    podman-compose
  ];
}
