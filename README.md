# TableauExt

This repo has [Tableau](https://github.com/elixir-tools/tableau) extensions. It
is primarily for personal use and experimentation. Feel free to give it a try
or ask me questions!

## Extensions 

**Card** 

Enables the site developer to create subdirectory of markdown files with
"cards".   The source markdown files live in `_cards`.  Card contents are
available in the `@card_data` assign.

Example use: [Xmeyers](https://andyl.github.io/xmeyers)
([source](https://github.com/andyl/xmeyers))

## Installation

```elixir
def deps do
  [
    {:tableau_ext, github: "andyl/tableau_ext"}
  ]
end
```

