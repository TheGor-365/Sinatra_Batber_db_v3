require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('SELECT * FROM Barbers where name = ?', [name]).length > 0
end

def seed_db db, barbers

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'INSERT INTO Barbers (name)
			VALUES (?)', [barber]
		end
	end

end

def get_db
	db = SQLite3::Database.new 'sinatra_barber_shop.sqlite'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute 'SELECT * FROM Barbers'
end

configure do
	db = get_db
	db.execute CREATE TABLE IF NOT EXISTS "Users" (
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
	 	"username" TEXT,
	 	"phone" TEXT,
	 	"datestamp" TEXT,
	 	"barber" TEXT,
	 	"color" TEXT
	);

	db.execute CREATE TABLE IF NOT EXISTS "Barbers" (
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"name" TEXT
	);

	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'John Smith']
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do

	erb :about
end

get '/visit' do

	erb :visit
end

get '/contacts' do

	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@barber = params[:barber]
	@color = params[:color]

	hh = {
		:username => 'Input name',
		:phone => 'Input phone',
		:date_time => 'Input date and time'
	}

	hh.each do |key, value|

		if params[key] == ''
			@error = hh[key]

			return erb :visit
		end

	end

	db = get_db
	db.execute 'INSERT INTO Users (username, phone, datestamp, barber, color)
	VALUES (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

	erb :visit
end

get '/showusers' do
	db = git_db

	@results = db.execute 'SELECT * FROM Users
	ORDER BY id DESC'

	erb :showusers
end
