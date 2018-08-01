# Joken Signer Config

Lightweight way to organize and choose Joken signer configuration based on the contents of individual jwt tokens.

### What this solves

The most common use case will probably be in letting your app know which secrets, public keys, and algorithms to use for certain issuers.

Lets say you are building an app that needs to verify a number of jwt tokens from various issuers. Each issuer might need a different algorithm and secret. Or maybe you are willing to accept a limited set of algorithms from a specific issuer that you might not be willing to do with another.

### What it does

  Given a list of `%Joken.Signer.Config`s that look like this
  ```elixir
      my_list_of_configs = [
        %Joken.Signer.Config{
          headers: %{ alg: "HS256" },
          claims: %{ iss: "some_issuer" },
          signer: fn _ -> Joken.hs256("my_secret") end
        },
        %Joken.Signer.Config{
          headers: %{ alg: "HS256" },
          claims: %{ iss: "some_other_issuer" },
          signer: fn _ -> Joken.hs512("some_other_secret") end
        },
        #...more Signer Configs...
      ]
  ```

  and a jwt token with contents like this

  ```elixir

    my_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzb21lX2lzc3VlciIsInVzZXIiOiJKYW5lIERvZSJ9.07Od3YbENjGG9yAgErAEJe8CAvguIOG7JhcXs91nyk8"
    
    # headers
    # {
    #   "alg": "HS256",
    #   "typ": "JWT"
    # },
    
    # claims
    # {
    #   "iss": "some_issuer",
    #   "user": "Jane Doe"
    # }

  ```
  We can call on `&Joken.Signer.Config.find/2` to find the correct config

  ```elixir
    Joken.Signer.Config.find(my_list_of_configs, my_token)

    %Joken.Signer.Config{
      claims: %{iss: "some_issuer"},
      headers: %{alg: "HS256"},
      signer: #Function<6.127694169/1 in :erl_eval.expr/5>
    }
  ```

  Or we can call on `&Joken.Signer.Config.get/2` to get the correct signer

  ```elixir
    Joken.Signer.Config.get(my_list_of_configs, my_token)

    %Joken.Signer{
      jwk: %{"k" => "bXlfc2VjcmV0", "kty" => "oct"},
      jws: %{"alg" => "HS256"}
    }
  ```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `joken_signer_config` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:joken_signer_config, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/joken_signer_config](https://hexdocs.pm/joken_signer_config).

