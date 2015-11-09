
# --- GENERATE RANDOM PROFILE --- #

def generate_random_profile
  root = Profile.create!(name: "root", this_id: 0)
  categories_sample = Category.all().sample(1 + rand(Category.count))
  categories_sample.each do |category|
    c = Profile.create!(name: "category", this_id: category.id)
    skills = category.skills
    skills_sample = skills.sample(1 + rand(skills.count))
    skills_sample.each do |skill|
      s = Profile.create!(name: "skill", this_id: skill.id)
      tags = skill.tags
      tags_sample = tags.sample(1 + rand(tags.count))
      tags_sample.each do |tag|
        t = Profile.create!(name: "tag", this_id: tag.id)
        t.move_to_child_of(s)
        s.reload
      end
      s.move_to_child_of(c)
      c.reload
    end
    c.move_to_child_of(root)
    root.reload
  end
  root
end

root = generate_random_profile
root.descendants.each do |child|
  case (child.name)
  when "category"
    puts "Category - '#{Category.find(child.this_id).name}'"
  when "skill"
    puts "  Skill - '#{Skill.find(child.this_id).name}'"
  when "tag"
    puts "    Tag - '#{Tag.find(child.this_id).name}'"
  else
     puts "Unknown name '#{child.name}'"
  end
end
exit

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


# --- USERS --- #

User.delete_all
Profile.delete_all

[
    {
        fullname: Faker::Name.first_name + " " + Faker::Name.last_name,
        username: "admin",
        email: "admin@skillzz.com",
        password: "password",
        admin: true,
        profile: Profile.create!(name: "root", this_id: 0)
    },
    {
        fullname: Faker::Name.first_name + " " + Faker::Name.last_name,
        username: "viewer",
        email: "viewer@skillzz.com",
        password: "password",
        profile: Profile.create!(name: "root", this_id: 0)
    },
    {
        fullname: Faker::Name.first_name + " " + Faker::Name.last_name,
        username: "manager",
        email: "manager@skillzz.com",
        password: "password",
        profile: Profile.create!(name: "root", this_id: 0)
    },
    {
        fullname: Faker::Name.first_name + " " + Faker::Name.last_name,
        username: "customer",
        email: "customer@skillzz.com",
        password: "password",
        customer: true,
        profile: Profile.create!(name: "root", this_id: 0)
    },
    {
        fullname: Faker::Name.first_name + " " + Faker::Name.last_name,
        username: "worker",
        email: "worker@skillzz.com",
        password: "password",
        worker: true,
        profile: generate_random_profile
    }
].each do |user|
  User.create!(user)
end

admin = User.find_by!(username: 'admin')
worker = User.find_by!(username: 'worker')
customer = User.find_by!(username: 'customer')

5.times do |n|
  fullname = Faker::Name.first_name + " " + Faker::Name.last_name
  username = Faker::Internet.user_name
  email = Faker::Internet.email
  profile = Profile.create!(name: "root", this_id: 0)
  if n.modulo(2) == 0
    User.create!(fullname: fullname, username: username, email: email, password: "password", worker: true, profile: profile)
  else
    User.create!(fullname: fullname, username: username, email: email, password: "password", customer: true, profile: profile)
  end
end

puts "Users: #{User.count}"

