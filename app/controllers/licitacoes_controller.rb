class LicitacoesController < ApplicationController
  def index
    if params[:q].present?
      @licitacoes = Licitacao.where("orgao ILIKE ? OR objeto ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%").order(created_at: :desc)
    else
      @licitacoes = Licitacao.all.order(created_at: :desc)
    end
  end

  def show
    @licitacao = Licitacao.find(params[:id])
  end

  def new
    @licitacao = Licitacao.new
  end

  def create
    @licitacao = Licitacao.new(licitacao_params)

    if @licitacao.save
      redirect_to licitacoes_path, notice: 'Licitação criada com sucesso. '
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def licitacao_params
    params.require(:licitacao).permit(:numero, :orgao, :objeto, :valor, :data_abertura)
  end
end
