require 'rubygems'
require 'httparty'
require 'yajl' #requires installation of yajl
#require 'json'

module Twitter
  include HTTParty


  def self.last_20_for(individual)
    tweets = []
    fetch(timeline(individual)).each do |tweet|
      tweets << tweet["text"] if tweet 
    end  
    tweets
  end


private

  class TwitterError < StandardError; end

  # timeline : string -> string
  def self.timeline(id)
    "#{base_uri}/statuses/user_timeline/#{id}.json"
  end

  
  # get : string -> hash
  def self.fetch(id)
    response = get(id)
    begin
      if is_error_free(response)
        parse response
      end 
    rescue Exception => e
      puts e.message
    end  
  end  
  
  def self.base_uri
    "http://api.twitter.com/#{@api_version}"
  end

  def self.set_api_version (api_version="1")
    @api_version = api_version
  end
  
  def self.parse(response)
    Yajl::Parser.parse(response.body)
  end

  # is_error_free? : hash -> true or raise exception
  def self.is_error_free(response)
    message = false
    case response.code.to_i
      when 400
        data = parse(response)
        message = "(#{response.code}): #{response.message} - #{data['error'] if data}"
      when 401
        data = parse(response)
        message = "(#{response.code}): #{response.message} - #{data['error'] if data}"
      when 403
        data = parse(response)
        message = "(#{response.code}): #{response.message} - #{data['error'] if data}"
      when 404
        message = "(#{response.code}): #{response.message}"
      when 500
        message = "Twitter had an internal error. Please let them know in the group. (#{response.code}): #{response.message}"
      when 502..503
        message = "(#{response.code}): #{response.message}"
    end
    return message ? raise(TwitterError, message) : true 
  end
  
  self.set_api_version
  
end

last_20 = Twitter.last_20_for(gets.chomp)
last_20.each { |tweet| puts tweet } 
