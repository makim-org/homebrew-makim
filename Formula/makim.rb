class Makim < Formula
  desc "A tool that helps organize and simplify helper commands using YAML configuration"
  homepage "https://github.com/osl-incubator/makim"
  version "1.29.0"
  license "BSD-3-Clause"
  
  depends_on "zlib"

  on_linux do
    # on_arm do
    #   url "https://github.com/makim-org/makim/releases/download/1.29.0/makim-linux-arm64"
    #   sha256 "${ARM64_SHA256}"

    # end

    on_intel do
      url "https://github.com/makim-org/makim/releases/download/#{version}/makim-linux-x86-64"
      sha256 "3087dd9ad7aa0218b43341d466ea4dcecb0fde3859a7df4e075e3689c4a7e2ab"
    end

  end

  def install
    bin.install Dir["makim-*"].first => "makim"
  end

  test do
    output = shell_output("#{bin}/makim --version")
    assert_match "Version: #{version}", output
  end
end
