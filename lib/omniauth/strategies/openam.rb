require 'omniauth'

module OmniAuth
	module Strategies
	class Openam
		include OmniAuth::Strategy
			autoload :Configuration, 'omniauth/strategies/openam/configuration'
			
			def initialize(app, options = {}, &block)
				options.symbolize_keys!()
				super(app, {:name=> :openam}.merge(options), &block)
				@config = OmniAuth::Strategies::Openam::Configuration.new(options)
			end

			protected
			def request_phase
				redirect "#{@config.auth_url}?goto=#{@config.redirect_url}"
			end

			def auth_hash
				OmniAuth::Utils.deep_merge(super, {
					'uid' => @userinfo['cn'][0],
					'info' => user_info_hash
				})
			end

			def user_info_hash
				user = Hash.new
				user['username'] = @userinfo['cn'][0]
				user['email'] = @userinfo['mail'][0]
				user['firstName'] = @userinfo['givenName'][0]
				user['lastName'] = @userinfo['sn'][0]
				user['name'] = "#{user['firstName']} #{user['lastName']}"
				user
			end
	
			def callback_phase 
				token	= request.cookies[@config.cookie_name]
				conn = Faraday.new(:url => @config.auth_url, :ssl => {:verify => !@config.disable_ssl_verification}) do |faraday|
					faraday.request	:url_encoded			 # form-encode POST params
					faraday.response :logger					# log requests to STDOUT
					faraday.adapter	Faraday.default_adapter	# make requests with Net::HTTP
				end
				data = conn.post "#{URI(@config.auth_url).path}/identity/attributes", { :subjectid => token }
				@userinfo = parse_user_attribute_response(data)
				
				return fail!(:invalid_credentials) if @userinfo.nil? || @userinfo.empty?
				super
			end

			def parse_user_attribute_response(response)
				opensso_user = Hash.new{ |h,k| h[k] = Array.new }
				attribute_name = ''
				lines = response.body.split(/\n/)
				lines.each do |line|
					if line.match(/^userdetails.attribute.name=/)
						attribute_name = line.gsub(/^userdetails.attribute.name=/, '').strip
					elsif line.match(/^userdetails.attribute.value=/)
						opensso_user[attribute_name] << line.gsub(/^userdetails.attribute.value=/, '').strip
					end
				end
				opensso_user
			end

			def session
				@env.nil? ? {} : super
			end
	end
	end
end
