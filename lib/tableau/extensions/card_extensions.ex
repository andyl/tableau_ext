defmodule Tableau.CardExtension do
  @moduledoc """
  Cards are markdown files (with YAML frontmatter) in the configured cards
  directory will be automatically compiled into Tableau cards.

  Card data is automatically parsed and made available in `@card_data` assign,
  populated with a list of cards.

  The cards directory may contain subdirectories.  In Page and Layout
  templates, use the `path` and `file` fields to filter card elements as
  desired.

  Each Tableau.Card in the `@card_data` assign contain the following fields:
    - `date` - file modification date
    - `path` - the directory path of the card file
    - `file` - the full file-name of the card file
    - `body` - the HTML generated from the markdown text
    - `title` - the first H1 of the body
    - <attrs> - one field for every frontmatter attribute in the markdown file

  ## Configuration

  - `:enabled` - boolean - Extension is active or not.
  - `:dir` - string - Directory to scan for data files. Defaults to `_cards`

  ## Options

  Frontmatter is compiled with `yaml_elixir` and all keys are converted to atoms.

  ## Example

  ```yaml
  id: "GettingStarted"
  title: "Getting Started"
  permalink: "/docs/:title"
  layout: "ElixirTools.CardLayout"
  ```

  ### Example

  ```elixir
  config :tableau, Tableau.CardExtension, enabled: true
  ```
  """

  use Tableau.Extension, key: :cards, type: :pre_build, priority: 100

  {:ok, config} = :tableau
                  |> Application.compile_env(Tableau.CardExtension, %{})
                  |> Map.new()
                  |> Tableau.CardExtension.Config.new()

  @config config

  def run(token) do
    :global.trans(
      {:create_cards_module, make_ref()},
      fn ->
        Module.create(
          Tableau.CardExtension.Cards,
          quote do
            use NimblePublisher,
              build: __MODULE__.Card,
              from: "#{unquote(@config.dir)}/**/*.md",
              as: :cards,
              parser: Tableau.CardExtension.Cards.Card,
              html_converter: Tableau.CardExtension.Cards.HTMLConverter

            def cards(_opts \\ []) do
              @cards
            end
          end,
          Macro.Env.location(__ENV__)
        )

        for {mod, _, _} <- :code.all_available(),
            mod = Module.concat([to_string(mod)]),
            {:ok, :card} == Tableau.Graph.Node.type(mod),
            mod.__tableau_opts__()[:__tableau_card_extension__] do
          :code.purge(mod)
          :code.delete(mod)
        end

        cards = apply(Tableau.CardExtension.Cards, :cards, [])

        {:ok, Map.put(token, :card_data, cards)}
      end,
      [Node.self()],
      :infinity
    )
  end
end
