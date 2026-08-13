class CliToot < Formula
  desc "Minimal C23 CLI Mastodon client"
  homepage "https://github.com/jiqiren/cli-toot"
  url "https://github.com/jiqiren/cli-toot/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "48e03abbbaef53a3a547bc555ba626071d68e8c44546eb83b3fb63f78db6b374"
  license "BSD-3-Clause"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "cjson"

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
