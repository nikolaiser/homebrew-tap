class Brichka < Formula
  desc "Cli tools for databricks"
  homepage "https://github.com/nikolaiser/brichka"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.5/brichka-aarch64-apple-darwin.tar.xz"
      sha256 "f351cb6d8e04c2f935f796aa623d785680aabea883f1b59ce490e828088b88ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.5/brichka-x86_64-apple-darwin.tar.xz"
      sha256 "29136ba11c5c1c90d97d746d6d4835fecc1c555dc43fcdaa36d33ccf2e4a616e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.5/brichka-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "51d4f81b66cde8393b1bee99ce96d273be5f190f0b34da046879cbf0536dec0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.5/brichka-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "548d91dce8e5b708d2a7942327fc4c82e07f4289098eea9ea711a25b77e64752"
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
