defmodule Tableau.CardExtension.Cards.HTMLConverter do
  @moduledoc false
  def convert(_filepath, body, _attrs, _opts) do
    {:ok, config} = :tableau
                    |> Application.get_env(:config, :%{})
                    |> Map.new()
                    |> Tableau.Config.new()

    MDEx.to_html(body, config.markdown[:mdex])
  end
end
