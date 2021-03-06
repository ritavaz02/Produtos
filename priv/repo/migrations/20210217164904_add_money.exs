defmodule Chirper.Repo.Migrations.AddMoney do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :money, :string
    end
  end
end
