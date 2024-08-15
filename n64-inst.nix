{ pkgs, n64Pkgs, libdragonPkgs, ... }:

pkgs.buildEnv {
  name = "libdragon-n64-inst";
  paths = map toString ([
    libdragonPkgs.lib
    n64Pkgs.buildPackages.binutils
    n64Pkgs.buildPackages.gcc
  ] ++ libdragonPkgs.tools);
}
