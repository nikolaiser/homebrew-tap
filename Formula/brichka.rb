class Brichka < Formula
  desc "Cli tools for databricks"
  homepage "https://github.com/nikolaiser/brichka"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.4/brichka-aarch64-apple-darwin.tar.xz"
      sha256 "263f241442b04458982010a315734cf7908f21502ae344bcee54dcc3bf7e677b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.4/brichka-x86_64-apple-darwin.tar.xz"
      sha256 "fe847a4600fb74c58177a77d2954855f2c2aa32af832e59c42e3ea7fdf943a2e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.4/brichka-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f9f4cdddca0f82d96c926b436901cc53c530adb4da36f1db66a6cd52eee8479"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.4/brichka-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "413aa154cedaa9c745a0e97e00e61175ef69b685252685e41069f87bc4e17010"
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
