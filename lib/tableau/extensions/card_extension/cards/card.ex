defmodule Tableau.CardExtension.Cards.Card do

  @moduledoc false

  def build(filename, attrs, body) do

    attrs
    |> Map.put(:body, body)
    |> Map.put(:path, Path.dirname(filename))
    |> Map.put(:file, filename)
    |> Map.put_new_lazy(:title, fn ->
      with {:ok, document} <- Floki.parse_fragment(body),
           [hd | _] <- Floki.find(document, "h1") do
        Floki.text(hd)
      else
        _ -> nil
      end
    end)
  end

  def parse(_file_path, content) do
    Tableau.YamlFrontMatter.parse!(content, atoms: true)
  end

end
