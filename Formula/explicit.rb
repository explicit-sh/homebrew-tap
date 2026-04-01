class Explicit < Formula
  desc "Real-time Elixir code analysis for Claude Code"
  homepage "https://github.com/explicit-sh/explicit"
  url "https://github.com/explicit-sh/explicit/releases/download/v0.1.0/explicit-v0.1.0-macos-arm64.tar.gz"
  sha256 "PLACEHOLDER"
  license "MIT"

  def install
    bin.install "bin/explicit"
    libexec.install Dir["lib/*"]

    # Create server wrapper that sets RELEASE_ROOT
    (bin/"explicit-server").write <<~EOS
      #!/bin/bash
      export RELEASE_ROOT="#{libexec}"
      exec "#{libexec}/bin/explicit_server" "$@"
    EOS
    chmod 0755, bin/"explicit-server"

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

      Start the server: explicit watch
      Check violations: explicit violations --json
    EOS
  end

  test do
    assert_match "explicit", shell_output("#{bin}/explicit help 2>&1", 0)
  end
end
