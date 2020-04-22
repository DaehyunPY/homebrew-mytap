class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  version "5.0.0"
  url "https://gitlab.com/libxc/libxc/-/archive/#{version}/libxc-#{version}.zip"
  sha256 "4533a26213ba104301036378f2c2020c58ba12a7c971bdb1d5e55f09ab7ab394"
  
  bottle :unneeded

  depends_on "gcc" => :build
  depends_on "cmake" => :build

  def install
    ENV["CC"] = "gcc"
    ENV["CXX"] = "g++"
    ENV["FC"] = "gfortran"
    mkdir "objdir" do
      system "cmake", "..",
        "-DBUILD_SHARED_LIBS=OFF", "-DENABLE_FORTRAN=ON", \
        "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make"
      system "make", "install"
      system "cmake", "..", \
        "-DBUILD_SHARED_LIBS=ON", "-DENABLE_FORTRAN=ON", \
        "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf(\"%d.%d.%d\", major, minor, micro);
      }
    EOS
    if OS.mac?
      system ENV.cc, "test.c", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ctest"
    else
      system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lm", "-lxc", "-o", "ctest"
    end
    system "./ctest"

    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f90_types_m
        use xc_f90_lib_m
      end program lxctest
    EOS
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ftest"
    system "./ftest"
  end
end