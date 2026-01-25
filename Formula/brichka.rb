class Brichka < Formula
  desc "Cli tools for databricks"
  homepage "https://github.com/nikolaiser/brichka"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.1.7/brichka-aarch64-apple-darwin.tar.xz"
      sha256 "c1f70d56878919b5c40fb5f9f2fa5a5c1fd396d7cc1d75cce24602b58f5035ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.1.7/brichka-x86_64-apple-darwin.tar.xz"
      sha256 "bbdba57a5313fe3a6951230ce01b01d4d9942abb73ab8cc2994cc4ac7aa15d4e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.1.7/brichka-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5c4ae2534dd1c1914a8096dcfe144b00bfbe1f2e63a89289e53943ad3b17ed94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.1.7/brichka-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "338aab6dd88e909614edc8793fd4d8f6c2a8078d93fc5a9f6f9baa815917b2ee"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "brichka" if OS.mac? && Hardware::CPU.arm?
    bin.install "brichka" if OS.mac? && Hardware::CPU.intel?
    bin.install "brichka" if OS.linux? && Hardware::CPU.arm?
    bin.install "brichka" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
