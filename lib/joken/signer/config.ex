defmodule Joken.Signer.Config do
  import Joken

  @type token :: Joken.Token.t()

  defstruct [
    :claims,
    :headers,
    :signer
  ]


  
  @doc """
      iex> IO.puts "hi"
      "asdf"
  """
  @spec peek_headers_and_claims(binary) :: String.t
  def peek_headers_and_claims(raw_jwt) when is_binary(raw_jwt),
    do: peek_headers_and_claims(token(raw_jwt))

  @spec peek_headers_and_claims(token) :: map
  def peek_headers_and_claims(jwt) do
    %{
      headers: peek_header(jwt),
      claims: peek(jwt)
    }
  end

  @spec thing(token) :: map
  def thing(haha) do
    "hs"
  end

  @doc """
  Combines peek and peek headers to give a merged map of all
  claim and header values in a jwt token
  """
  def sample_jwt() do
    "eyJhbGciOiJFUzUxMiJ9.eyJ1c2VyIjp7ImVtcGxveWVlX2lkIjo3MzQyLCJlbXBsb3llZV9udW1iZXIiOiI3OTYxIiwiZW1haWwiOiJtYXR0aGV3LmhlY2tlckBibHVlYXByb24uY29tIiwiZmFjaWxpdHlfaWQiOm51bGwsInJvbGVzIjpbIkNvcnBvcmF0ZSBNYW5hZ2VyIl19LCJpYXQiOjE1MzE5NDY5MTksImlzcyI6IldNUyIsImF1ZCI6InN0YWdpbmciLCJleHAiOjE1MzE5NTA1MTksImp0aSI6IjI5NTIxOThjLTBiZmYtNGE0YS1hZGVlLTBjNDAwMjJhMGQwNSJ9.AdW8qHj_sh0xb9LUbq6WeBtScKnp4udtEFDmqAQzuABKRXAHgpukn8RMnSO67yTnXJ9iRT_1SQUPvWzoifMRCd2NAZf0uFm7oCvVoVdDmOrzOQ4US7q6fuGDW31s3UNHY8twI3gS7YKDea87y_KT-dM_1Gi5YOehJiiI3R-M_0KSt2Et"
  end
end
