defmodule Joken.Signer.Config do
  @moduledoc """
    Joken Signer Config is used to derive an appropriate `%Joken.Signer` from a jwt token
    based on the criteria of one or many `%Joken.Signer.Config`s within a list
  """

  alias Joken.Signer

  @type token :: Joken.Token.t()
  @type claims :: %{}
  @type headers :: %{}

  @type t :: %__MODULE__{
          claims: claims,
          headers: headers,
          signer: (... -> Joken.Signer.t())
        }

  defstruct [
    :claims,
    :headers,
    :signer
  ]

  @doc """
  Combines `&peek/1` and `&peek_header/1` to give a map
  that includes both headers and claims from the token

  ### Examples

      iex> my_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UifQ.DjwRE2jZhren2Wt37t5hlVru6Myq4AhpGLiiefF69u8"
      iex> import Joken.Signer.Config
      iex> peek_headers_and_claims(my_token)
      %{
        claims: %{"name" => "John Doe"},
        headers: %{"alg" => "HS256", "typ" => "JWT"}
      }
  """
  @spec peek_headers_and_claims(binary) :: map
  def peek_headers_and_claims(raw_jwt) when is_binary(raw_jwt),
    do: peek_headers_and_claims(Joken.token(raw_jwt))

  @spec peek_headers_and_claims(token) :: map
  def peek_headers_and_claims(jwt) do
    %{
      headers: Signer.peek_header(jwt),
      claims: Signer.peek(jwt)
    }
  end
end
