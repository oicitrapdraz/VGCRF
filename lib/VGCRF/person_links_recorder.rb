# frozen_string_literal: true

require 'net/http'
require 'nokogiri'

module VGCRF
  class PersonLinksRecorder
    attr_reader :urls

    def initialize(start_page, end_page)
      @urls = []

      (start_page..end_page).each do |page|
        url = "http://pares.mcu.es/victimasGCFPortal/buscadorRaw.form?d-3602157-p=#{page}"

        begin
          uri = URI.parse(url)
          unparsed_response = Net::HTTP.get_response(uri)
          parsed_response = Nokogiri::HTML(unparsed_response.body)

          person_links = parsed_response.css('table').css('a').map { |a| "http://pares.mcu.es/victimasGCFPortal/#{a['href']}".strip }

          if person_links.count != 25
            VGCRF::Logger.info("La pagina numero: #{page}, no tuvo 25 enlaces <a> dentro de la tabla <table>, verificar que paso")
          end

          urls.concat person_links
        rescue StandardError => e
          VGCRF::Logger.error(e)
          redo
        end
      end

      open('data/person_url.txt', 'a') { |f| urls.each { |url| f.puts url } }
    end
  end
end
