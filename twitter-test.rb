require 'test/unit'
require 'twitter.rb'

class TestTwitter < Test::Unit::TestCase
  
  def test_base_uri_version
    # should start with a 1 by default
    assert_equal(Twitter.base_uri, "http://api.twitter.com/1")
  end

  def test_timeline
    assert_equal(Twitter.timeline("silva_marina"), "http://api.twitter.com/1/statuses/user_timeline/silva_marina.json")
  end

  def test_is_error_free?
    assert_raise(Twitter::TwitterError){
      Twitter.is_error_free(Twitter.get("http://api.twitter.com/1/statuses/user_timeline/silva_marinaERROR.json"))
    }
    assert(Twitter.is_error_free(Twitter.get("http://api.twitter.com/")))
  end

  
  def test_fetch_timeline
    assert_equal(Twitter.last_20_for("silva_marina").length, 19)
  end


end

