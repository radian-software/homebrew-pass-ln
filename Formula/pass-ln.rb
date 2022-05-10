class PassLn < Formula
  desc "Pass extension for creating symbolic links"
  homepage "https://github.com/radian-software/pass-ln"
  url "https://github.com/radian-software/pass-ln/releases/download/v2.1.0/pass-ln-2.1.0.tar.gz"
  version "2.1.0"
  sha256 "84ff8f2012c76d6429c29d0b0878f284cca5cda93336bd006d372e5e4c7968e7"
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
