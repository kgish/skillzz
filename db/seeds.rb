# Create admin unless it already exists.
unless User.exists?(email: "admin1@skillzz.com")
  User.create!(email: "admin1@skillzz.com", password: "admin12345", admin: true)
end

# Create user unless it already exists.
unless User.exists?(email: "user1@skillzz.com")
  User.create!(email: "user1@skillzz.com", password: "user12345")
end

# Populate the category table with items.
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
    Category.create!(name: category[:name], description: category[:description])
  end
end

puts "Users: #{User.count}"
puts "Categories: #{Category.count}"