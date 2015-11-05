
# --- USERS --- #

users = [
  {
    email: "admin@skillzz.com",
    password: "admin123",
    admin: true
  },
  {
    email: "customer1@skillzz.com",
    password: "customer123",
    admin: false
  },
  {
    email: "customer2@skillzz.com",
    password: "customer456",
    admin: false
  },
  {
    email: "worker1@skillzz.com",
    password: "worker123",
    admin: false
  },
  {
    email: "worker2@skillzz.com",
    password: "worker456",
    admin: false
  }
]

users.each do |user|
  # Create user unless it already exists.
  unless User.exists?(email: user[:email])
    User.create!(user)
  end
end

puts "Users: #{User.count}"


# --- CATEGORIES --- #

categories = [
  {
    name: "Software Programming",
    description: "Wonderful world of software development"
  },
  {
    name: "Functional and Technical Testing",
    description: "Quality verification of user requirements"
  },
  {
    name: "System Administration",
    description: "Upkeep, configuration, and reliable operation of computer systems"
  },
  {
    name: "Tooling and Monitoring",
    description: "Utilities to create, debug, maintain, or otherwise support other programs and applications"
  },
  {
      name: "Design and User Experience",
      description: "Usability, accessibility, and pleasure provided in the interaction between user and product."
  },
  {
      name: "Software Product Methodologies",
      description: "Conceptual frameworks or models for defining and prototyping products"
  },
  {
    name: "Requirements Analysis",
    description: "Tasks to determine crtieria to meet for a new or altered product or project"
  }
]

categories.each do |category|
  unless Category.exists?(name: category[:name])
    Category.create!(category)
  end
end

puts "Categories: #{Category.count}"