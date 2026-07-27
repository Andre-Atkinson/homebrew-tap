class Eml2msg < Formula
  desc "Convert Outlook-for-Mac .eml files to Windows Outlook .msg"
  homepage "https://github.com/Andre-Atkinson/eml_converter"
  url "https://github.com/Andre-Atkinson/eml_converter/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "92cfa9675c61f74956185f33c631aad00a3da14c355d888b88a777e9720854e2"
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
    # Ship the Quick Action installer and its inspector so users can enable the
    # Finder action against the installed binary (see caveats).
    libexec.install "tools/install_quickaction.py", "tools/inspect_msg.py"
  end

  def caveats
    <<~EOS
      To add the Finder "Convert to MSG" Quick Action (right-click .eml files):
        python3 #{libexec}/install_quickaction.py \\
          --binary #{bin}/eml2msg --from "Your Name <you@example.com>"

      Remove it with:
        python3 #{libexec}/install_quickaction.py --uninstall
    EOS
  end

  test do
    assert_match "eml2msg", shell_output("#{bin}/eml2msg --help")
  end
end
