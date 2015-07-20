module UUIDHelper
  def generate_uuid
    UUIDTools::UUID.random_create.to_s
  end

  def generate_uuids(count)
    count.times.collect { generate_uuid }
  end
end
