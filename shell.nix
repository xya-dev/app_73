let
  pkgs = import <nixpkgs> {
    config.allowUnfree = true;
  };
in
pkgs.mkShell {
  packages = with pkgs; [
    beam.packages.erlang_27.elixir_1_18
    podman-compose
    ngrok
  ];
}
