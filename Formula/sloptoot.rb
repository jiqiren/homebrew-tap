class Sloptoot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/sloptoot"
  url "https://github.com/jiqiren/sloptoot/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "fbf3732eca514d6defd3103cb7882c3d88e5c01728957365e2f39b67c22703f7"
  license "BSD-3-Clause"
  head "https://github.com/jiqiren/sloptoot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/jiqiren/homebrew-tap/releases/download/sloptoot-1.4.3"
    sha256 cellar: :any, arm64_tahoe:  "eedaa12bb446184087ee65f9fbd720d5bfef0135284c01ba0aca921aec9acd47"
    sha256 cellar: :any, arm64_linux:  "1be0e134ae9d9db732054aa99b7a08dfd82734ae7418bd24a0dba99726bdc881"
    sha256 cellar: :any, x86_64_linux: "574974dcf0e983e81e074d8c832b8ae865d1ca5d39fc24b40fd2d41b57f8fb3d"
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
