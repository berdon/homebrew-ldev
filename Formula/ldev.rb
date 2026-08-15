class Ldev < Formula
  desc "Local development environment manager with Traefik routing"
  homepage "https://github.com/berdon/ldev"
  url "https://github.com/berdon/ldev.git",
      tag:      "v0.1.9",
      revision: "8cbe1d1e5a102bffb680e7c292492af7948bcd83"
  license "MIT"

  head "https://github.com/berdon/ldev.git", branch: "master"

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
    script = "const {TOOLS}=require('#{libexec}/src/mcp-server'); " \
             "console.log(TOOLS.map((tool) => tool.name).join('\\n'));"
    assert_match "ldev_list_things", shell_output("#{formula_opt_bin("node")}/node -e #{script.shellescape}")
  end
end
