class AddApiCountToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :api_count, :integer, :default => 0
  end
end
