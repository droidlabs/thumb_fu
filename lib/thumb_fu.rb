require 'open-uri'
require 'digest/md5'
module ThumbFu
  class Thumb
    attr_accessor :url, :api_key, :width

    def initialize(api_key, url, options = {})
      @api_key = api_key
      @url = url
      @width = options[:width] || 100
      @image = nil
    end

    def url
      "http://www.bitpixels.com/getthumbnail?code=#{@api_key}8&url=#{@url}&size=#{@width}"
    end

    def image
      generate unless generated?
      @image.seek(0)
      @image
    end
    
    def image_data
      image.read
    end
    
    def save(path)
      return false unless ready?
      open(path, 'wb') do |file|
        file << image_data
      end
    end
    
    def ready?
      image_hashsum != not_ready_hashsum
    end
    
    protected
    def generate
      @image = open(url)
    rescue
      false
    end

    def generated?
      !@image.nil?
    end
    
    def image_hashsum
      Digest::MD5.hexdigest(image_data)
    end
    
    def not_ready_hashsum
      Digest::MD5.hexdigest(not_ready_image)
    end
    
    def not_ready_image
      path = File.join(File.dirname(__FILE__), '..', 'images', "not_ready_#{@width}.jpg")
      open(path).read
    end
  end
end