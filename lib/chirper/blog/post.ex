defmodule Chirper.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :name, :string
    field :number, :string
    field :count, :integer
    #field :body, :string
    #field :title, :string
    # field :user_id, :id
    belongs_to :user, Chirper.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:name, :number, :count])
    |> validate_required([:name, :number, :count])
    |> unique_constraint(:user_id)
  end
end
