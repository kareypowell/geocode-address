class Member < ActiveRecord::Base
  # geocoded_by :full_address
  # after_validation :geocode, if: :address_changed?

  before_save do |member|
    member.first_name = member.first_name.titlecase if member.first_name
    member.middle_name = member.middle_name.upcase if member.middle_name
    member.last_name = member.last_name.titlecase if member.last_name
    member.suffix.upcase! if member.suffix
    member.occupation = member.occupation.titlecase if member.occupation
    member.address = member.address.titlecase if member.address
    member.address_2 = member.address_2.titlecase if member.address_2
    member.city = member.city.titlecase if member.city
    member.state.upcase! if member.state
    member.country = member.country.titlecase if member.country
    member.email.downcase! if member.email
    member.employer.upcase! if member.employer
    member.activity_code.upcase! if member.activity_code
  end

  #
  def full_address
    [address, address_2, city, state, country].compact.join(", ")
  end

  #
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |member|
        csv << member.attributes.values_at(*column_names)
      end
    end
  end

  #
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      # Not final. Put additonal code to save record here...
      Member.create! row.to_hash
    end
  end

  #
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
