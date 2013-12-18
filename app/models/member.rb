class Member < ActiveRecord::Base
  geocoded_by :full_address, if: :longitude.nil? or :latitude.nil?
  after_validation :geocode, if: :address_changed?

  # before_save do |member|
  #   member.first_name.upcase! if member.first_name
  #   member.middle_name.upcase! if member.middle_name
  #   member.last_name.upcase! if member.last_name
  #   member.occupation = member.occupation.titlecase if member.occupation
  #   member.address = member.address.titlecase if member.address
  #   member.address_2 = member.address_2.titlecase if member.address_2
  #   member.city = member.city.titlecase if member.city
  #   member.state.upcase! if member.state
  #   member.country = member.country.titlecase if member.country
  #   member.email.downcase! if member.email
  #   member.employer.upcase! if member.employer
  #   member.activity_code.upcase! if member.activity_code
  # end

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
    # spreadsheet = open_spreadsheet(file)
    # header = spreadsheet.row(1)
    # (2..spreadsheet.last_row).each do |i|
    #   row = Hash[[header, spreadsheet.row(i)].transpose]
    #   member = find_by(id: row["id"]) || new
    #   member.attributes = row.to_hash.slice(:first_name, :middle_name, :last_name,
    #                                         :suffix, :occupation, :member_number,
    #                                         :address, :address_2, :city, :state,
    #                                         :zip, :country, :email, :phone,
    #                                         :phone_wk, :employer, :activity_code,
    #                                         :expiration_date, :longitude, :latitude)
    #   member.save!
    #   Member.create! row.to_hash
    # end
    row = SmarterCSV.process(file.path, { chunk_size: 100, key_mapping: { unwanted_row: nil, old_row_name: :new_row_name}}) do |chunk|
      # Member.create! chunk
      Resque.enqueue(AddressGeocoder, chunk)
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

  private

    # Converts a non-standard date to standard DB date, YYYY-MM-DD
    def convert_date
      new_date = Date.strptime(expiration_date, "%m/%d/%Y").strftime("%Y-%m-%d")
      new_date
    end

end
