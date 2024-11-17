# frozen_string_literal: true

require "zeitwerk"
require "logger"

module Boost
  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = name
      end
    end

    def loader
      @loader ||= Zeitwerk::Loader.for_gem
    end
  end
  loader.setup
end
