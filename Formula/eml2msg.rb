class Eml2msg < Formula
  desc "Convert Outlook-for-Mac .eml files to Windows Outlook .msg"
  homepage "https://github.com/Andre-Atkinson/eml_converter"
  url "https://github.com/Andre-Atkinson/eml_converter/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "92cfa9675c61f74956185f33c631aad00a3da14c355d888b88a777e9720854e2"
  license "MIT"
  revision 1

  depends_on "dotnet" => :build
  depends_on :macos

  def install
    rid = Hardware::CPU.arm? ? "osx-arm64" : "osx-x64"
    system "dotnet", "publish", "src/Eml2Msg",
           "-c", "Release", "-o", "publish", "-r", rid,
           "--self-contained", "true",
           "-p:PublishSingleFile=true",
           "-p:IncludeNativeLibrariesForSelfExtract=true"
    bin.install "publish/eml2msg"

    # Ship the Quick Action installer and its inspector.
    libexec.install "tools/install_quickaction.py", "tools/inspect_msg.py"

    # One-command wrapper for enabling the per-user Finder Quick Action, with the
    # installed binary baked in. Homebrew can't create the action itself (it
    # lives in ~/Library/Services, outside the prefix), so this keeps the one
    # manual step trivial: `eml2msg-quickaction --from "..."`.
    (bin/"eml2msg-quickaction").write <<~SH
      #!/bin/bash
      exec /usr/bin/python3 "#{opt_libexec}/install_quickaction.py" --binary "#{opt_bin}/eml2msg" "$@"
    SH
    chmod 0755, bin/"eml2msg-quickaction"
  end

  def caveats
    <<~EOS
      Enable the Finder "Convert to MSG" Quick Action (right-click .eml files):
        eml2msg-quickaction --from "Your Name <you@example.com>"

      Remove it with:
        eml2msg-quickaction --uninstall

      If it does not appear, switch it on under System Settings > General >
      Login Items & Extensions > Services > Files & Folders.
    EOS
  end

  test do
    assert_match "eml2msg", shell_output("#{bin}/eml2msg --help")
    assert_match "install_quickaction.py", File.read(bin/"eml2msg-quickaction")
  end
end
