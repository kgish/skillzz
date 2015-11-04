
# --- USERS --- #

users = [{
  email: "admin@skillzz.com",
  password: "admin123",
  admin: true
},{
  email: "customer1@skillzz.com",
  password: "customer123",
  admin: false
},{
  email: "customer2@skillzz.com",
  password: "customer456",
  admin: false
},{
  email: "worker1@skillzz.com",
  password: "worker123",
  admin: false
},{
  email: "worker2@skillzz.com",
  password: "worker456",
  admin: false
}]

users.each do |user|
  # Create user unless it already exists.
  unless User.exists?(email: user[:email])
    User.create!(user)
  end
end

puts "Users: #{User.count}"


# --- CATEGORIES --- #

categories = [{
  name: "Programming",
  description: "Wonderful world of software development"
},{
  name: "Testing",
  description: "Quality verification of user requirements"
},{
  name: "System Administration",
  description: "Upkeep, configuration, and reliable operation of computer systems"
}]

categories.each do |category|
  unless Category.exists?(name: category[:name])
    Category.create!(category)
  end
end

puts "Categories: #{Category.count}"