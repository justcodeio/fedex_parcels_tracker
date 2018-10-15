require 'fedex_parcels_tracker/version'
require 'savon'

module Fedex
  class Parcel
    attr_accessor :client

    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :access_key, :wsdl, :method, :data, :tracking_in_data, :ssl_version

      def initialize
        @wsdl = nil
        @access_key = nil
        @method = nil
        @tracking_in_data = nil
        @ssl_version = nil
        @data = {}
      end
    end

    def initialize
      @client = Savon.client(
        wsdl:        Fedex::Parcel.configuration.wsdl,
        ssl_version: Fedex::Parcel.configuration.ssl_version
      )
    end

    def self.track(tracking_code)
      raise 'No configuration credentials provided !' if Fedex::Parcel.configuration.blank?
      raise 'Tracking code cannot be blank' if tracking_code.blank?
      raise 'Invalid tracking code provided' unless (12..14).cover? tracking_code.length

      resp = self.new.client.call(
        Fedex::Parcel.configuration.method,
        message: self.assign_tracking_code(tracking_code)
      )

      body = resp.body
      result = self.body_contents(body)
      if resp.http.code == 200 && result.to_s.length < 90
        return { error: 'Tracking code provided no longer found' }
      else
        result
      end
    end

    def self.assign_tracking_code(tracking_code)
      tracking_in_data = Fedex::Parcel.configuration.tracking_in_data
      data = Fedex::Parcel.configuration.data
      data[tracking_in_data.to_sym] = tracking_code
      data
    end

    def self.body_contents(body)
      body[(Fedex::Parcel.configuration.method.to_s + '_response').to_sym]
    end
  end
end
