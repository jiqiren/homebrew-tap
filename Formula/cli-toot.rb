class CliToot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/cli-toot"
  url "https://github.com/jiqiren/cli-toot/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "db8d54fbe83ff7a7ebf71f0d9f5a5134d4dc3cf4a7c137378246a1e0dbb51a5f"
  license "BSD-3-Clause"
  head "https://github.com/jiqiren/cli-toot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/jiqiren/homebrew-tap/releases/download/cli-toot-1.1.1"
    sha256 cellar: :any, arm64_tahoe:  "48a38f114c4e72c57f01a74f2fe9e25a3373b3df406214227177b83ddebb65ca"
    sha256               arm64_linux:  "761b4a9ea0e6eb3d517edc9987304d018e2822e91d7d04917e7ae5e3a7c89c06"
    sha256               x86_64_linux: "d53067e8e519662054c5f98eaaa629d49aeceaa687c65ec28bc5111b91880bbb"
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
