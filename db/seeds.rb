debug = ENV['debug']
users_max = 10
tag_max = 20
skills_max = 5
customers_every = 5

# --- RANDOM (UNIQUE) --- #

def random_fullname
  Faker::Name.first_name + " " + Faker::Name.last_name
end

def random_bio
  Faker::Lorem.sentences(5).join(' ')
end

def random_unique_skill
  cnt = 5
  found = false
  name = 'unknown'
  while cnt > 0 and not found
    name = Faker::Hipster.word.downcase
    unless Skill.find_by(name: name)
      found = true
    end
    cnt = cnt - 1
  end

  if cnt == 0
    puts "random_unique_skill failed!"
    exit
  end

  name
end

def random_unique_username
  cnt = 5
  found = false
  username = 'unknown'
  while cnt > 0 and not found
    username = Faker::Hipster.word.downcase
    unless User.find_by(username: username)
      found = true
    end
    cnt = cnt - 1
  end

  if cnt == 0
    puts "random_unique_username failed!"
    exit
  end

  username
end

def random_unique_email
  cnt = 5
  found = false
  email = 'unknown@example.com'
  while cnt > 0 and not found
    email = Faker::Internet.email.downcase
    unless User.find_by(email: email)
      found = true
    end
    cnt = cnt - 1
  end

  if cnt == 0
    puts "random_unique_email failed!"
    exit
  end

  email
end

def random_unique_tag
  cnt = 5
  found = false
  name = 'unknown'
  while cnt > 0 and not found
    name = Faker::Hipster.word.downcase
    unless Tag.find_by(name: name)
      found = true
    end
    cnt = cnt - 1
  end

  if cnt == 0
    puts "random_unique_tag failed!"
    exit
  end

  name
end

def random_profile
  root = Profile.create!(name: "root", this_id: 0)
  categories_sample = Category.all().sample(3 + rand(3))
  categories_sample.each do |category|
    c = Profile.create!(name: "category", this_id: category.id)
    skills = category.skills
    skills_sample = skills.sample(3 + rand(skills.count-3))
    skills_sample.each do |skill|
      s = Profile.create!(name: "skill", this_id: skill.id)
      tags = skill.tags
      tags_sample = tags.sample(3 + rand(tags.count-3))
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


# --- CATEGORIES --- #

puts "Category.delete_all"
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
  puts "Category.create!(#{category[:name]})"
  Category.create!(category)
end

puts "Categories: #{Category.count}"


# --- TAGS --- #

puts "Tag.delete_all"
Tag.delete_all

tags = []
tag_max.times do |n|
  tag = random_unique_tag
  puts "#{n+1}/#{tag_max} Tag = #{tag}"
  tags << tag
end


# --- ADMIN USER --- #

puts "User.delete_all"
User.delete_all

# Need an admin
puts "User.create!(admin)"
admin = User.create!({
  fullname: random_fullname,
  username: "admin",
  email: "admin@skillzz.com",
  password: "password",
  admin: true,
  bio: "Manage all of the computer systems at the company as well as everything having to do with the network infrastructure. Monitoring, trouble-shooting and overall customer technical support",
  profile: Profile.create!(name: "root", this_id: 0)
})


# --- SKILLS --- #

puts "Skill.delete_all"
Skill.delete_all

category_max = Category.count
category_cnt = 0
Category.all.each do |category|
  cnt = 1 + rand(skills_max)
  cnt.times do |n|
    name = random_unique_skill
    tag_names = tags.sample(rand(5)+1).join(' ')
    puts "#{category_cnt+1}/#{category_max} #{category.name} #{n+1}/#{cnt} Skill.create(category=#{category.name},name=#{name},tag_name=#{tag_names})"
    Skill.create(category: category, author: admin, name: Faker::Hipster.word.downcase, description: Faker::Hipster.sentence, tag_names: tag_names)
  end
  category_cnt = category_cnt + 1
end

puts "Skills: #{Skill.count}"
puts "Tags: #{Tag.count}"


# --- USERS --- #

if debug
  puts "---debug---"
  root = random_profile
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
  puts "---debug---"
end

puts "Profile.delete_all"
Profile.delete_all

[
    {
        fullname: random_fullname,
        username: "viewer",
        email: "viewer@skillzz.com",
        password: "password",
        bio: random_bio,
        profile: Profile.create!(name: "root", this_id: 0)
    },
    {
        fullname: random_fullname,
        username: "manager",
        email: "manager@skillzz.com",
        password: "password",
        bio: random_bio,
        profile: Profile.create!(name: "root", this_id: 0)
    },
    {
        fullname: random_fullname,
        username: "customer",
        email: "customer@skillzz.com",
        password: "password",
        customer: true,
        bio: "As one of the most demanding customers on this planet, I expect nothing less than the very best possible service there is. I am starting to get impatient because I am in immediate need of a skilled professional. For one of my prestigious project I need someone with the right knowledge and at least five years of experience in the role as a senior architect.",
        profile: random_profile
    },
    {
        fullname: random_fullname,
        username: "worker",
        email: "worker@skillzz.com",
        password: "password",
        worker: true,
        bio: "With more than ten years experience as a software developer, I view myself as a hard working and determined expert in my field. I prefer the more complex and challenging projects. Young and heart and eager to learn more. Skills include C/C++, Perl, Ruby, Ruby on Rails, Elixir, JavaScript, HTML5, CSS3, Bootstrap, Linux, Apache and MySQL.",
        profile: random_profile
    }
].each do |user|
  puts "User.create!(username=#{user[:username]},fullname=#{user[:fullname]})"
  User.create!(user)
end

users_max.times do |n|
  fullname = random_fullname
  username = random_unique_username
  email = random_unique_email
  profile = random_profile
  bio = random_bio
  if n.modulo(customers_every) == 0
    puts "#{n+1}/#{users_max} User.create!(customer,username=#{username},fullname=#{fullname})"
    User.create!(fullname: fullname, username: username, email: email, password: "password", customer: true, bio: bio, profile: profile)
  else
    puts "#{n+1}/#{users_max} User.create!(worker,username=#{username},fullname=#{fullname})"
    User.create!(fullname: fullname, username: username, email: email, password: "password", worker: true, bio: bio, profile: profile)
  end
end

puts "Users: #{User.count}"
