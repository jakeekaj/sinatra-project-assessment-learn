class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
    end

    create_table :movies do |t|
      t.string :title
      t.integer :year
      t.integer :user_id
    end

    create_table :shows do |t|
      t.string :title
      t.integer :year
      t.integer :user_id
    end

    create_table :actors do |t|
      t.string :name
      t.integer :user_id
    end

    create_table :genres do |t|
      t.string :name
      t.integer :user_id
    end

    create_table :actor_movies do |t|
      t.integer :actor_id
      t.integer :movie_id
    end

    create_table :actor_shows do |t|
      t.integer :actor_id
      t.integer :show_id
    end

    create_table :actor_genres do |t|
      t.integer :actor_id
      t.integer :genre_id
    end

    create_table :movie_genres do |t|
      t.integer :movie_id
      t.integer :genre_id
    end

    create_table :show_genres do |t|
      t.integer :show_id
      t.integer :genre_id
    end
  end
end
