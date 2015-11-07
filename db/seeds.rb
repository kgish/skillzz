
# --- USERS --- #

User.delete_all

[
  {
    username: "admin",
    email: "admin@skillzz.com",
    password: "password",
    admin: true
  },
  {
    username: "viewer",
    email: "viewer@skillzz.com",
    password: "password",
  },
  {
    username: "manager",
    email: "manager@skillzz.com",
    password: "password",
  },
  {
    username: "customer",
    email: "customer@skillzz.com",
    password: "password",
    customer: true
  },
  {
    username: "worker",
    email: "worker@skillzz.com",
    password: "password",
    worker: true
  }
].each do |user|
  User.create!(user)
end


95.times do |n|
  if n.modulo(10) == 0
    User.create!(username: Faker::Internet.user_name, email: Faker::Internet.email, password: "password", worker: true)
  else
    User.create!(username: Faker::Internet.user_name, email: Faker::Internet.email, password: "password", customer: true)
  end
end

puts "Users: #{User.count}"


# --- CATEGORIES --- #

Category.delete_all

[
  {
    name: "Programming",
    description: "Wonderful world of software development"
  },
  {
    name: "Testing",
    description: "Quality verification of user requirements"
  },
  {
    name: "Infrastructure",
    description: "Upkeep, configuration, and reliable operation of computer systems"
  },
  {
    name: "Tooling",
    description: "Utilities to create, debug, maintain, or otherwise support other programs and applications"
  },
  {
      name: "Design",
      description: "Sequence of steps that describing all aspects of the software to be built."
  },
  {
      name: "User Experience",
      description: "Usability, accessibility, and pleasure provided in the interaction between user and product."
  },
  {
      name: "Methodologies",
      description: "Conceptual frameworks or models for defining and prototyping products"
  },
  {
    name: "Requirements",
    description: "Tasks to determine crtieria to meet for a new or altered product or project"
  }
].each do |category|
  Category.create!(category)
end

puts "Categories: #{Category.count}"


# --- SKILLS --- #

Skill.delete_all
Tag.delete_all

admin = User.find_by!(email: 'admin@skillzz.com')
tags = []
20.times do
  tags << Faker::Hipster.word
end

Category.all.each do |category|
  10.times do
    Skill.create(category: category, author: admin, name: Faker::Hipster.word, description: Faker::Hipster.sentence,
      tag_names: tags.sample(rand(5)+1).join(' '))
  end
end

puts "Skills: #{Skill.count}"

# --- TAGS --- #

puts "Tags: #{Tag.count}"
