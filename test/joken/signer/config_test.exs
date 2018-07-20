defmodule Joken.Signer.ConfigTest do
  use ExUnit.Case, async: true

  import Joken.Signer.Config

  doctest Joken.Signer.Config

  @valid_token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UifQ.DjwRE2jZhren2Wt37t5hlVru6Myq4AhpGLiiefF69u8"
  @invalid_token "invalid.token"

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
