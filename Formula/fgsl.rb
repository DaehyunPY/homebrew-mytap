class Fgsl < Formula
  homepage "https://github.com/reinh-bader/fgsl"

  version "1.3.0"
  url "https://github.com/reinh-bader/fgsl/archive/v#{version}.zip"
  sha256 "f6b6ec8a4d77d90dc073cd1fbfab2bb4abc4b1e64cf647ebb6d446c5857f8817"
  
  depends_on "gsl@2.4"
  depends_on "gcc" => :build
  depends_on "autoconf" => :build
  depends_on "m4" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  bottle :unneeded
  
  def install
    ENV.deparallelize
    system "mkdir", "m4"
    system "autoreconf", "--install"
    system "autoreconf"
    system "./configure", "--prefix=#{prefix}", \
      "CC=gcc", \
      "CXX=g++", \
      "FC=gfortran", \
      "gsl_LIBS=#{HOMEBREW_PREFIX}/opt/gsl@2.4/lib", \
      "PKG_CONFIG_PATH=#{HOMEBREW_PREFIX}/opt/gsl@2.4/lib/pkgconfig"
    system "make"
    system "make", "install"
  end
end