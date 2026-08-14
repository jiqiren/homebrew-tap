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

  bottle do
    root_url "https://github.com/jiqiren/homebrew-tap/releases/download/cli-toot-1.1.0"
    sha256 cellar: :any, arm64_tahoe:  "d6d3494f70515741c8714abbb5932569a8553416f4d222c3c7d79aa0b75a8fba"
    sha256               arm64_linux:  "9f2a14f13f607c1ace046deae88cafb0eb483e37f0108ea1be038dfb247b81ed"
    sha256               x86_64_linux: "4b6684b22cac6a1fa039f60b47cf05f32f7e34f8c8555852fa6a5b8ab77e0664"
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
