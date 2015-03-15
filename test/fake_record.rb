# https://github.com/rails/arel/blob/7b823819f7b1d71a23f884184df7c83a0d40de1b/test/support/fake_record.rb

# Copyright (c) 2007-2010 Nick Kallen, Bryan Helmkamp, Emilio Tagua, Aaron Patterson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module FakeRecord
  class Column < Struct.new(:name, :type)
  end

  class Connection
    attr_reader :tables
    attr_accessor :visitor

    def initialize(visitor = nil)
      @tables = %w{ users photos developers products}
      @columns = {
        'users' => [
          Column.new('id', :integer),
          Column.new('name', :string),
          Column.new('bool', :boolean),
          Column.new('created_at', :date)
        ],
        'products' => [
          Column.new('id', :integer),
          Column.new('price', :decimal)
        ]
      }
      @columns_hash = {
        'users' => Hash[@columns['users'].map { |x| [x.name, x] }],
        'products' => Hash[@columns['products'].map { |x| [x.name, x] }]
      }
      @primary_keys = {
        'users' => 'id',
        'products' => 'id'
      }
      @visitor = visitor
    end

    def columns_hash table_name
      @columns_hash[table_name]
    end

    def primary_key name
      @primary_keys[name.to_s]
    end

    def table_exists? name
      @tables.include? name.to_s
    end

    def columns name, message = nil
      @columns[name.to_s]
    end

    def quote_table_name name
      "\"#{name.to_s}\""
    end

    def quote_column_name name
      "\"#{name.to_s}\""
    end

    def schema_cache
      self
    end

    def quote thing, column = nil
      if column && column.type == :integer
        return 'NULL' if thing.nil?
        return thing.to_i
      end

      case thing
      when true
        "'t'"
      when false
        "'f'"
      when nil
        'NULL'
      when Numeric
        thing
      else
        "'#{thing}'"
      end
    end
  end

  class ConnectionPool
    class Spec < Struct.new(:config)
    end

    attr_reader :spec, :connection

    def initialize
      @spec = Spec.new(:adapter => 'america')
      @connection = Connection.new
      @connection.visitor = Arel::Visitors::ToSql.new(connection)
    end

    def with_connection
      yield connection
    end

    def table_exists? name
      connection.tables.include? name.to_s
    end

    def columns_hash
      connection.columns_hash
    end

    def schema_cache
      connection
    end
  end

  class Base
    attr_accessor :connection_pool

    def initialize
      @connection_pool = ConnectionPool.new
    end

    def connection
      connection_pool.connection
    end
  end
end
