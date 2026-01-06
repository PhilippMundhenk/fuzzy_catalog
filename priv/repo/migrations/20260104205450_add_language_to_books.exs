defmodule FuzzyCatalog.Repo.Migrations.AddLanguageToBooks do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :language, :string
    end
  end
end
