defmodule Joken.Signer.ConfigTest do
  use ExUnit.Case, async: true

  import Joken.Signer.Config

  doctest Joken.Signer.Config

  @valid_token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.HMwf4pIs-aI8UG5Rv2dKplZP4XKvwVT5moZGA08mogA"
  @invalid_token "invalid.token"

  def signer(_), do: Joken.hs256("my_secret")
  def valid_config() do
    [
      %Joken.Signer.Config{
        claims: %{name: "John Doe"},
        headers: %{alg: "HS256"},
        signer: &signer/1
      }
    ]
  end


  test "do the thing" do
    # IO.inspect valid_config
    IO.inspect find_config_by(valid_config, @valid_token)
  end

  test "get_value" do
    assert get_value(1, 1) === true
    assert get_value(&(&1 + 2), 1) === 3
    assert get_value(&(&1 - 1), 5) === 4
  end

  test "peek_headers_and_claims when given valid jwt token" do
    expected = %{
      claims: %{"name" => "John Doe"},
      headers: %{"alg" => "HS256", "typ" => "JWT"}
    }

    assert peek_headers_and_claims(@valid_token) === expected
  end

  test "peek_headers_and_claims when given an invalid jwt token" do
    assert_raise ArgumentError, fn ->
      peek_headers_and_claims(@invalid_token)
    end
  end
end
