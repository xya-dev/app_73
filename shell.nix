let
  pkgs = import <nixpkgs> {
    config.allowUnfree = true;
  };
in
pkgs.mkShell {
  packages = with pkgs; [
    beam.packages.erlang_28.elixir_1_19
    podman-compose
    ngrok
  ];
}
