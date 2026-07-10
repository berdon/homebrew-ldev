class Ldev < Formula
  desc "Local development environment manager with Traefik routing"
  homepage "https://git.hnsn.dev/auhanson/ldev"
  url "https://git.hnsn.dev/auhanson/ldev.git", tag: "v0.1.0"
  license "MIT"

  head "https://git.hnsn.dev/auhanson/ldev.git", branch: "master"

  depends_on "node"
  depends_on "traefik"

  def install
    libexec.install Dir["*"]

    bin.write_exec_script libexec/"bin/ldev"
    bin.write_exec_script libexec/"bin/ldev-mcp"
    bin.write_exec_script libexec/"bin/ldev-install-launch-agent"
    bin.write_exec_script libexec/"bin/ldev-uninstall-launch-agent"
  end

  service do
    run [opt_libexec/"bin/run-ldev-api"]
    working_dir opt_libexec
    keep_alive true
    log_path var/"log/ldev/stdout.log"
    error_log_path var/"log/ldev/stderr.log"
    environment_variables LDEV_HOME: "#{Dir.home}/.local/share/ldev"
  end

  test do
    assert_match "ldev - local dev environment manager", shell_output("#{bin}/ldev --help")
    assert_match "ldev_list_things", shell_output("#{Formula["node"].opt_bin}/node -e 'const {TOOLS}=require(\"#{libexec}/src/mcp-server\"); console.log(TOOLS.map((tool) => tool.name).join(\"\\n\"));'")
  end
end
