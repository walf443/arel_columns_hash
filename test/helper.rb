require "minitest/autorun"
require "arel"
require "arel_columns_hash"
require "fake_record"
require "active_record"

Arel::Table.engine = Arel::Sql::Engine.new(FakeRecord::Base.new)

class Object
  def must_be_like other
    gsub(/\s+/, ' ').strip.must_equal other.gsub(/\s+/, ' ').strip
  end
end
