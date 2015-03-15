class Arel::Visitors::ToSql
  def column_for attr
    return unless attr
    name     = attr.name.to_s
    relation = attr.relation

    if has_columns_hash? relation
      relation.engine.columns_hash[name]
    elsif table_exists? relation.table_name
      column_cache(relation.table_name)[name]
    else
      nil
    end
  end

  def has_columns_hash?(relation)
    relation.respond_to?(:engine) && relation.engine.respond_to?(:columns_hash)
  end
end
