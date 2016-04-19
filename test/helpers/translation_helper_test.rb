require 'test_helper'
require 'translations_helper'

class ApplicationHelperTest < ActionView::TestCase
  include TranslationsHelper
 
  test "should return new translations" do
    
    new_trans = new_translations
    
    assert_equal new_trans, {"pt-br" => {"new-key" => "foo"}}
  end
  
end