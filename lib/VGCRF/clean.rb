# frozen_string_literal: true

require 'csv'

module VGCRF
  class Clean
    attr_reader :message

    def self.set_initial_state
      files = [
        'data/person_url.txt',
        'data/person.csv',
        'log/error.txt',
        'log/info.txt'
      ]

      files.each { |file| File.delete(file) if File.exist? file }

      CSV.open('data/person.csv', 'w') do |csv|
        csv << ['id', 'apellidos y nombre', 'otras formas del nombre', 'poblacion', 'residencia/s', 'profesion', 'archivo', 'fondo', 'serie', 'signatura', 'fecha de expediente', 'numero de paginas del expediente', 'tipologia', 'observaciones']
      end
    end
  end
end
