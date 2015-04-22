require "active_support"
require "arel_columns_hash/version"

ActiveSupport.on_load :active_record do
  require "arel_columns_hash/to_sql"
end

