# --- CATEGORIES --- #

category_ids = []

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
  category = Category.create!(category)
  category_ids << category.id
end

puts "Categories: #{Category.count}"


# --- USERS --- #

User.delete_all

[
  {
    fullname: Faker::Name.first_name + " " + Faker::Name.last_name,
    username: "admin",
    email: "admin@skillzz.com",
    password: "password",
    admin: true
  },
  {
    fullname: Faker::Name.first_name + " " + Faker::Name.last_name,
    username: "viewer",
    email: "viewer@skillzz.com",
    password: "password",
  },
  {
    fullname: Faker::Name.first_name + " " + Faker::Name.last_name,
    username: "manager",
    email: "manager@skillzz.com",
    password: "password",
  },
  {
    fullname: Faker::Name.first_name + " " + Faker::Name.last_name,
    username: "customer",
    email: "customer@skillzz.com",
    password: "password",
    customer: true
  },
  {
    fullname: Faker::Name.first_name + " " + Faker::Name.last_name,
    username: "worker",
    email: "worker@skillzz.com",
    password: "password",
    worker: true
  }
].each do |user|
  User.create!(user)
end

admin = User.find_by!(username: 'admin')
worker = User.find_by!(username: 'worker')
customer = User.find_by!(username: 'customer')

Category.all().each do |category|
  worker.categories << category
end

5.times do |n|
  fullname = Faker::Name.first_name + " " + Faker::Name.last_name
  username = Faker::Internet.user_name
  email = Faker::Internet.email
   if n.modulo(2) == 0
     User.create!(fullname: fullname, username: username, email: email, password: "password", worker: true)
   else
     User.create!(fullname: fullname, username: username, email: email, password: "password", customer: true)
   end
 end

puts "Users: #{User.count}"


# --- SKILLS --- #

Skill.delete_all
Tag.delete_all

tags = []
20.times do
  tags << Faker::Hipster.word.downcase
end

Category.all.each do |category|
  10.times do
    Skill.create(category: category, author: admin, name: Faker::Hipster.word.downcase, description: Faker::Hipster.sentence,
      tag_names: tags.sample(rand(5)+1).join(' '))
  end
end

puts "Skills: #{Skill.count}"

# --- TAGS --- #

puts "Tags: #{Tag.count}"
