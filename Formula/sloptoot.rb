class Sloptoot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/sloptoot"
  url "https://github.com/jiqiren/sloptoot/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "cafe69ec367141495c222328558d69655b89988e19b5362467f7a5c60210a5cb"
  license "BSD-3-Clause"
  head "https://github.com/jiqiren/sloptoot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/jiqiren/homebrew-tap/releases/download/sloptoot-1.3.0"
    sha256 cellar: :any, arm64_tahoe:  "5ee1c439487f2cdd66fa4ff8d92aa9cee97f6eae2b0228651697a8bc02dd3310"
    sha256               arm64_linux:  "268f11340aae0b21a2e400b4a1d9ef0fbfdef5bee9bdc5b696f425110235035c"
    sha256               x86_64_linux: "d7d786cfcd0dbd566b41233c0be43c36b011e85bf2f8257c302a4a497d5b45e2"
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
