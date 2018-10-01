defmodule Asm.MixProject do
  use Mix.Project

  def project do
    [
      app: :asm,
      version: "0.0.10",
      elixir: "~> 1.7 ",
      description: "Asm is aimed at implementing an inline assembler.",
      package: [
        maintainers: ["Susumu YAMAZAKI"],
        licenses: ["Apache 2.0"],
        links: %{"GitHub" => "https://github.com/zeam-vm/asm"}
      ],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:constants, "~> 0.1.0"},
      {:ex_doc, "<= 0.19.0", only: :dev},
    ]
  end
end
