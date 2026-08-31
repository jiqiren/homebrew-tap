class Sloptoot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/sloptoot"
  url "https://github.com/jiqiren/sloptoot/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "c8843158af6ed7b9242a788244743141d5faaee0f511a47b58173edd32837b59"
  license "BSD-3-Clause"
  head "https://github.com/jiqiren/sloptoot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/jiqiren/homebrew-tap/releases/download/sloptoot-1.4.0"
    sha256 cellar: :any, arm64_golden_gate: "2103c18ad2b7030b67e0d34985d73cfac8699e619fc708bd804f13fef867ff55"
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
