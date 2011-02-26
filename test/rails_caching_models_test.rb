require 'test_helper'

class RailsCachingModelsTest < ActiveSupport::TestCase
  load_schema
  
  class Item < ActiveRecord::Base
  end
  
  def setup
    Item.delete_all
  end
  
  test "the schema has loaded" do
    assert_equal [], Item.all
  end
end
