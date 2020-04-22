class GslAT24 < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"

  version "2.4"
  url "https://ftp.gnu.org/gnu/gsl/gsl-#{version}.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-#{version}.tar.gz"
  sha256 "4d46d07b946e7b31c19bbf33dda6204d7bedc2f5462a1bae1d4013426cd1ce9b"

  bottle :unneeded
  
  keg_only :versioned_formula

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
