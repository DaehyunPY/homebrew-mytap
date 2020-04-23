class LibxcAT43 < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  version "4.3.4"
  url "https://gitlab.com/libxc/libxc/-/archive/#{version}/libxc-#{version}.zip"
  sha256 "6a0f028d6e15d554308d0e6b9cfec59cecc0c0109d54ef4f25a9e87838cd79d7"
  
  bottle :unneeded

  keg_only :versioned_formula

  depends_on "gcc" => :build
  depends_on "cmake" => :build

  def install
    ENV["CC"] = "gcc"
    ENV["CXX"] = "g++"
    ENV["FC"] = "gfortran"
    mkdir "objdir" do
      system "cmake", "..",
        "-DBUILD_SHARED_LIBS=OFF", "-DENABLE_FORTRAN=ON", "-DENABLE_FORTRAN03=ON", \
        "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make"
      system "make", "install"
      system "cmake", "..", \
        "-DBUILD_SHARED_LIBS=ON", "-DENABLE_FORTRAN=ON", "-DENABLE_FORTRAN03=ON", \
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