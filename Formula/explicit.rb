class Explicit < Formula
  desc "Real-time Elixir code analysis for Claude Code"
  homepage "https://github.com/explicit-sh/explicit"
  url "https://github.com/explicit-sh/explicit/releases/download/v0.1.0/explicit-v0.1.0-macos-arm64.tar.gz"
  sha256 "c315f06e896d52d6987d13be9ce208c0b5e045ff5b787fbb95a9efa427fc955e"
  license "MIT"

  def install
    # Zig CLI binary
    bin.install "bin/explicit"

    # OTP release (ERTS + compiled beams)
    libexec.install Dir["lib/*"]

    # Server wrapper pointing to libexec
    (bin/"explicit-server").write <<~EOS
      #!/bin/bash
      export RELEASE_ROOT="#{libexec}"
      exec "#{libexec}/bin/explicit_server" "$@"
    EOS
    chmod 0755, bin/"explicit-server"

    # Claude Code hook script
    pkgshare.install "hooks"
  end

  def caveats
    <<~EOS
      To integrate with Claude Code, add to .claude/settings.json:

      {
        "hooks": {
          "Stop": [{
            "hooks": [{
              "type": "command",
              "command": "#{pkgshare}/hooks/explicit-stop.sh"
            }]
          }]
        }
      }

      Usage:
        explicit watch              # Start server
        explicit violations --json  # Show violations
        explicit stop               # Stop server
    EOS
  end

  test do
    assert_match "explicit", shell_output("#{bin}/explicit help 2>&1", 0)
  end
end
