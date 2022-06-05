# frozen_string_literal: true

class CreateAuditLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :audit_logs do |t|
      t.string 'record_type'
      t.string 'record_id'
      t.integer 'user_id'
      t.string 'action'
      t.string 'resource_url'
      t.datetime 'timestamp'
      t.jsonb 'metadata'
    end
    add_index :audit_logs, :user_id
    add_index :audit_logs, %i[record_type record_id]
    add_index :audit_logs, :metadata, using: :gin
  end
end
