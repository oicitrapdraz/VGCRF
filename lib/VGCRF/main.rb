# frozen_string_literal: true

module VGCRF
  class Main
    def self.execute(start_number, end_number)
      VGCRF::PersonLinksRecorder.new(start_number, end_number)

      data_files = Dir.entries('data/').select { |file| file.end_with? '.txt' }.map{ |file| "data/#{file}" }

      threads = []

      data_files.each_with_index do |file, index|
        threads << Thread.new do

          File.readlines(file).each do |url|
            VGCRF::PersonRecorder.execute(url, index)
          end
        end
      end

      threads.each(&:join)

      csv_files = Dir.entries('data/').select { |file| file.start_with? 'person_tmp' }.map{ |file| "data/#{file}" }

      `cat #{ csv_files.join(' ') } > data/person_#{start_number}_#{end_number}.csv`

      data_files = Dir.entries('data/').select { |file| (file.end_with? '.txt') || (file.start_with? 'person_tmp') }.map{ |file| "data/#{file}" }

      data_files.each { |file| File.delete(file) if File.exist? file }

      puts 'Listo!'
    end
  end
end
