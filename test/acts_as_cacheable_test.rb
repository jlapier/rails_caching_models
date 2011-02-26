require 'test_helper'

class Item < ActiveRecord::Base
  acts_as_cacheable
end
 
class ActsAsCacheableTest < ActiveSupport::TestCase
  load_schema
  
  def setup
    Item.delete_all
    Rails.cache.clear
    @item_a = Item.create! :name => "A"
    @item_b = Item.create! :name => "B"
    @item_c = Item.create! :name => "C"
  end
 
  test "item should cache single object" do
    id = @item_a.id
    assert_equal Item.get(id), @item_a
    assert_not_nil Rails.cache.read("Item_#{id}")
    assert_equal Item.get(id), @item_a
  end
  
  test "item update cache on a single object" do
    id = @item_b.id
    @item_b.name = "BB"
    @item_b.save
    assert_equal "BB", Item.get(id).name 
    assert_not_nil Rails.cache.read("Item_#{id}")
  end
  
  test "items should cache all ids" do
    assert_equal Item.get_all, Item.all
    assert_not_nil Rails.cache.read("Item_#{@item_a.id}")
    assert_equal Item.get_all, [@item_a, @item_b, @item_c]    
  end
  
  test "should delete all ids if new item created" do
    assert_equal Item.get_all, Item.all
    Item.create! :name => "D"
    assert_equal Item.get_all, Item.all
  end
  
  test "should delete all ids if item deleted" do
    assert_equal Item.get_all, Item.all
    @item_c.destroy
    assert_equal Item.get_all, Item.all
  end
 
end

