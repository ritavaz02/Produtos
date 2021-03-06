defmodule Chirper.Repo.Migrations.AddProducts do
  use Ecto.Migration

  def change do
     alter table(:posts) do
        add :name, :string
        add :number, :string
        add :count, :integer
        remove :title
        remove :body
     end
  end
end
