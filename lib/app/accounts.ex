defmodule App.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Accounts.{Adm, AdmNotifier, AdmToken}

  ## Database getters

  @doc """
  Gets a adm by email.

  ## Examples

      iex> get_adm_by_email("foo@example.com")
      %Adm{}

      iex> get_adm_by_email("unknown@example.com")
      nil

  """
  def get_adm_by_email(email) when is_binary(email) do
    Repo.get_by(Adm, email: email)
  end

  @doc """
  Gets a adm by email and password.

  ## Examples

      iex> get_adm_by_email_and_password("foo@example.com", "correct_password")
      %Adm{}

      iex> get_adm_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_adm_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    adm = Repo.get_by(Adm, email: email)
    if Adm.valid_password?(adm, password), do: adm
  end

  @doc """
  Gets a single adm.

  Raises `Ecto.NoResultsError` if the Adm does not exist.

  ## Examples

      iex> get_adm!(123)
      %Adm{}

      iex> get_adm!(456)
      ** (Ecto.NoResultsError)

  """
  def get_adm!(id), do: Repo.get!(Adm, id)

  ## Adm registration

  @doc """
  Registers a adm.

  ## Examples

      iex> register_adm(%{field: value})
      {:ok, %Adm{}}

      iex> register_adm(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  
  def register_adm(attrs) do
    %Adm{}
    |> Adm.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking adm changes.

  ## Examples

      iex> change_adm_registration(adm)
      %Ecto.Changeset{data: %Adm{}}

  """
  def change_adm_registration(%Adm{} = adm, attrs \\ %{}) do
    Adm.registration_changeset(adm, attrs)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the adm e-mail.

  ## Examples

      iex> change_adm_email(adm)
      %Ecto.Changeset{data: %Adm{}}

  """
  def change_adm_email(adm, attrs \\ %{}) do
    Adm.email_changeset(adm, attrs)
  end

  @doc """
  Emulates that the e-mail will change without actually changing
  it in the database.

  ## Examples

      iex> apply_adm_email(adm, "valid password", %{email: ...})
      {:ok, %Adm{}}

      iex> apply_adm_email(adm, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_adm_email(adm, password, attrs) do
    adm
    |> Adm.email_changeset(attrs)
    |> Adm.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the adm e-mail in token.

  If the token matches, the adm email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_adm_email(adm, token) do
    context = "change:#{adm.email}"

    with {:ok, query} <- AdmToken.verify_change_email_token_query(token, context),
         %AdmToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(adm_email_multi(adm, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp adm_email_multi(adm, email, context) do
    changeset = adm |> Adm.email_changeset(%{email: email}) |> Adm.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:adm, changeset)
    |> Ecto.Multi.delete_all(:tokens, AdmToken.adm_and_contexts_query(adm, [context]))
  end

  @doc """
  Delivers the update e-mail instructions to the given adm.

  ## Examples

      iex> deliver_update_email_instructions(adm, current_email, &Routes.adm_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_update_email_instructions(%Adm{} = adm, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, adm_token} = AdmToken.build_email_token(adm, "change:#{current_email}")

    Repo.insert!(adm_token)
    AdmNotifier.deliver_update_email_instructions(adm, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the adm password.

  ## Examples

      iex> change_adm_password(adm)
      %Ecto.Changeset{data: %Adm{}}

  """
  def change_adm_password(adm, attrs \\ %{}) do
    Adm.password_changeset(adm, attrs)
  end

  @doc """
  Updates the adm password.

  ## Examples

      iex> update_adm_password(adm, "valid password", %{password: ...})
      {:ok, %Adm{}}

      iex> update_adm_password(adm, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_adm_password(adm, password, attrs) do
    changeset =
      adm
      |> Adm.password_changeset(attrs)
      |> Adm.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:adm, changeset)
    |> Ecto.Multi.delete_all(:tokens, AdmToken.adm_and_contexts_query(adm, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{adm: adm}} -> {:ok, adm}
      {:error, :adm, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_adm_session_token(adm) do
    {token, adm_token} = AdmToken.build_session_token(adm)
    Repo.insert!(adm_token)
    token
  end

  @doc """
  Gets the adm with the given signed token.
  """
  def get_adm_by_session_token(token) do
    {:ok, query} = AdmToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Repo.delete_all(AdmToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc """
  Delivers the confirmation e-mail instructions to the given adm.

  ## Examples

      iex> deliver_adm_confirmation_instructions(adm, &Routes.adm_confirmation_url(conn, :confirm, &1))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_adm_confirmation_instructions(confirmed_adm, &Routes.adm_confirmation_url(conn, :confirm, &1))
      {:error, :already_confirmed}

  """
  def deliver_adm_confirmation_instructions(%Adm{} = adm, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if adm.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, adm_token} = AdmToken.build_email_token(adm, "confirm")
      Repo.insert!(adm_token)
      AdmNotifier.deliver_confirmation_instructions(adm, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a adm by the given token.

  If the token matches, the adm account is marked as confirmed
  and the token is deleted.
  """
  def confirm_adm(token) do
    with {:ok, query} <- AdmToken.verify_email_token_query(token, "confirm"),
         %Adm{} = adm <- Repo.one(query),
         {:ok, %{adm: adm}} <- Repo.transaction(confirm_adm_multi(adm)) do
      {:ok, adm}
    else
      _ -> :error
    end
  end

  defp confirm_adm_multi(adm) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:adm, Adm.confirm_changeset(adm))
    |> Ecto.Multi.delete_all(:tokens, AdmToken.adm_and_contexts_query(adm, ["confirm"]))
  end

  ## Reset password

  @doc """
  Delivers the reset password e-mail to the given adm.

  ## Examples

      iex> deliver_adm_reset_password_instructions(adm, &Routes.adm_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_adm_reset_password_instructions(%Adm{} = adm, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, adm_token} = AdmToken.build_email_token(adm, "reset_password")
    Repo.insert!(adm_token)
    AdmNotifier.deliver_reset_password_instructions(adm, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the adm by reset password token.

  ## Examples

      iex> get_adm_by_reset_password_token("validtoken")
      %Adm{}

      iex> get_adm_by_reset_password_token("invalidtoken")
      nil

  """
  def get_adm_by_reset_password_token(token) do
    with {:ok, query} <- AdmToken.verify_email_token_query(token, "reset_password"),
         %Adm{} = adm <- Repo.one(query) do
      adm
    else
      _ -> nil
    end
  end

  @doc """
  Resets the adm password.

  ## Examples

      iex> reset_adm_password(adm, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %Adm{}}

      iex> reset_adm_password(adm, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_adm_password(adm, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:adm, Adm.password_changeset(adm, attrs))
    |> Ecto.Multi.delete_all(:tokens, AdmToken.adm_and_contexts_query(adm, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{adm: adm}} -> {:ok, adm}
      {:error, :adm, changeset, _} -> {:error, changeset}
    end
  end
end
