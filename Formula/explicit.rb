class Explicit < Formula
  desc "Real-time Elixir code analysis + documentation for Claude Code"
  homepage "https://github.com/explicit-sh/explicit"
  url "https://github.com/explicit-sh/explicit/releases/download/v0.2.0/explicit-v0.2.0-macos-arm64.tar.gz"
  sha256 "7b4375f9b2df2ed4e304545296255d89df67bd3d53ef642ba413eb7272fd64c5"
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

        explicit init my_project   # Create a new project
        cd my_project
        explicit init              # Set up schema, hooks, skills
        explicit claude            # Launch Claude Code (sandboxed)

      Usage:
        explicit quality           # Quality gate (tests, docs, lint)
        explicit violations        # Code violations
        explicit docs lint         # Doc health check
        explicit test              # Run mix test
        explicit stop              # Stop server
    EOS
  end

  test do
    assert_match "explicit", shell_output("#{bin}/explicit help 2>&1", 0)
  end
end
