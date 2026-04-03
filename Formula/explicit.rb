class Explicit < Formula
  desc "Real-time Elixir code analysis for Claude Code"
  homepage "https://github.com/explicit-sh/explicit"
  url "https://github.com/explicit-sh/explicit/releases/download/v0.1.0/explicit-v0.1.0-macos-arm64.tar.gz"
  sha256 "c315f06e896d52d6987d13be9ce208c0b5e045ff5b787fbb95a9efa427fc955e"
  license "MIT"

  depends_on "nono"

  def install
    bin.install "bin/explicit"

    libexec.install Dir["lib/*"]

    (bin/"explicit-server").write <<~EOS
      #!/bin/bash
      export RELEASE_ROOT="#{libexec}"
      exec "#{libexec}/bin/explicit_server" "$@"
    EOS
    chmod 0755, bin/"explicit-server"
  end

  def caveats
    <<~EOS
      Quick start:

        explicit init              # Initialize in current project
        explicit claude            # Launch Claude Code (sandboxed via nono)

      The 'explicit claude' command runs Claude in dangerous mode but
      sandboxed with nono — it can only access the current directory.

      Usage:
        explicit quality           # Quality gate report
        explicit violations        # Code violations
        explicit docs lint         # Doc health check
        explicit stop              # Stop server
    EOS
  end

  test do
    assert_match "explicit", shell_output("#{bin}/explicit help 2>&1", 0)
  end
end
