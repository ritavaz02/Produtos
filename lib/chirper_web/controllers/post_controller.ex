defmodule ChirperWeb.PostController do
  use ChirperWeb, :controller

  alias Chirper.Blog
  alias Chirper.Blog.Post

  def index(conn, _params) do
    posts = Blog.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Blog.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Blog.create_post(conn.assigns.current_user, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    case post do
      nil ->
        redirect(conn, to: Routes.post_path(conn, :index))
      _ ->
        render(conn, "show.html", post: post)
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    changeset = Blog.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id)

    case Blog.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    {:ok, _post} = Blog.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  # não foram usados, erro: no action :buy for ChirperWeb.Router.Helpers.post_path/3.
  def buy(conn, %{"money" => money, "count" => count, "number" => number}) do
    if money - number <= 0 do
      conn
      |> put_flash(:info, "You don't have enought money to bye the product.")
      |> redirect(to: Routes.post_path(conn, :index))
    else 
      conn
      |> put_flash(:info, "Product purchased successfully.")
      |> update_post(count)
      |> redirect(to: Routes.post_path(conn, :index))
    end
  end

  def update_post(conn, %{"count" => count}) do
    cond do
      (count - 1) <= 0 -> Post.update(count = 0)
      true -> Post.update(count =  count - 1)
    end
  end
end
