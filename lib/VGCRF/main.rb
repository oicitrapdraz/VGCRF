# frozen_string_literal: true

module VGCRF
  class Main
    def self.execute
      VGCRF::PersonLinksRecorder.new(1, 3)

      File.readlines('data/person_url.txt').each do |url|
        VGCRF::PersonRecorder.execute(url)
      end

      puts 'Listo'
    end
  end
end
