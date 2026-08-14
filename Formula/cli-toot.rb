class CliToot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/cli-toot"
  url "https://github.com/jiqiren/cli-toot/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "bc4c014d64abd16da4a7dbc3c2bff672d8ee4e340f63913670bfddc3269a13bb"
  license "BSD-3-Clause"

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
    depends_on "openssl@3"
  end

  def install
    system "meson", "setup", "build", *std_meson_args, "--wrap-mode=nofallback"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "cli-toot #{version}", shell_output("#{bin}/cli-toot version")
  end
end
