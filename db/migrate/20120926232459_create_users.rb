class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.integer :bitbucket_id

      t.timestamps
    end
  end
end
