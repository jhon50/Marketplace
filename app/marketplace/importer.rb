
class Importer

  def self.import(array, name)
    responses = []

    array.each do |url|
      response = HTTParty.get(url)
      response = Importer::nested_gsub(response)
      responses.push(response)
    end

    loja = Loja.where(nome: name).first

    responses.each do |resp|
      resp.parsed_response.each do |item|
        loja.produtos.create! item
      end
    end

    loja.save
  end


  def self.nested_gsub(object, pattern = '.', replace = '_')
    if object.is_a? Hash
      object.map do |k, v|
        [k.to_s.gsub(pattern, replace), nested_gsub(v, pattern, replace)]
      end.to_h
    else
      object
    end
  end
end