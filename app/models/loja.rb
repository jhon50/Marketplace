class Loja
  include Mongoid::Document

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :produtos
  accepts_nested_attributes_for :produtos, :allow_destroy => true

  field :nome, type: String
  field :website, type: String
  field :logo, type: String
  field :email, type: String

  def as_indexed_json(options={})
    as_json(except: [:id, :_id])
  end

end
