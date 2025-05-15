{
  buildEnv,
  n64Pkgs,
  libdragonPkgs,
}:

buildEnv {
  name = "libdragon-n64-inst";
  paths =
    [
      libdragonPkgs.lib
      n64Pkgs.buildPackages.binutils
      n64Pkgs.buildPackages.gcc
    ]
    ++ libdragonPkgs.tools;
}
