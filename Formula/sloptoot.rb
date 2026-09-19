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

  bottle do
    root_url "https://github.com/jiqiren/homebrew-tap/releases/download/sloptoot-1.4.5"
    sha256 cellar: :any, arm64_tahoe:  "b78d0a770a8ce8d31b037dc75532dbf5ad78c1056632e0a64f02d83046bc8f58"
    sha256 cellar: :any, arm64_linux:  "3588c239648db2e680e3c561a21848f9110197fc86f9682222257d541da6c2be"
    sha256 cellar: :any, x86_64_linux: "037656080a92769265715bc7ffefad7a7ea538bb432150a8a5d3be3d88b2f7b8"
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
