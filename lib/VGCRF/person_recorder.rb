# frozen_string_literal: true

require 'csv'
require 'net/http'
require 'nokogiri'

module VGCRF
  class PersonRecorder
    def self.execute(url, index)
      begin
        uri = URI.parse(url)
        unparsed_response = Net::HTTP.get_response(uri)
        parsed_response = Nokogiri::HTML(unparsed_response.body)
      rescue StandardError => e
        VGCRF::Logger.error(e)
        retry
      end

      id = url&.split('idpersona=')&.last&.strip

      names = get_td_from(parsed_response, /apellidos/i)
      other_names = get_td_from(parsed_response, /formas/i)
      town = get_td_from(parsed_response, /pobla/i)
      residency = get_td_from(parsed_response, /residencia/i).gsub(/\s+/, ' ')
      profession = get_td_from(parsed_response, /profe/i)
      archive = get_td_from(parsed_response, /archivo/i)
      background = get_td_from(parsed_response, /fondo/i)
      series = get_td_from(parsed_response, /serie/i)
      symbol = get_td_from(parsed_response, /signatura/i)
      filing_date = get_td_from(parsed_response, /fecha/i)
      file_pages = get_td_from(parsed_response, /mero/i)
      typology = get_td_from(parsed_response, /tipolo/i)
      comments = get_td_from(parsed_response, /obser/i)

      CSV.open("data/person_tmp_#{index}.csv", 'a') do |csv|
        csv << [id, names, other_names, town, residency, profession, archive, background, series, symbol, filing_date, file_pages, typology, comments]
      end
    end

    def self.get_td_from(parsed_response, regex)
      parsed_response&.css('tr')&.detect { |tr| tr&.css('th')&.text =~ regex }&.css('td')&.text&.strip&.gsub(/\s+/, ' ')
    end
  end
end
