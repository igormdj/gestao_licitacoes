require 'net/http'
require 'uri'
require 'json'

class PncpClient

    BASE_URL = "https://jsonplaceholder.typicode.com/posts"

    def self.buscar_dados_externos
        uri = URI.parse(BASE_URL)
        response = Net::HTTP.get_response(uri)

        if response.is_a?(Net::HTTPSuccess)
            JSON.parse(response.body)
        else
            []
        end
    end

    def self.buscar_licitacoes_relevantes
        posts = buscar_dados_externos

        posts.select { |item| item['title'].present? && item['title'].length > 20 }
    end

    def self.importar_licitacoes!
        dados = buscar_licitacoes_relevantes

        dados.each do |item|
            Licitacao.create(
                numero: "Edital-#{item['id']}",
                orgao: "Órgão Teste API",
                objeto: item['title'],
                valor: 1000.00,
                data_abertura: Time.current
            )
        end
    end
end