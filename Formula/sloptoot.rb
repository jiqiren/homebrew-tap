class Sloptoot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/sloptoot"
  url "https://github.com/jiqiren/sloptoot/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "585e04c29930cd9337f7b2e22bc60748e27786029e3669c71ab38e4b66a58b93"
  license "BSD-3-Clause"
  head "https://github.com/jiqiren/sloptoot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/jiqiren/homebrew-tap/releases/download/sloptoot-1.3.1"
    sha256 cellar: :any, arm64_tahoe:  "88a8e17c061e8167242e0cf5e44f66a2e93459a3454008a080b5d35a8526cdff"
    sha256               arm64_linux:  "b8fd1326e3cb28d9a281ae7f066983e4bd96b863edd03072958f0f53be7518f0"
    sha256               x86_64_linux: "1ad5f8478e84de7c18db333d23f90d340b092a3495debd0940aaeab57e0851ba"
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
