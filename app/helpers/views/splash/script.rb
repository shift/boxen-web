require 'cgi'

module Views
  module Splash
    class Script
      def initialize(params = {})
        @access_token = params.delete(:access_token)
        @login = params.delete(:login)
      end

      def endpoint
        # https://bitbucket.org/sectionme/boxen-odobo/get/1.0.2.zip
        escaped_ref_name = CGI.escape(ref_name)
        "#{bitbucket_api_url}/#{repo_name}/get/#{escaped_ref_name}.zip"
      end

      def download_url
        "#{endpoint}?access_token=#{@access_token}"
      end

      def access_token
        @access_token
      end

      def login
        @login
      end

      def repo_name
        ENV['REPOSITORY']
      end

      def ref_name
        ENV['REF'] || 'master'
      end

      def user_org
        ENV['USER_ORG']
      end

      def bitbucket_api_url
        ghe_url = ENV['BITBUCKET_ENTERPRISE_URL']
        ghe_url ? "#{ghe_url}" : "https://bitbucket.com"
      end
    end
  end
end
