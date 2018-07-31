defmodule Joken.Signer.Config.Test do
  use ExUnit.Case, async: true

  import Joken.Signer.Config

  doctest Joken.Signer.Config

  @valid_token "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzb21lX2lzc3VlciIsIm5hbWUiOiJKYW5lIERvZSJ9.fisuQaN9_e9wkeDlRBRAi0YhCPt4gSmTSa0IZq-wNj8"
  @near_blank_token "eyJhbGciOiJIUzI1NiJ9.e30.2ROr1Q6Tyud-NtkBttmEUUMxoaKFIOuhBZwgl89Mk0U"
  @invalid_token "invalid.token"
  @secret "my_secret"

  def signer(_), do: Joken.hs256(@secret)

  def valid_config_list() do
    [
      %Joken.Signer.Config{
        claims: %{iss: "some_issuer"},
        headers: %{alg: "HS256"},
        signer: &signer/1
      }
    ]
  end

  test "do the thing" do
    first_config
    assert (find_config_by(valid_config_list(), @valid_token)) === valid_config_list()
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
