{ n64Pkgs, libdragonPkgs, libdragon-n64-inst, ... }:

n64Pkgs.buildPackages.mkShell {
  name = "libdragon-shell";
  buildInputs = [ libdragon-n64-inst ];

  # TODO: Figure out if I can override the compiler wrapper to do this
  shellHook = ''
    export N64_INST=${libdragon-n64-inst}
    export NIX_CFLAGS_COMPILE_mips64_elf="-isystem ${libdragonPkgs.lib}/mips64-elf/include"
    export NIX_CFLAGS_LINK_mips64_elf="-L${libdragonPkgs.lib}/mips64-elf/lib"
    export NIX_LDFLAGS_mips64_elf="-L${libdragonPkgs.lib}/mips64-elf/lib"
  '';
}
