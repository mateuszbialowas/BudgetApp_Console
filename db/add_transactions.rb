require_relative '../config/environment'

ActiveRecord::Schema.define(version: 1) do

  create_table "transactions", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "category"
    t.integer  "value"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
