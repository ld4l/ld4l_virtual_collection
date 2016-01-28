module Ld4lVirtualCollection
  class Configuration

    attr_reader :debug_logger
    attr_reader :base_uri
    attr_reader :localname_minter
    attr_reader :metadata_callback

    def self.default_debug_logger
      @default_debug_logger = Logger.new('log/debug.log')
    end
    private_class_method :default_debug_logger

    def self.default_base_uri
      @default_base_uri = "http://localhost/".freeze
    end
    private_class_method :default_base_uri

    def self.default_localname_minter
      # by setting to nil, it will use the default minter in the minter gem
      @default_localname_minter = nil
    end
    private_class_method :default_localname_minter

    def self.default_metadata_callback
      # by setting to nil, it will use the default minter in the minter gem
      @default_metadata_callback = {}
    end
    private_class_method :default_metadata_callback

    def initialize
      @debug_logger      = self.class.send(:default_debug_logger)
      @base_uri          = self.class.send(:default_base_uri)
      @localname_minter  = self.class.send(:default_localname_minter)
      @metadata_callback = self.class.send(:default_metadata_callback)
    end

    def debug_logger=(new_debug_logger)
      @debug_logger = new_debug_logger
    end

    def reset_debug_logger
      @debug_logger = self.class.send(:default_debug_logger)
    end

    def base_uri=(new_base_uri)
      @base_uri = new_base_uri
    end

    def reset_base_uri
      @base_uri = self.class.send(:default_base_uri)
    end

    def localname_minter=(new_minter)
      @localname_minter = new_minter
    end

    def reset_localname_minter
      @localname_minter = self.class.send(:default_localname_minter)
    end

    def metadata_callback=(metadata_callback)
      @metadata_callback = metadata_callback
    end

    def register_metadata_callback(host,callback)
      @metadata_callback[host] = callback
    end

    def register_default_metadata_callback(callback)
      @metadata_callback[:DEFAULT] = callback
    end

    def find_metadata_callback(host)
      @metadata_callback[host]
    end

    def get_default_metadata_callback
      @metadata_callback[:DEFAULT]
    end

    def reset_metadata_callback
      @metadata_callback = self.class.send(:default_metadata_callback)
    end
  end
end
