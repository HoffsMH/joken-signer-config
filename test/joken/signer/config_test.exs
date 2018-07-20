defmodule Joken.Signer.ConfigTest do
  use ExUnit.Case, async: true

  import Joken.Signer.Config

  doctest Joken.Signer.Config

  @valid_token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UifQ.DjwRE2jZhren2Wt37t5hlVru6Myq4AhpGLiiefF69u8"
  @invalid_token "invalid.token"
  @valid_config [
    %Joken.Signer.Config{
      claims: %{name: "John Doe"},
      headers: %{alg: "HS256"}
    }
  ]

  test "do the thing" do
    assert find_config_by(@valid_config, @valid_token) === "Hi"
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
