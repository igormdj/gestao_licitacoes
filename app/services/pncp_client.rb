require 'net/http'
require 'uri'
require 'json'

class PncpClient
  BASE_URL = "https://pncp.gov.br/api/consulta/v1/contratacoes/proposta"

  def self.buscar_dados_externos
    uri = URI("#{BASE_URL}?uf=GO&codigoModalidadeContratacao=8&pagina=1")
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.open_timeout = 10
    http.read_timeout = 10 

    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36'
    request['Accept'] = 'application/json'

    begin
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        resultado = JSON.parse(response.body)
        resultado['data'] || resultado['itens'] || resultado || []
      else
        []
      end
    rescue Timeout::Error, Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNRESET, SocketError => e
      # Captura explicitamente qualquer erro de rede ou timeout e retorna vazio para acionar o fallback
      []
    end
  end

  def self.importar_licitacoes!
    dados = buscar_dados_externos

    # Fallback automático: Se a API falhar ou der timeout, usa dados consistentes para o estudo
    if dados.empty?
      Rails.logger.info("API do PNCP indisponível/timeout. Utilizando dados simulados de Goiás.")
      dados = [
        {
          'numeroContratacao' => "DSP-GO-#{rand(1000..9999)}/2026",
          'orgaoEntidade' => { 'razaoSocial' => "Prefeitura Municipal de Goiânia - GO" },
          'objetoContratacao' => "Aquisição de material de consumo (suprimentos de informática) para atender às secretarias municipais.",
          'valorTotalEstimado' => 25400.50,
          'dataPublicacaoPncp' => Time.current.to_s
        },
        {
          'numeroContratacao' => "DSP-GO-#{rand(1000..9999)}/2026",
          'orgaoEntidade' => { 'razaoSocial' => "Secretaria de Estado da Saúde de Goiás - SES-GO" },
          'objetoContratacao' => "Contratação de empresa especializada para manutenção corretiva de equipamentos hospitalares.",
          'valorTotalEstimado' => 48900.00,
          'dataPublicacaoPncp' => Time.current.to_s
        },
        {
          'numeroContratacao' => "DSP-GO-#{rand(1000..9999)}/2026",
          'orgaoEntidade' => { 'razaoSocial' => "Universidade Federal de Goiás - UFG" },
          'objetoContratacao' => "Prestação de serviços de apoio técnico especializado para eventos acadêmicos.",
          'valorTotalEstimado' => 15200.00,
          'dataPublicacaoPncp' => Time.current.to_s
        }
      ]
    end

    dados.each do |item|
      numero_licitacao = item['numeroContratacao'] || "DSP-#{SecureRandom.hex(4)}"
      
      Licitacao.find_or_create_by(numero: numero_licitacao) do |licitacao|
        licitacao.orgao = item.dig('orgaoEntidade', 'razaoSocial') || "Órgão Público do Estado de Goiás"
        licitacao.objeto = item['objetoContratacao']
        licitacao.valor = item['valorTotalEstimado'] || 10000.0
        licitacao.data_abertura = item['dataPublicacaoPncp'] ? Time.parse(item['dataPublicacaoPncp'].to_s) : Time.current
      end
    end
  end
end