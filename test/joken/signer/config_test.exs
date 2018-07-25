defmodule Joken.Signer.Config.Test do
  use ExUnit.Case, async: true

  import Joken.Signer.Config

  doctest Joken.Signer.Config

  @valid_token "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzb21lX2lzc3VlciIsIm5hbWUiOiJKYW5lIERvZSJ9.fisuQaN9_e9wkeDlRBRAi0YhCPt4gSmTSa0IZq-wNj8"
  @invalid_token "invalid.token"

  def signer(_), do: Joken.hs256("my_secret")

  def valid_config() do
    [
      %Joken.Signer.Config{
        claims: %{iss: "some_issuer"},
        headers: %{alg: "HS256"},
        signer: &signer/1
      }
    ]
  end

  test "do the thing" do
    # IO.inspect valid_config
    assert (find_config_by(valid_config(), @valid_token)) === "hi"
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

  test "peek_headers_and_claims when given an invalid jwt token" do
    assert_raise ArgumentError, fn ->
      peek_headers_and_claims(@invalid_token)
    end
  end
end
