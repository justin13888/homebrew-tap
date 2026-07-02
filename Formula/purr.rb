class Purr < Formula
  desc "Fast, featureful, cross-platform fetching tool written in Rust"
  homepage "https://github.com/justin13888/purrfetch"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/justin13888/purrfetch/releases/download/v1.0.1/purrfetch-aarch64-apple-darwin.tar.xz"
      sha256 "9bb063b693e49dac540662f42e1fe8cfafd5572b38c0a31b2dd9018ce37a9f4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/justin13888/purrfetch/releases/download/v1.0.1/purrfetch-x86_64-apple-darwin.tar.xz"
      sha256 "78028ed836049833919dd03031750b2ad35e59fa936fe7c6bb752653a5caf520"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/justin13888/purrfetch/releases/download/v1.0.1/purrfetch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a9ddf12ee2e3c174bc097e64048263e30ee1d76b42ce0fa5b379d6d9fa6b044e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/justin13888/purrfetch/releases/download/v1.0.1/purrfetch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "58095e50d73a702d3c64592742ff65fd6da38b55ff02f2d629e32f0fa7e51734"
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

    # purrfetch: cargo-dist bundles the man page + completions in the
    # archive but installs only the binary; wire them into Homebrew here.
    man1.install "purr.1"
    bash_completion.install "completions/purr.bash" => "purr"
    zsh_completion.install "completions/_purr"
    fish_completion.install "completions/purr.fish"

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
