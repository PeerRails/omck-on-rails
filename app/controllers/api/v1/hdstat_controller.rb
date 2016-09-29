require 'open-uri'

# coding: utf-8
module Api
  module V1
    # API HD RTMP Stat Controller
    # Class for handling request to Nginx RTMP Server
    class HdstatController < ApiApplicationController
      #load_and_authorize_resource

      # Adds JSON reference to statistics XML
      #
      # GET api/v1/stats
      # @return [JSON]
      def stats
        xml = Hash.from_xml(Nokogiri::XML(open('http://localhost:8080/stats').read).to_xml)
        render json: xml
      end

    end
  end
end
