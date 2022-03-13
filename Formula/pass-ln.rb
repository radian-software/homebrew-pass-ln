class PassLn < Formula
  desc "Pass extension for creating symbolic links"
  homepage "https://github.com/raxod502/pass-ln"
  url "https://github.com/raxod502/pass-ln/releases/download/v2.0.1/pass-ln-2.0.1.tar.gz"
  version "2.0.1"
  sha256 "3850f6fbb8d4b5d43fd79dcc76657cd71499498c19dce7fa25c73fea7ab66501"
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
