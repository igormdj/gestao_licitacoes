class LicitacoesController < ApplicationController
  def index
    @licitacoes = Licitacao.all
  end

  def new
  end

  def create
  end
end
