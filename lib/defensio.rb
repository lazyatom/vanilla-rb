class Defensio
  cattr_accessor :format
  self.format = :xml
  
  cattr_accessor :service_type
  self.service_type = :app # Can be :blog
  
  cattr_accessor :api_version
  self.api_version = '1.2'
  
  cattr_accessor :api_key
  cattr_accessor :owner_url
  
  def self.configure(confhash)
    if confhash['test']
      @mock = true
      self.owner_url = 'http://www.example.com'
      return
    else
      confhash.each do |prop, val|
        self.send("#{prop}=", val)
      end
    end
  end
  
  def self.method_missing(name, *args)
    self.post(name.to_s.dasherize, *args)
  end
  
  private
    def self.connection
      uri = URI.parse('http://api.defensio.com/')
      Net::HTTP.start(uri.host, uri.port)
    end
  
    def self.post(action, params = {})
      resp = connection.post(real_path(action), params_from_hash(params))
      raise "Problem with request: #{action}" unless resp.code == '200'
      parse_response(resp.body)
    end
  
    def self.real_path(action)
      "/#{service_type}/#{api_version}/#{action}/#{api_key}.#{format}"
    end
  
    def self.params_from_hash(params = {})
      # Thanks Net::HTTPHeader
      params.stringify_keys.merge('owner-url' => owner_url).map {|k,v| "#{CGI.escape(k.dasherize.to_s)}=#{CGI.escape(v.to_s)}" }.join('&') 
    end
  
    def self.parse_response(body)
      case format
      when :yaml
        YAML.load(body)
      when :xml
        Hash.from_xml(body)
      end
    end
end
