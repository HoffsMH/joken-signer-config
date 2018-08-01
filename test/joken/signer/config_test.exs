defmodule Joken.Signer.Config.Test do
  use ExUnit.Case, async: true

  import Joken.Signer.Config

  doctest Joken.Signer.Config

  @valid_token "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzb21lX2lzc3VlciIsIm5hbWUiOiJKYW5lIERvZSJ9.fisuQaN9_e9wkeDlRBRAi0YhCPt4gSmTSa0IZq-wNj8"
  @near_blank_token "eyJhbGciOiJIUzI1NiJ9.e30.2ROr1Q6Tyud-NtkBttmEUUMxoaKFIOuhBZwgl89Mk0U"
  @invalid_token "invalid.token"
  @secret "my_secret"

  def signer(_), do: Joken.hs256(@secret)
  def signer(), do: Joken.hs256(@secret)

  def valid_config_list() do
    [
      %Joken.Signer.Config{
        claims: %{iss: "some_issuer"},
        headers: %{alg: "HS256"},
        signer: &signer/1
      },
      %Joken.Signer.Config{
        claims: %{iss: "some_other_issuer"},
        headers: %{alg: "HS256"},
        signer: &signer/1
      }
    ]
  end

  test "get returns a signer when given a matching token" do
    with config_list <- valid_config_list(),
         result <- get(config_list, @valid_token) do
      assert result === signer()
    end
  end

  test "find returns a config when given a matching token" do
    with config_list <- valid_config_list(),
         first_config <- Enum.at(config_list, 0),
         second_config <- Enum.at(config_list, 1),
         result <- find(config_list, @valid_token) do
      assert result === first_config
      assert result !== second_config
    end
  end

  test "find returns nil when given a token and a blank  config list" do
    with config_list <- [],
         result <- find(config_list, @valid_token) do
      assert result === nil
    end
  end

  test "find returns nil when given a token that cant be matched against any config" do
    with config_list <- valid_config_list(),
         result <- find(config_list, @near_blank_token) do
      assert result === nil
    end
  end

  test "test_equality" do
    assert test_equality(1, 1) === true
    assert test_equality(&(&1 + 2 === 3), 1) === true
    assert test_equality(&(&1 + 2 === "hello"), 1) === false
    assert test_equality(&(&1 - 1 === 2), 4) === false
    assert test_equality(&(&1 - 1 === 3), 4) === true
  end

  test "peek_headers_and_claims when given valid jwt token" do
    expected = %{
      claims: %{"name" => "Jane Doe", "iss" => "some_issuer"},
      headers: %{"alg" => "HS256"}
    }

    assert peek_headers_and_claims(@valid_token) === expected
  end

  test "peek_headers_and_claims when given a jwt token with no claims" do
    expected = %{
      claims: %{},
      headers: %{"alg" => "HS256"}
    }

    assert peek_headers_and_claims(@near_blank_token) === expected
  end

  test "peek_headers_and_claims when given an invalid jwt token" do
    assert_raise ArgumentError, fn ->
      peek_headers_and_claims(@invalid_token)
    end
  end
end
