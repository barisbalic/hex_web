case System.argv do
  [hex | elixirs] ->
    IO.puts "Hex:     " <> hex
    IO.puts "Elixirs: " <> Enum.join(elixirs, ", ")

    HexWeb.Install.create(hex, elixirs)

  _ ->
    :ok
end

all = HexWeb.Install.all

csv =
  Enum.map_join(all, "\n", fn install ->
    Enum.join([install.hex|install.elixirs], ",")
  end)

headers = [{'content-type', 'text/csv'}]
HexWeb.Store.S3.upload(:s3_bucket, "installs/list.csv", headers, csv)

IO.puts "Uploaded installs/list.csv"

HexWeb.RegistryBuilder.rebuild

IO.puts "Rebuilt registry"
