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

  def find_config_by(config_list, jwt) do
    config_list
    |> Enum.find(&config_match?(&1, jwt))
  end

  def config_match?(%{headers: headers, claims: claims}, jwt) do
    with %{
           "headers" => jwt_headers,
           "claims" => jwt_claims
         } <- peek_headers_and_claims(jwt) do
      map_match?(claims, jwt_claims) && map_match?(headers, jwt_headers)
    end
  end

  @doc """
  Lets you know if all of the key value pairs in map 1 are present in map 2, but
  not that all the key value pairs  in map 2 are present in map 1

  ### Examples
    iex> map_match?(%{ "a" => "b" }, %{ "a" => "b", "c" => "d"})
    true
    iex> map_match?(%{ "a" => "a" }, %{ "a" => "b" })
    false
    iex> map_match?(%{ "b" => "a" }, %{ "a" => "b" })
    false
    iex> map_match?(%{ "b" => "a", "c" => "d" }, %{ "b" => "a" })
    false
    iex> my_match_fn = fn val -> val === "b" end
    iex> map_match?(%{ "a" => my_match_fn }, %{ "a" => "b" })
    true
    iex> my_match_fn2 = fn val -> val === "a" end
    iex> map_match?(%{ "a" => my_match_fn2 }, %{ "a" => "b" })
    false
    iex> my_match_fn3 = fn val -> val === "b" end
    iex> map_match?(%{ "c" => my_match_fn3 }, %{ "a" => "b" })
    false
  """
  def map_match?(map1, map2) do
    map1
    |> Enum.all?(&value_match?(&1, map2))
  end

  @doc """
  Runs test_equality/2 on a key value pair(tuple) in a given map

  ### Examples
    iex> test_map = %{
    iex>  "b" => "some_other_value",
    iex>  "a" => "my_value_to_test_for"
    iex>  }
    iex> value_match?({"a", "my_value_to_test_for"}, test_map)
    true
    iex> value_match?({"b", "my_value_to_test_for"}, test_map)
    false
    iex> value_match?({"a", "some_other_value"}, test_map)
    false
    iex> my_match_fn = fn val -> val === "my_value_to_test_for" end
    iex> value_match?({"a", my_match_fn }, test_map)
    true
    iex> my_match_fn = fn val -> val === "some_other_value" end
    iex> value_match?({"a", my_match_fn }, test_map)
    false
  """
  @spec value_match?({binary, any}, map) :: boolean
  def value_match?({key, test}, map) do
    with value <- Map.get(map, to_string(key)) do
      !!test_equality(test, value)
    end
  end

  @doc """
  when first argument is a function hands the second argument
  to that function and returns the result otherwise returns
  whether or not the two values are equal

  this function is meant for letting users of our api test for values
  in a jwt token in a custom way.

  ### Examples
    iex> test_equality(1, 1) 
    true
    iex> test_equality(&(&1 == 1), 1) 
    true
    iex> test_equality(&(&1 - 1 === 4), 5) 
    true
    iex> test_equality(&(&1 - 2 === 4), 5) 
    false
      
  """
  @spec test_equality(function | binary | number, binary | number) :: any
  def test_equality(func, value2) when is_function(func), do: func.(value2)
  def test_equality(value1, value2), do: value1 === value2

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
