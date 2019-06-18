let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/e6d320ec0ceefa56f9e711e389a6f39cdc985634.tar.gz";
    sha256 = "1zzp6h0mnz7qkhvzrgrlmlp6ljwnkn5k942gldkmajhcbs6jddhb";
  };

  pkgs = import nixpkgs { system = "x86_64-linux"; };
in pkgs.callPackage ./snap.nix { }
