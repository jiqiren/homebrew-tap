class Sloptoot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/sloptoot"
  url "https://github.com/jiqiren/sloptoot/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "5ec36ff9f6ff9b363ea460e5e5da7cc97c90c01af3f5d17c531566e9e34740a9"
  license "BSD-3-Clause"
  head "https://github.com/jiqiren/sloptoot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "curl"
  depends_on "jpeg-turbo"
  depends_on "libnsgif"
  depends_on "libpng"
  depends_on "sqlite"
  depends_on "webp"
  on_linux do
    depends_on "llvm" => :build
    depends_on "openssl@3"
  end

  def install
    ENV["CC"] = formula_opt_bin("llvm")/"clang" if OS.linux?
    system "meson", "setup", "build", *std_meson_args, "--wrap-mode=nofallback"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "sloptoot #{version}", shell_output("#{bin}/sloptoot version")
  end
end
