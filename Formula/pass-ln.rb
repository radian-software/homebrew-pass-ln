class PassLn < Formula
  desc "Pass extension for creating symbolic links"
  homepage "https://github.com/radian-software/pass-ln"
  url "https://github.com/radian-software/pass-ln/releases/download/v2.1.1/pass-ln-2.1.1.tar.gz"
  version "2.1.1"
  sha256 "aab3485639ae3b0e5a29257dd88945ead04c06f9ee6fb6eea4af0368ed688b18"
  license "MIT"

  depends_on "pass"
  depends_on "coreutils"

  def install
    (lib/"password-store/extensions").install "lib/password-store/extensions/ln.bash"
    bash_completion.install "etc/bash_completion.d/pass-ln"
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
      Name-Email: testing@example.com
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system bin/"pass", "init", "Testing"
      system bin/"pass", "generate", "Email/testing@foo.bar", "15"
      system bin/"pass", "ln", "Email", "AltEmail"
      assert_predicate testpath/".password-store/AltEmail/testing@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end

# Local Variables:
# mode: ruby
# End:
