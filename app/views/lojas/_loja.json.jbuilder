json.extract! loja, :id, :nome, :website, :logo, :email, :created_at, :updated_at
json.url loja_url(loja, format: :json)
