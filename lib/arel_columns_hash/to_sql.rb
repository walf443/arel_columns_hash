class Arel::Visitors::ToSql
  def column_for attr
    return unless attr
    name     = attr.name.to_s
    relation = attr.relation

    relation_engine = get_relation_engine_has_columns_hash(relation)

    if relation_engine
      relation_engine.columns_hash[name]
    elsif table_exists? relation.table_name
      column_cache(relation.table_name)[name]
    else
      nil
    end
  end

  def get_relation_engine_has_columns_hash(relation)
    return nil has_columns_hash?(relation)

    relation_engine = relation.engine

    if relation.engine == ActiveRecord::Base
      relation_engine = relation.table_name.classify.constantize rescue nil

      if relation_engine.is_a?(Class) && relation_engine < ActiveRecord::Base
        relation_engine
      else
        nil
      end
    else
      relation.engine
    end
  end

  def has_columns_hash?(relation)
    relation.respond_to?(:engine) && relation.engine.respond_to?(:columns_hash)
  end
end
