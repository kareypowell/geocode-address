class AddressGeocoder

  @queue = :addresses_queue

  def self.perform(chunk)
    Member.create! chunk
  end

end