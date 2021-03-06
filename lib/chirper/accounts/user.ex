defmodule Chirper.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chirper.Accounts.{User, Encryption}
  alias Chirper.Blog.Post

  schema "users" do
    field :encrypted_password, :string
    field :username, :string
    field :money, :string
    #field :price, Money,Ecto.Compose.Type


    # VIRTUAL FIELDS
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    has_many :posts, Post

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password, :money])
    |> validate_required([:username])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> unique_constraint(:username)
    |> downcase_username
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)
    if password do
      encrypted_password = Encryption.hash_password(password)
      put_change(changeset, :encrypted_password, encrypted_password)
    else
      changeset
    end
  end

  defp downcase_username(changeset) do
    update_change(changeset, :username, &String.downcase/1)
  end
end
