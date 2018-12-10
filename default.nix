{ nixpkgs ? (builtins.fetchGit {
    url = git://github.com/NixOS/nixpkgs-channels;
    ref = "nixos-18.09";
    rev = "b352d47e42b5babe82d937b2d5c77476b663dd88";
  })
, getPythonVersion ? (p: p.python2Packages)
, src ? builtins.fetchGit ./.
}:
let
  overlays = [ ];
  pkgs = import nixpkgs { inherit overlays; config = { }; };
  pyPkgs = getPythonVersion pkgs;
in with pkgs; pyPkgs.buildPythonPackage rec {
  name = "mmpy_bot";
  inherit src;
  prePatch = ''
    substitueInPlace requirements.txt --replace "requests>=2.20.0" "requests>=2.18.0"
  '';
  propagatedBuildInputs = with pyPkgs; [
    websocket_client
    six
    requests
    sphinx
    schedule
  ];

  checkInputs = with pyPkgs; [
    pytest
    pytestrunner
    pytest-flake8
  ];
}
