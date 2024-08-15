{ pkgs, n64Pkgs, libdragon, ... }:

let
  buildEnv = pkgs.runCommand "libdragon-build-env" { } ''
  mkdir -p $out/bin
  ln -s ${n64Pkgs.buildPackages.binutils}/bin/mips64-elf-{ld,objcopy,ar,size} $out/bin/
  ln -s ${n64Pkgs.buildPackages.gcc}/bin/mips64-elf-{gcc,g++} $out/bin/
  '';

  # Anything that doesn't need a MIPS toolchain to build
  basicToolNames = [
    "n64tool" "n64sym" "ed64romconfig" "audioconv64" "mkdfs" "dumpdfs" "mkasset" "mksprite" "mkfont" "mkmodel" "n64dso" "n64dso-msym" "n64dso-extern" "rdpvalidate"
  ];

  # Tools that need a MIPS toolchain to build
  mipsToolNames = [ "n64elfcompress" ];

  makeTool = withBuildEnv: name: pkgs.stdenv.mkDerivation {
    pname = "libdragon-${name}";
    version = libdragon.shortRev;
    src = libdragon;
    sourceRoot = "source/tools";
    enableParallelBuilding = true;
    passthru.toolName = name;
    preBuild = if withBuildEnv then "export N64_INST=${buildEnv}" else "";
    buildPhase = ''
      runHook preBuild
      make ${name}
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      make ${name}-install N64_INST=$out
      runHook postInstall
    '';
  };

  makeBasicTool = makeTool false;
  makeMipsTool = makeTool true;

  tools =
    (map makeBasicTool basicToolNames) ++
    (map makeMipsTool mipsToolNames);

  lib = pkgs.stdenv.mkDerivation {
    pname = "libdragon-lib";
    version = libdragon.shortRev;

    src = libdragon;
    enableParallelBuilding = true;
    preBuild = "export N64_INST=${buildEnv}";
    preInstall = "export N64_INST=$out";
  };
in {
  inherit lib tools;
}
