class Explicit < Formula
  desc "Real-time Elixir code analysis + documentation for Claude Code"
  homepage "https://github.com/explicit-sh/explicit"
  version "0.3.7"
  url "https://github.com/explicit-sh/explicit/releases/download/v#{version}/explicit-v#{version}-macos-arm64.tar.gz"
  sha256 "3c48db654f8aec5b5db5847e153eb64ceadd10323519f6d1916e2a3f24781846"
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

  def caveats
    <<~EOS
      Quick start:

        explicit init my_project   # Create project (one step)
        cd my_project
        explicit claude            # Launch Claude Code (sandboxed)

      Usage:
        explicit quality           # Quality gate (15 checks)
        explicit validate          # Docs + code validation
        explicit test              # Run mix test
        explicit stop              # Stop server
    EOS
  end

  test do
    assert_match "explicit", shell_output("#{bin}/explicit help 2>&1", 0)
  end
end
