# frozen_string_literal: true

module VGCRF
  class Logger
    attr_reader :message

    def self.info(message)
      open('log/info.txt', 'a') { |f|
        f.puts message
      }
    end

    def self.error(message)
      open('log/error.txt', 'a') { |f|
        f.puts message
      }
    end
  end
end