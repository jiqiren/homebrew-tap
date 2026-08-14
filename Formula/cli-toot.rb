class CliToot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/cli-toot"
  url "https://github.com/jiqiren/cli-toot/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "bc4c014d64abd16da4a7dbc3c2bff672d8ee4e340f63913670bfddc3269a13bb"
  license "BSD-3-Clause"
  head "https://github.com/jiqiren/cli-toot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/jiqiren/homebrew-tap/releases/download/cli-toot-1.0.3"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:  "22244b8c9a6db65249fa86af51ef00ae134cc4b838451ad2c2b225ad35063357"
    sha256               arm64_linux:  "695d2de5b1037af67b4ad6eff9e5b24d1adfb8b2b710efe0da5aa88e8a2e0815"
    sha256               x86_64_linux: "d5bb940bf1e76565bfe3ac749a123144d7c619480b06f251741854e78a105a76"
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
