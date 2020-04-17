# frozen_string_literal: true

require 'csv'

module VGCRF
  class Clean
    def self.set_initial_state
      files = [
        'data/person.csv',
        'log/error.txt',
        'log/info.txt'
      ]

      data_files = Dir.entries('data/').select { |file| (file.end_with? '.txt') || (file.start_with? 'person_tmp') }.map { |file| "data/#{file}" }

      files.concat(data_files).each do |file|
        File.delete(file) if File.exist? file
      end

      CSV.open('data/person_header.csv', 'w') do |csv|
        csv << ['id', 'apellidos y nombre', 'otras formas del nombre', 'poblacion', 'residencia/s', 'profesion', 'archivo', 'fondo', 'serie', 'signatura', 'fecha de expediente', 'numero de paginas del expediente', 'tipologia', 'observaciones']
      end
    end
  end
end
