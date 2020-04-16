# frozen_string_literal: true

require 'byebug'
require 'net/http'
require 'nokogiri'

module VGCRF
  class PersonParser
    attr_reader :id, :names, :other_names, :town, :residency, :profession, :archive, :background, :series, :symbol, :filing_date, :file_pages, :typology, :comments

    def initialize(url)
      uri = URI.parse(url)
      unparsed_response = Net::HTTP.get_response(uri)
      parsed_response = Nokogiri::HTML(unparsed_response.body)

  		@id = url&.split('idpersona=')&.last

      tds = parsed_response.css('td')

      @names = tds[0].text.strip
      @other_names = tds[1].text.strip
      @town = tds[2].text.strip
      @residency = tds[3].text.strip
      @profession = tds[4].text.strip
      @archive = tds[5].text.strip
      @background = tds[6].text.strip
      @series = tds[7].text.strip
      @symbol = tds[8].text.strip
      @filing_date = tds[9].text.strip
      @file_pages = tds[10].text.strip
      @typology = tds[11].text.strip
      @comments = tds[12].text.strip

      VGCRF::Logger.info("La persona con ID: #{id} y URL: #{url} no tuvo 13 etiquetas <td>, verificar que paso") if parsed_response.css('td').count != 13
    rescue StandardError => e
      VGCRF::Logger.error(e)
    end
  end
end