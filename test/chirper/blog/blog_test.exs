defmodule Chirper.BlogTest do
  use Chirper.DataCase

  alias Chirper.Blog

  describe "posts" do
    alias Chirper.Blog.Post
    alias Chirper.Accounts

    @valid_attrs %{number: "some number", name: "some name", count : "some count"}
    @update_attrs %{number: "some updated number", name: "some updated name", count : "some updated count"}
    @invalid_attrs %{number: nil, name: nil, count: nil}

    # for user
    @valid_user_attrs %{password: "some encrypted_password", password_confirmaton: "some encrypted_password", username: "some username", money: "some money"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user_attrs)
        |> Accounts.create_user()
      Accounts.get_user!(user.id)
    end

    def post_fixture() do
      user= user_fixture()
      {:ok, created} = Blog.create_post(user, @valid_attrs)
      Blog.get_post!(created.id)
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      user = user_fixture()
      assert {:ok, %Post{} = post} = Blog.create_post(user, @valid_attrs)
      assert post.number == "some number"
      assert post.name == "some name"
      assert post.count == "some count"
    end

    test "create_post/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(user, @invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Blog.update_post(post, @update_attrs)
      assert post.number == "some updated number"
      assert post.name == "some updated namber"
      assert post.count == "some updated count"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert nil == Blog.get_post!(post.id)
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end
