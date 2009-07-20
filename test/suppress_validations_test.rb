require 'test_helper'

class SuppressValidationsTest < ActiveSupport::TestCase
  include SuppressValidations
  load_schema

  class SuppressValidationsModel < ActiveRecord::Base
    validates_presence_of :title, :desc
  end

  setup do
    SuppressValidationsModel.delete_all
  end

  test "load schema" do
    assert_equal [], SuppressValidationsModel.all
  end

  test "should be able to create a new record" do
    suppressed_validations_model = SuppressValidationsModel.new
    suppressed_validations_model.title = "Test"
    suppressed_validations_model.desc  = "Desc"
    suppressed_validations_model.save

    assert_equal 1, SuppressValidationsModel.count
  end

  test "title should be required" do
    suppressed_validations_model = SuppressValidationsModel.new
    suppressed_validations_model.save

    assert !suppressed_validations_model.errors[:title].nil?
  end

  test "desc should be required" do
    suppressed_validations_model = SuppressValidationsModel.new
    suppressed_validations_model.save

    assert !suppressed_validations_model.errors[:desc].nil?
  end
  
  test "it should be able to disable validations" do
    ActiveRecord::Base.disable_validations!

    assert ActiveRecord::Base.validations_disabled?
  end
  
  test "it should be able to enable validations" do
    ActiveRecord::Base.enable_validations!

    assert !ActiveRecord::Base.validations_disabled?
  end

  test "suppress_validations should disable validations" do
    suppress_validations do
      suppressed_validations_model = SuppressValidationsModel.new
      suppressed_validations_model.save
    end

    assert_equal 1, SuppressValidationsModel.count
  end
end
