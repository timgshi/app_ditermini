namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_photos
    make_relationships
    make_notifications
  end
end

def make_users
  admin = User.create!(name:     "Admin",
                       email:    "admin@admin.com",
                       password: "password",
                       phone_number: 5104109550,
                       password_confirmation: "password")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    phonenum = Faker::PhoneNumber.phone_number
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 phone_number: phonenum,
                 password_confirmation: password)
  end
end

def make_photos
  #users = User.all(limit: 6)
    #5.times do
     # content = Faker::Lorem.sentence(5)
     # users.each { |user| user.microposts.create!(content: content) }
    #end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

def make_notifications
  users = User.all
  user = users.first
  notified_users = users[2..50]
  notifiers = users[3..40]
  msg = "did something super duper important"
  notified_users.each { |notified| user.notify!(notified, msg)}
  notifiers.each { |notifier| notifier.notify!(user, msg)}
end