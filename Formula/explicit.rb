class Explicit < Formula
  desc "Real-time Elixir code analysis + documentation for Claude Code"
  homepage "https://github.com/explicit-sh/explicit"
  version "0.3.13"
  url "https://github.com/explicit-sh/explicit/releases/download/v#{version}/explicit-v#{version}-macos-arm64.tar.gz"
  sha256 "30d034deea94ff91844fbc5201a5283ef5a1f902fd403914bd893f0bde2b19e6"
  license "MIT"

  depends_on "nono"

  def install
    bin.install "bin/explicit"

    libexec.install Dir["lib/*"]

    (bin/"explicit-server").write <<~EOS
      #!/bin/bash
      export RELEASE_ROOT="#{libexec}"
      export RELEASE_TMP="${TMPDIR:-/tmp}/explicit-server-tmp"
      mkdir -p "$RELEASE_TMP"
      exec "#{libexec}/bin/explicit_server" "$@"
    EOS
    chmod 0755, bin/"explicit-server"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/explicit help 2>&1", 0)
  end
end
