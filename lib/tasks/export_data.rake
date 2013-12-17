namespace :openstates do

  desc "Import from web service to database"
  task :import => :environment do
    puts "Started to import legislators data..."
    members = Member.all
    members.each do |member|
      legislators = OpenStates::Legislator.by_location(member.latitude, member.longitude)
      member.senate_district_no = legislators.to_a[0].district if not legislators.nil? and not legislators.to_a[0].district.nil?
      member.senate_name = legislators.to_a[0].full_name if not legislators.nil? and not legislators.to_a[0].full_name.nil?
      member.senate_phone = legislators.to_a[0].offices.to_a[0].phone if not legislators.nil? and not legislators.to_a[0].offices.to_a[0].phone.nil?
      member.rep_district_no = legislators.to_a[1].district if not legislators.to_a[1].nil? and not legislators.to_a[1].district.nil?
      member.rep_name = legislators.to_a[1].full_name if not legislators.to_a[1].nil? and not legislators.to_a[1].full_name.nil?
      member.rep_phone = legislators.to_a[1].offices.to_a[0].phone if not legislators.to_a[1].nil? and not legislators.to_a[1].offices.to_a[0].phone.nil?
      member.save!
    end
    puts "Finished appending legislators data."
  end

  desc "Add data for legislators from web service"
  task :add => :environment do
    puts "Adding missing data for legislators..."
    members = Member.where("members.senate_name IS NULL AND members.longitude IS NOT NULL AND members.latitude IS NOT NULL")
    members.each do |member|
      legislators = OpenStates::Legislator.by_location(member.latitude, member.longitude)
      member.senate_district_no = legislators[0].district if not legislators[0].nil?
      member.senate_name = legislators[0].full_name if not legislators[0].nil? and not legislators[0].full_name.nil?
      # member.senate_phone = legislators[0].offices[0].phone if not legislators[0].nil?
      member.rep_district_no = legislators.to_a[1].district if not legislators.to_a[1].nil? and not legislators.to_a[1].district.nil?
      member.rep_name = legislators.to_a[1].full_name if not legislators.to_a[1].nil? and not legislators.to_a[1].full_name.nil?
      # member.rep_phone = legislators.to_a[1].offices.to_a[0].phone if not legislators.to_a[1].nil? and not legislators.to_a[1].offices.to_a[0].phone.nil?
      member.save!
    end
    puts "Finished updating legislators data."
  end

  desc "Add senators contact information from web service"
  task :senators_contact => :environment do
    puts "Appending senators contact info..."
    members = Member.where("members.senate_phone IS NULL AND members.longitude IS NOT NULL AND members.latitude IS NOT NULL")
    members.each do |member|
      if not member.longitude.nil? and not member.latitude.nil?
        legislators = OpenStates::Legislator.by_location(member.latitude, member.longitude)
        if not legislators.empty?
          if not legislators[0].offices.empty?
            member.senate_phone = legislators[0].offices[0].phone
            member.save!
          end
        end
      end
    end
    puts "Finished updating contact information for legislators."
  end

  desc "Add representatives contact information from web service"
  task :reps_contact => :environment do
    puts "Appending reps. contact info..."
    members = Member.where("members.rep_phone IS NULL AND members.longitude IS NOT NULL AND members.latitude IS NOT NULL")
    members.each do |member|
      if not member.longitude.nil? and not member.latitude.nil?
        legislators = OpenStates::Legislator.by_location(member.latitude, member.longitude)
        # raise legislators.to_a[1].offices.inspect
        if not legislators.to_a[1].nil? and not legislators.to_a[1].offices.empty?
          member.rep_phone = legislators.to_a[1].offices[0].phone
          member.save!
        end
      end
    end
    puts "Finished updating contact information for legislators."
  end

end