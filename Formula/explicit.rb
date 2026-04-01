class Explicit < Formula
  desc "Real-time Elixir code analysis for Claude Code"
  homepage "https://github.com/explicit-sh/explicit"
  url "https://github.com/explicit-sh/explicit/releases/download/v0.1.0/explicit-v0.1.0-macos-arm64.tar.gz"
  sha256 "c315f06e896d52d6987d13be9ce208c0b5e045ff5b787fbb95a9efa427fc955e"
  license "MIT"

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
      Initialize a project with Claude Code hooks:

        explicit init

      Or manually add to .claude/settings.json:

        "hooks": { "Stop": [{ "hooks": [{ "type": "command", "command": "explicit hooks claude stop" }] }] }

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
