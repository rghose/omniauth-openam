module OmniAuth
	module Strategies
	class Openam
		class Configuration
				DEFAULT_CONTENT_TYPE = 'application/json'
				DEFAULT_COOKIE_NAME = 'iPlanetDirectoryPro'

				attr_reader :redirect_url, :disable_ssl_verification, :auth_url, :content_type, :cookie_name

				alias :"disable_ssl_verification?" :disable_ssl_verification

				def initialize(params)
					parse_params params
				end

				private

				def parse_params(options)
					unless options.include?(:openam_url)
						raise ArgumentError.new("The server url (openam_url) is not provided in configuration.")
					end
					@auth_url = options[:openam_url]
					@content_type = options[:content_type] || DEFAULT_CONTENT_TYPE
					@cookie_name = options[:cookie_name] || DEFAULT_COOKIE_NAME
					@disable_ssl_verification = options[:disable_ssl]
					@redirect_url = options[:redirect_url]
				end
			end
		end
	end
end
