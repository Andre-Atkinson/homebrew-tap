class Eml2msg < Formula
  desc "Convert Outlook-for-Mac .eml files to Windows Outlook .msg"
  homepage "https://github.com/Andre-Atkinson/eml_converter"
  url "https://github.com/Andre-Atkinson/eml_converter/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "e774442df4e479ba31359de1e5470bce7683264add5d1b8062b464fbb81fc9c3"
  license "MIT"

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
