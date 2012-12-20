class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :subject, :null => false
      t.text :body, :null => false
      t.integer :total_sent, :default => 0, :null => false
      t.integer :total_recipients, :default => 0, :null => false
      t.string :roles, :null => false
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end