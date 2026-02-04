class Brichka < Formula
  desc "Cli tools for databricks"
  homepage "https://github.com/nikolaiser/brichka"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.3/brichka-aarch64-apple-darwin.tar.xz"
      sha256 "dab0988f72c74faf5243fe466178704a469c455adb5c031019520c96fc479b1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.3/brichka-x86_64-apple-darwin.tar.xz"
      sha256 "0dc53965f3a84d91cd360563d6848440ab9f03cd40999134bd0e7401d24e11f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.3/brichka-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b423f53f1de48be197abc816622f52bfe9a2c6f08cec376c3c3874123ec1495d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.3/brichka-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "823987892b593a14de060040deec99f570305472c9f1158f0fd43547aec865cb"
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
