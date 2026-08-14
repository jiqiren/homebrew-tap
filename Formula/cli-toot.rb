class CliToot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/cli-toot"
  url "https://github.com/jiqiren/cli-toot/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "6da391b0d053418823ddada8355139a9cb85c621275a96c8b4bc52c757ee786e"
  license "BSD-3-Clause"
  head "https://github.com/jiqiren/cli-toot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "curl"
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
    assert_match "cli-toot #{version}", shell_output("#{bin}/cli-toot version")
  end
end
