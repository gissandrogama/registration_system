defmodule App.Elections do
  @moduledoc """
  The Elections context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Elections.Leader
  alias App.Elections.Voter

  @doc """
  Returns the list of name.

  ## Examples

      iex> list_name()
      [%Leader{}, ...]

  """
  def list_leaders do
    Repo.all(Leader)
  end

  @doc """
  Function that returns the leader, passing the name as a parameter

    ## Examples

      iex> leader_query(%{"query_leader" => "name"})
      [%Leader{}, ...]

  """

  def leaders_query(params) do
    name = Map.fetch!(params, "query_leader")
    query = from l in Leader, where: ilike(l.name, ^"%#{name}%")
    Repo.all(query)
  end


  @doc """
  Function that receives a leader consultation and returns voters allied to them

  ## Examples

      iex> leader_voter(query)
      [%Voter{}, ...]

  """

  def leader_voter(query) do
    [head | _tail] = query
    query_m = head
    id = Map.fetch!(query_m, :id)
    query = from v in Voter, where: v.leader_by_id == ^id
    Repo.all(query)
  end

  @doc """
  Gets a single leader.

  Raises `Ecto.NoResultsError` if the Leader does not exist.

  ## Examples

      iex> get_leader!(123)
      %Leader{}

      iex> get_leader!(456)
      ** (Ecto.NoResultsError)

  """
  def get_leader!(id), do: Repo.get!(Leader, id)

  @doc """
  Creates a leader.

  ## Examples

      iex> create_leader(%{field: value})
      {:ok, %Leader{}}

      iex> create_leader(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_leader(attrs \\ %{}) do
    %Leader{}
    |> Leader.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a leader.

  ## Examples

      iex> update_leader(leader, %{field: new_value})
      {:ok, %Leader{}}

      iex> update_leader(leader, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_leader(%Leader{} = leader, attrs) do
    leader
    |> Leader.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a leader.

  ## Examples

      iex> delete_leader(leader)
      {:ok, %Leader{}}

      iex> delete_leader(leader)
      {:error, %Ecto.Changeset{}}

  """
  def delete_leader(%Leader{} = leader) do
    Repo.delete(leader)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking leader changes.

  ## Examples

      iex> change_leader(leader)
      %Ecto.Changeset{data: %Leader{}}

  """
  def change_leader(%Leader{} = leader, attrs \\ %{}) do
    Leader.changeset(leader, attrs)
  end

  @doc """
  Returns the list of voters.

  ## Examples

      iex> list_voters()
      [%Voter{}, ...]

  """
  def list_voters(params) do
    search_term = get_in(params, ["query"])

    Voter
    |> Voter.search(search_term)
    |> Repo.all()
  end

  @doc """
  Gets a single voter.

  Raises `Ecto.NoResultsError` if the Voter does not exist.

  ## Examples

      iex> get_voter!(123)
      %Voter{}

      iex> get_voter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_voter!(id), do: Repo.get!(Voter, id)

  @doc """
  Creates a voter.

  ## Examples

      iex> create_voter(%{field: value})
      {:ok, %Voter{}}

      iex> create_voter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_voter(attrs \\ %{}) do
    %Voter{}
    |> Voter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a voter.

  ## Examples

      iex> update_voter(voter, %{field: new_value})
      {:ok, %Voter{}}

      iex> update_voter(voter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_voter(%Voter{} = voter, attrs) do
    voter
    |> Voter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a voter.

  ## Examples

      iex> delete_voter(voter)
      {:ok, %Voter{}}

      iex> delete_voter(voter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_voter(%Voter{} = voter) do
    Repo.delete(voter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking voter changes.

  ## Examples

      iex> change_voter(voter)
      %Ecto.Changeset{data: %Voter{}}

  """
  def change_voter(%Voter{} = voter, attrs \\ %{}) do
    Voter.changeset(voter, attrs)
  end
end
