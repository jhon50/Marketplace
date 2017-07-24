class ProdutosController < ApplicationController
  before_action :set_produto, only: [:show, :edit, :update, :destroy]

  # GET /produtos
  # GET /produtos.json
  def index
    @produtos = Produto.page params[:page]
  end

  def search
    @search_for = params[:elastic]
    if @search_for.present?
      @produtos = Produto.search(@search_for).records
    else
      @produtos = Produto.page params[:page]
    end
  end

  # GET /produtos/1
  # GET /produtos/1.json
  def show
  end

  # GET /produtos/new
  def new
    @produto = Produto.new
  end

  # GET /produtos/1/edit
  def edit
  end

  # POST /produtos
  # POST /produtos.json
  def create
    @produto = Produto.new(produto_params)

    respond_to do |format|
      if @produto.save
        format.html { redirect_to @produto, notice: 'Produto was successfully created.' }
        format.json { render :show, status: :created, location: @produto }
      else
        format.html { render :new }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /produtos/1
  # PATCH/PUT /produtos/1.json
  def update
    respond_to do |format|
      if @produto.update(produto_params)
        format.html { redirect_to @produto, notice: 'Produto was successfully updated.' }
        format.json { render :show, status: :ok, location: @produto }
      else
        format.html { render :edit }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produtos/1
  # DELETE /produtos/1.json
  def destroy
    @produto.destroy
    respond_to do |format|
      format.html { redirect_to produtos_url, notice: 'Produto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import

    #IMPORT PRODUTOS FOSSIL
    array = [
        'https://www.fossil.com.br/api/catalog_system/pub/products/search?_from=0&_to=49',
        'https://www.fossil.com.br/api/catalog_system/pub/products/search?_from=50&_to=99',
        'https://www.fossil.com.br/api/catalog_system/pub/products/search?_from=200&_to=230'
    ]
    Importer::import(array, 'Fossil')

    #IMPORT PRODUTOS TIMEX
    array = [
        'http://www.timex.com.br/api/catalog_system/pub/products/search?_from=0&_to=49',
        'http://www.timex.com.br/api/catalog_system/pub/products/search?_from=50&_to=99',
        'http://www.timex.com.br/api/catalog_system/pub/products/search?_from=100&_to=130'
    ]
    Importer::import(array, 'Timex')

    #IMPORT PRODUTOS SCHUMANN
    array = [
        'https://www.schumann.com.br/api/catalog_system/pub/products/search?_from=2000&_to=2049',
        'https://www.schumann.com.br/api/catalog_system/pub/products/search?_from=2050&_to=2099',
        'https://www.schumann.com.br/api/catalog_system/pub/products/search?_from=2100&_to=2140'
    ]
    Importer::import(array, 'Schumann')

    #REFRESH ELASTICSEARCH INDEXES
    Produto.__elasticsearch__.delete_index!
    Produto.__elasticsearch__.create_index!
    Produto.import

    respond_to do |format|
      format.html { redirect_to action: :index, notice: 'Produtos importados com sucesso' }
    end
  end

  def delete_all
    Produto.delete_all

    respond_to do |format|
      format.html { redirect_to action: :index, notice: 'Todos os produtos deletados com sucesso' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_produto
      @produto = Produto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def produto_params
      params.require(:produto).permit(:nome, :preco, :parcelas, :imagem, :url)
    end
end
