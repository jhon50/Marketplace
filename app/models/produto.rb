class Produto
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  belongs_to :loja

  def as_indexed_json(options={})
    as_json(except: [:id, :_id])
  end

  field :productId, type: Integer
  field :nome, type: String
  field :preco, type: BigDecimal
  field :parcelas, type: String
  field :imagem, type: String
  field :url, type: String
end
