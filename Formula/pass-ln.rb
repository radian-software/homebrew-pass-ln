class PassLn < Formula
  desc "Pass extension for creating symbolic links"
  homepage "https://github.com/raxod502/pass-ln"
  url "https://github.com/raxod502/pass-ln/releases/download/v1.0.0/pass-ln-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "828bcb6118a55182d9ae8db4f47465bc14b5488b09c8efe179fe845350844003"
  license "MIT"

  depends_on "pass"
  depends_on "coreutils"

  def install
    (lib/"password-store/extensions").install "lib/password-store/extensions/pass-ln.bash" => "ln.bash"
    prefix.install "share/doc/pass-ln/CHANGELOG.md"
    man1.install "share/man/man1/pass-ln.1"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system bin/"pass", "init", "Testing"
      system bin/"pass", "generate", "Email/testing@foo.bar", "15"
      system bin/"pass", "generate", "Email", "AltEmail"
      assert_predicate testpath/".password-store/AltEmail/testing@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
