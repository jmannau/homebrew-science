class Plink2 < Formula
  desc "Free, open-source whole genome association analysis toolset."
  homepage "https://www.cog-genomics.org/plink2"
  # doi "10.1186/s13742-015-0047-8"
  # tag "bioinformatics"

  stable do
    version "1.90b4"
    url "https://github.com/chrchang/plink-ng/archive/v1.90b4.tar.gz"
    sha256 "2ab909fc6c04062be56be86cf00ad6b3927316a34ae4ceb5fc4c250074cb3d26"
  end

  bottle do
    cellar :any
    sha256 "61fba0c9016731531eaab1e88f1fc01d0ccbf41119c084e257e3f999fe8be0ad" => :sierra
    sha256 "87ef1226f0fd076e0683e2b30c006489cb76f2a44b241949cd44beec549a3126" => :el_capitan
    sha256 "540b6a0f57c322040f1338655456a32c7971a3320fdc17d09fba582930c5722e" => :yosemite
  end

  devel do
    version "1.90b4.3"
    url "https://github.com/chrchang/plink-ng.git", :revision => "49bcb9168478aad0ae047055f52ebbd9593392f3"
  end

  depends_on :fortran
  depends_on "openblas" => :optional
  depends_on "zlib"

  def install
    Dir.chdir("1.9") do
      mv "Makefile.std", "Makefile"
      ln_s Formula["zlib"].opt_include, "../zlib-1.2.11"
      cflags = "-Wall -O2 -flax-vector-conversions"
      cflags += " -I#{Formula["openblas"].opt_include}" if build.with? "openblas"
      args = ["CFLAGS=#{cflags}", "ZLIB=-L#{Formula["zlib"].opt_lib} -lz"]
      args << "BLASFLAGS=-L#{Formula["openblas"].opt_lib} -lopenblas" if build.with? "openblas"
      system "make", "plink", *args
      bin.install "plink" => "plink2"
    end
  end

  test do
    system "#{bin}/plink2", "--dummy", "513", "1423", "0.02", "--out", "dummy_cc1"
    assert File.exist?("dummy_cc1.bed")
  end
end
