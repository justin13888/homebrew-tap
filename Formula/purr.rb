class Purr < Formula
  desc "Fast, featureful, cross-platform fetching tool written in Rust "
  homepage "https://github.com/justin13888/purrfetch"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/justin13888/purrfetch/releases/download/v1.0.0/purrfetch-aarch64-apple-darwin.tar.xz"
      sha256 "f94c6c5400fa62848c57684063d1366218e99f7de7f97186bc3d8e5baf36c818"
    end
    if Hardware::CPU.intel?
      url "https://github.com/justin13888/purrfetch/releases/download/v1.0.0/purrfetch-x86_64-apple-darwin.tar.xz"
      sha256 "ba1ff21281939ba6151151273df74dc7b6e7fd15d36bf8671beff7228ae85e7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/justin13888/purrfetch/releases/download/v1.0.0/purrfetch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "45ee06c3b6f75b7d4dc83174361a49ffde4540f75f6f4abfddd783f402c59aa1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/justin13888/purrfetch/releases/download/v1.0.0/purrfetch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "34560fb1f2d61469eb04164179a1a2dc00b8e21d0d7c5ec9cbb8300fd401f662"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "purr" if OS.mac? && Hardware::CPU.arm?
    bin.install "purr" if OS.mac? && Hardware::CPU.intel?
    bin.install "purr" if OS.linux? && Hardware::CPU.arm?
    bin.install "purr" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
