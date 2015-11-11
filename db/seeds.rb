debug = ENV['debug']
users_max = 10
tag_max = 20
customers_every = 5

# --- RANDOM (UNIQUE) --- #

def random_fullname
  Faker::Name.first_name + " " + Faker::Name.last_name
end

def random_bio
  Faker::Lorem.sentences(5).join(' ')
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
    puts "random_unique_username() failed!"
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
    puts "random_unique_email() failed!"
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
    puts "random_unique_tag() failed!"
    exit
  end

  name
end

def random_profile(role)
  puts "random_profile(#{role}) => start"
  root = Profile.create!(name: "root", this_id: 0)
  if role == 'worker' or role == 'customer'
    # Must include 'Programming' as the first skill for demo
    # Get 2 additional random categories for a total of 3
    programming = Category.find_by!(name: 'Programming')
    categories = Category.where.not(name: 'Programming')
    categories_sample = categories.sample(2)
    categories_sample.unshift(programming)
  else
    # Get 2-4 random categories
    categories_sample = Category.all().sample(2 + rand(3))
  end
  #puts "random_profile(#{role}) categories_sample=#{categories_sample.inspect}"
  categories_sample.each do |category|
    c = Profile.create!(name: "category", this_id: category.id)
    skills = category.skills
    #puts "random_profile(#{role}) category=#{category.name}, skills=#{skills.inspect}"
    if role == 'worker' or role == 'customer'
      # Get 4 random skills
      skills_sample = skills.sample(4)
    else
      # Get 2-4 random skills
      skills_sample = skills.sample(2 + rand(3))
    end
    skills_sample.each do |skill|
      s = Profile.create!(name: "skill", this_id: skill.id)
      tags = skill.tags
      # Get 2-3 random tags
      tags_sample = tags.sample(2 + rand(2))
      tags_sample.each do |tag|
        t = Profile.create!(name: "tag", this_id: tag.id)
        t.move_to_child_of(s)
        #s.reload
      end
      s.move_to_child_of(c)
      #c.reload
    end
    c.move_to_child_of(root)
    root.reload
  end
  puts "random_profile(#{role}) => done"
  root
end


# --- CATEGORIES --- #

puts "Category.delete_all => skipped!"
#Category.delete_all

category_list = [
    {
        name: "Programming",
        description: "Wonderful world of software development",
        skills: %w{ angular.js apache backbone.js c/c++ clojure cordova css elixir ember.js erlang ext.js extjs html java javascript jquery linux lua meteor.js mongodb mysql perl postgres python ruby ruby-on-rails xml }
    },
    {
        name: "Testing",
        description: "Quality verification of user requirements",
        skills: %w{ functional non-functional tmap cucumber rspec selenium junit soapui winrunner linux }
    },
    {
        name: "Infrastructure",
        description: "Upkeep, configuration, and reliable operation of computer systems",
        skills: %w{ linux bash puppet chef docker centos itil otrs jira topdesk nagios splunk ldap ssh postfix dovecot }
    },
    {
        name: "Tooling",
        description: "Utilities to create, debug, maintain, or otherwise support other programs and applications",
        skills: %w{ jira git jmeter subversion travis bamboo hudson greenhopper jenkins trac vim wireshark }
    },
    {
        name: "Design",
        description: "Usability, accessibility, and pleasure provided in the interaction between user and product.",
        skills: %w{ uml gui mobile responsive css branding wire-framing prototyping axure sketch invision mockups photoshop gimp }
    },
    {
        name: "Methodologies",
        description: "Conceptual frameworks or models for defining and prototyping products",
        skills: %w{ lean bdd tdd domain-driven scrum agile waterfall xp design-patterns rup continuous-delivery kanban rad }
    },
    {
        name: "Requirements",
        description: "Tasks to determine crtieria to meet for a new or altered product or project",
        skills: %w{ jira scrum agile rally ibm-rational change-management case caliber enterprise-architect }
    }
]

category_list.each do |category|
  puts "Category.create!(#{category[:name]})"
  Category.create!(name: category[:name], description: category[:description])
end

puts "Categories: #{Category.count}"


# --- TAGS --- #

puts "Tag.delete_all"
Tag.delete_all

tags = []
tag_max.times do |n|
  tag = random_unique_tag
  tags << tag
end

puts "Tags=[#{tags.join(' ')}]"


# --- ADMIN USER --- #

puts "User.delete_all => skipped!"
#User.delete_all

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

puts "Skill.delete_all => skipped!"
#Skill.delete_all

category_max = Category.count
category_cnt = 0
Category.all.each do |category|
  category_item = category_list.select { |c| c[:name] == category.name }
  skill_names = category_item.first[:skills]
  skill_max = skill_names.count
  cnt = 0
  skill_names.each do |skill_name|
    tag_names = tags.sample(1 + rand(5)).join(' ')
    puts "#{category_cnt+1}/#{category_max} #{category.name} #{cnt+1}/#{skill_max} Skill.create(category=#{category.name},name=#{skill_name},tag_names='#{tag_names}')"
    Skill.create(category: category, author: admin, name: skill_name, description: Faker::Hipster.sentence, tag_names: tag_names)
    cnt = cnt + 1
  end
  category_cnt = category_cnt + 1
end

puts "Skills: #{Skill.count}"
puts "Tags: #{Tag.count}"


# --- USERS --- #

if debug
  puts "---debug---"
  root = random_profile('dummy')
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

puts "Profile.delete_all => skipped!"
#Profile.delete_all

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
        profile: random_profile('customer')
    },
    {
        fullname: random_fullname,
        username: "worker",
        email: "worker@skillzz.com",
        password: "password",
        worker: true,
        bio: "With more than ten years experience as a software developer, I view myself as a hard working and determined expert in my field. I prefer the more complex and challenging projects. Young and heart and eager to learn more. Skills include C/C++, Perl, Ruby, Ruby on Rails, Elixir, JavaScript, HTML5, CSS3, Bootstrap, Linux, Apache and MySQL.",
        profile: random_profile('worker')
    }
].each do |user|
  puts "User.create!(username=#{user[:username]},fullname=#{user[:fullname]})"
  User.create!(user)
end

users_max.times do |n|
  fullname = random_fullname
  username = random_unique_username
  email = random_unique_email
  profile = random_profile('dummy')
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
