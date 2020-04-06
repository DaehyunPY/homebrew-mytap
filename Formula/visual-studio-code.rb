class VisualStudioCode < Formula
  homepage "https://code.visualstudio.com"

  version "1.43.2"
  url "https://update.code.visualstudio.com/#{version}/linux-x64/stable"
  sha256 "8f38474e258c1bbd469b5311051c50466a080b9e970b506e0e0bad387d524fed"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.install_symlink("#{libexec}/bin/code")
  end
end