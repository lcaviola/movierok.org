class CreateRipVersions < ActiveRecord::Migration
  def self.up
    Rip.create_versioned_table
    add_column :rip_versions, :part_ids, :string
    add_column :rip_versions, :language_ids, :string
    add_column :rip_versions, :subtitle_ids, :string
  end

  def self.down
    Rip.create_versioned_table
  end
end
