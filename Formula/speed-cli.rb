class SpeedCli < Formula
  desc "Comprehensive multi-protocol network performance testing CLI"
  homepage "https://github.com/justin13888/speed-cli"
  url "https://github.com/justin13888/speed-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "<sha256-of-the-tarball>"
  license "Apache-2.0"
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "speed-cli", shell_output("#{bin}/speed-cli --version")
  end
end
