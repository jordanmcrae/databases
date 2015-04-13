require 'sinatra'
require 'faker'
# require 'pry'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact
  include DataMapper::Resource

property :id, Serial  # For primary keys you have to call it a Serial (Docs)
property :first_name, String
property :last_name, String     # Don't need attr_accessor or initialize method now because of these
property :email, String
property :note, String
end

DataMapper.finalize # This says that I am done declaring the data objects
DataMapper.auto_upgrade! # This automatically updates the structure of the database

get '/' do
  @crm_app_name = "My CRM"
  @time = Time.new.strftime('%H:%M:%S')
  erb :index
end

get '/contacts' do
  @contacts = Contact.all

  erb :contacts
end

post '/contacts' do
end

get '/contacts/new' do
  erb :addcontact
end

post '/contacts' do
  new_contact = Contact.create(
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
    note: params[:note]
    )
  redirect("/contacts")
end

get '/contacts/:id' do
  @contact = Contact.get(params[:id])

  if @contact
    erb :showcontact
  else
    raise Sinatra::NotFound
  end
end

get '/contacts/:id/edit' do
  @contact = Contact.get(params[:id])

  if @contact
    erb :editcontact
  else
    raise Sinatra::NotFound
  end
end

put '/contacts/:id' do
  @contact = Contact.get(params[:id])


  if @contact
    @contact.first_name = params[:first_name]
    @contact.last_name = params[:last_name]
    @contact.email = params[:email]
    @contact.note = params[:note]

    @contact.save
    redirect("/contacts")
  else
    raise Sinatra::NotFound
  end
end

delete "/contacts/:id" do
  @contact = Contact.get(params[:id])
  if @contact
    @contact.destroy
    redirect("/")
  else
    raise Sinatra::NotFound
  end
end

