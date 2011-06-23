require 'open-uri'
require 'digest/md5'
module ThumbFu  
  class Thumb
    attr_accessor :url, :api_key, :width

    def initialize(api_key, url, options = {})
      @api_key = api_key
      @url = url
      @width = options[:width] || 200
      @image = nil
    end

    def url
      "http://www.bitpixels.com/getthumbnail?code=#{@api_key}8&url=#{@url}&size=#{@width}"
    end

    def image
      generate unless generated?
      @image
    end
    
    def save(path)
      return false unless ready?
      open(path, 'wb') do |file|
        file << image
      end
    end
    
    def ready?
      image_hashsum != not_ready_hashsum
    end
    
    protected
    def generate
      @image = open(url).read
    rescue
      false
    end

    def generated?
      !@image.nil?
    end
    
    def image_hashsum
      Digest::MD5.hexdigest(image)
    end
    
    def not_ready_hashsum
      image_path = File.join(File.dirname(__FILE__), '..', 'images', 'not_ready.jpg')
      Digest::MD5.hexdigest(open(image_path).read)
    end
  end
end