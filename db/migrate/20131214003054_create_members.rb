class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string  :first_name
      t.string  :middle_name
      t.string  :last_name
      t.string  :suffix
      t.string  :occupation
      t.integer :member_number
      t.string  :address
      t.string  :address_2
      t.string  :city
      t.string  :state
      t.string  :zip
      t.string  :country
      t.string  :email
      t.string  :phone
      t.string  :phone_wk
      t.string  :employer
      t.string  :activity_code
      t.date    :expiration_date
      t.float   :longitude
      t.float   :latitude
      # t.integer :senate_district_no
      # t.string  :senate_name
      # t.string  :senate_phone
      # t.integer :rep_district_no
      # t.string  :rep_name
      # t.string  :rep_phone

      t.timestamps
    end
  end
end
