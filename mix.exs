defmodule Cognixir.Mixfile do
    use Mix.Project
    use Mix.Config

    def project do
        [app: :Cognixir,
         version: "0.2.0",
         elixir: "~> 1.3",
         description: description(),
         package: package(),
         deps: deps(),
         build_embedded: Mix.env == :prod,
         start_permanent: Mix.env == :prod,
         deps: deps()]
    end

    # Configuration for the OTP application
    #
    # Type "mix help compile.app" for more information
    def application do
        [applications: [:logger, :poison, :httpotion]]
    end

    defp deps do
        [
            {:httpotion, "~> 3.0.2"},
            {:poison, "~> 3.0"},
            {:ex_doc, "~> 0.11", only: :dev}
        ]
    end


    defp description do
        """
        Elixir Client for Microsoft Cognitive Services. With this library you can access the cognitive services api and add machine intelligence to your elixir application!
        """
    end

    defp package do
         [name: :cognixir,
         files: ["lib", "mix.exs", "README*", "LICENSE*"],
         maintainers: ["Gregor Tätzner"],
         licenses: ["MIT"],
         links: %{"GitHub" => "https://github.com/BrummbQ/cognixir"}]
    end
end
