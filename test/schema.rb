ActiveRecord::Schema.define(:version => 0) do
  create_table :suppress_validations_models, :force => true do |t|
    t.string :title
    t.text   :desc
  end
end

