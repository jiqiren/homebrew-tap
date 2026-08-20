class Sloptoot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/sloptoot"
  url "https://github.com/jiqiren/sloptoot/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "bed6295c8b1fc0fede685a3a0ce9ebc4df85b70f42fdedf392fdb240941d90ff"
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
  depends_on "sqlite"
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
