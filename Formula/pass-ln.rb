class PassLn < Formula
  desc "Pass extension for creating symbolic links"
  homepage "https://github.com/raxod502/pass-ln"
  url "https://github.com/raxod502/pass-ln/releases/download/v2.0.0/pass-ln-2.0.0.tar.gz"
  version "2.0.0"
  sha256 "e9521261347c499409a76d6937304ff7ac6ed190cc212bac58cf893a8bb72d72"
  license "MIT"

  depends_on "pass"
  depends_on "coreutils"

  def install
    (lib/"password-store/extensions").install "lib/password-store/extensions/ln.bash"
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
