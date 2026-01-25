class Brichka < Formula
  desc "Cli tools for databricks"
  homepage "https://github.com/nikolaiser/brichka"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.0/brichka-aarch64-apple-darwin.tar.xz"
      sha256 "f60b776a0132183fcd849caaf870c18936e6cf5ccb226934c0388daf344dc88e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.0/brichka-x86_64-apple-darwin.tar.xz"
      sha256 "e623392ac301cb0cc95941e3436007b4a285bd48f4187cfcf236d4431f554052"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.0/brichka-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df455310f11f06e9fdc9db3bfe32e5a993411bdcbff19c921ed14e4f2c4c97ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nikolaiser/brichka/releases/download/v0.2.0/brichka-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "06c139c8adec4e62ae1cd4695e0d349426cdd75e5f21e7afa3394747b07a9c37"
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
