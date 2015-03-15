require "helper"

module Arel
  module Visitors
    describe 'the to_sql visitor' do
      before do
        @visitor = ToSql.new Table.engine.connection
        @table = Table.new(:users)
        @attr = @table[:id]
      end

      it "uses columns_hash of engine" do
        table = Class.new(Table) {
          def engine
            Class.new {
              def columns_hash
                { 'active' => FakeRecord::Column.new('active', :integer) }
              end
            }.new
          end
        }.new(:users)

        node = Nodes::NotEqual.new(table[:active], "1")
        @visitor.accept(node).must_be_like %{
          "users"."active" != 1
        }
      end
    end
  end
end
