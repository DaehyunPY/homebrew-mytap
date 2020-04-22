class AlglibCpp < Formula
  homepage "https://www.alglib.net"

  version "3.16.0"
  url "https://www.alglib.net/translator/re/alglib-#{version}.cpp.gpl.zip"
  sha256 "b5ba6d621ed510e86fd56044dae64ea9a4a78651322349ca45e4307da370c76c"
  
  depends_on "gcc" => :build
  depends_on "cmake" => :build

  bottle :unneeded
  
  def install
    ENV["CC"] = "gcc"
    ENV["CXX"] = "g++"
    (buildpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.10)
      project(alglib LANGUAGES CXX)
      aux_source_directory(src FILES)
      add_library(alglib STATIC ${FILES})
      install(TARGETS alglib)
    EOS
    mkdir "build" do
      system "cmake", buildpath, *std_cmake_args
      system "make"
      system "make", "install"
    end
    include.install Dir["src/*.h"]
  end
end