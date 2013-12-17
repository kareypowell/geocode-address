class AddLegislatorsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :senate_district_no, :integer
    add_column :members, :senate_name, :string
    add_column :members, :senate_phone, :string
    add_column :members, :rep_district_no, :integer
    add_column :members, :rep_name, :string
    add_column :members, :rep_phone, :string
  end
end
