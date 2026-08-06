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
end