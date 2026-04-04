class Explicit < Formula
  desc "Real-time Elixir code analysis + documentation for Claude Code"
  homepage "https://github.com/explicit-sh/explicit"
  version "0.3.2"
  url "https://github.com/explicit-sh/explicit/releases/download/v0.3.2/explicit-v0.3.2-macos-arm64.tar.gz"
  sha256 "f1f88a82ca2ce26611fc6f9756e5a6b0651481c086290422d2d5d5d77ff86ea2"
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
