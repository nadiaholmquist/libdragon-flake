{ ... }:

final: prev: {
  libcCross = prev.libcCross.overrideAttrs {
    env.CFLAGS_FOR_TARGET = "-DHAVE_ASSERT_FUNC -O2";
    configureFlags = [
      "--target=mips64-elf"
      "--with-cpu=mips64vr4300"
      "--disable-threads"
      "--disable-libssp"
    ];
  };
}
