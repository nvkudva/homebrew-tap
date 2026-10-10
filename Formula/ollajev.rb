class Ollajev < Formula
  desc "Run System One decision models from Hugging Face locally, Ollama style"
  homepage "https://github.com/nvkudva/ollajev"
  url "https://files.pythonhosted.org/packages/ec/48/14a94e4395f12b3ddc899790ad8d5762da843a7f89c7672e850e9b84d7ee/ollajev-0.3.0.tar.gz"
  sha256 "162293902e5b384256905f2781c4aa55609054a86c2c52fe877cc10908daefce"
  license "Apache-2.0"

  depends_on "cmake" => :build # llama-cpp-python compiles llama.cpp
  depends_on "uv" => :build
  depends_on "python@3.12"

  # The environment holds PyTorch and llama.cpp; Homebrew must not strip or relink their libraries.
  skip_clean "libexec"

  def install
    ENV["UV_CACHE_DIR"] = buildpath/".uv-cache"
    ENV["UV_PYTHON_DOWNLOADS"] = "never"
    # llama.cpp's build picks up ccache when it is installed, but the build sandbox cannot run it.
    ENV["CMAKE_ARGS"] = "-DGGML_CCACHE=OFF"
    python = formula_opt_bin("python@3.12")/"python3.12"
    system "uv", "venv", libexec, "--python", python
    # Installing from the source folder honours its [tool.uv.sources], so Linux gets the CPU build of PyTorch.
    system "uv", "pip", "install", "--python", libexec/"bin/python", buildpath
    bin.install_symlink libexec/"bin/ollajev"
  end

  service do
    run [opt_bin/"ollajev", "serve", "--no-browser"]
    keep_alive true
    log_path var/"log/ollajev.log"
    error_log_path var/"log/ollajev.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollajev --version")
  end
end
