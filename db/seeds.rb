# --- OPTS --- #

# Default values
debug = ENV.include?('debug') ? true : false
users_max = 50
tag_max = 12
customers_every = 10

# Validate users_max: must be a number and less than or equal to 1000
if ENV.include?('users_max')
  opt = ENV['users_max']
  if /\A\d+\z/.match(opt)
    users_max = opt.to_i
    if users_max > 1000
      puts "Invalid user_max = '#{opt}' (must be less than or equal to 1000)"
      exit
    end
  else
    puts "Invalid user_max = '#{opt}' (must be a number)"
    exit
  end
end

# Validate tag_max: must be a number and less than or equal to 50
if ENV.include?('tag_max')
  opt = ENV['tag_max']
  if /\A\d+\z/.match(opt)
    tag_max = opt.to_i
    if tag_max > 50
      puts "Invalid tag_max = '#{opt}' (must be less than or equal to 50)"
      exit
    end
  else
    puts "Invalid tag_max = '#{opt}' (must be a number)"
    exit
  end
end

# Validate customers_every: must be a number and less than user_max
if ENV.include?('customers_every')
  opt = ENV['customers_every']
  if /\A\d+\z/.match(opt)
    customers_every = opt.to_i
    if customers_every > 50
      puts "Invalid customers_every = '#{opt}' (must be less than users_max = #{users_max}"
      exit
    end
  else
    puts "Invalid customers_every = '#{opt}' (must be a number)"
    exit
  end
end

# Display all opts for good measure
puts "debug = #{debug}"
puts "users_max = #{users_max}"
puts "tag_max = #{tag_max}"
puts "customers_every = #{customers_every}"


# --- RANDOM (UNIQUE) --- #

def random_fullname
  Faker::Name.first_name + " " + Faker::Name.last_name
end

def random_bio
  Faker::Lorem.sentences(5).join(' ')
end

def random_unique_username
  cnt = 10
  found = false
  username = 'unknown'
  while cnt > 0 and not found
    username = Faker::Internet.user_name
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
  cnt = 10
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
  cnt = 10
  found = false
  name = 'unknown'
  while cnt > 0 and not found
    name = Faker::Hipster.word.downcase
    # Don't want digits or goofy characters.
    name.gsub!(/\d/, 'x')
    name.gsub!(/'/, 'z')
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

def random_unique_profile_id
  cnt = 10
  found = false
  id = -1
  while cnt > 0 and not found
    id = rand(10000)
    unless Profile.find_by(id: id)
      found = true
    end
    cnt = cnt - 1
  end

  if cnt == 0
    puts "random_unique_profile_id() failed!"
    exit
  end

  id
end

def random_profile(role)
  #puts "random_profile(#{role}) => start"
  root = Profile.create!(name: "root", this_id: random_unique_profile_id)
  demo = (role == 'worker-demo' or role == 'customer-demo')
  if demo
    # Must include 'Programming' as the first skill for demo. Get 3 additional
    # random categories for a total of 4 categories.
    programming = Category.find_by!(name: 'Programming')
    categories = Category.where.not(name: 'Programming')
    categories_sample = categories.sample(3)
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
    if demo
      # Get 4 random skills
      skills_sample = skills.sample(4)
    else
      # Get 2-4 random skills
      skills_sample = skills.sample(2 + rand(3))
    end
    skills_sample.each do |skill|
      s = Profile.create!(name: "skill", this_id: skill.id)
      tags = skill.tags
      if demo
        # Get 3 random tags
        tags_sample = tags.sample(3)
      else
        # Get 2-3 random tags
        tags_sample = tags.sample(2 + rand(2))
      end
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
  #puts "random_profile(#{role}) => done"
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
  if Category.find_by(name: category[:name])
    puts "category=#{category[:name]} already exists => skip"
  else
    Category.create!(name: category[:name], description: category[:description])
    puts "Category.create!(#{category[:name]})"
  end
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

puts "Tags: #{tags.count} => [#{tags.join(' ')}]"


# --- ADMIN --- #

puts "User.delete_all => skipped!"
#User.delete_all

if User.find_by(username: 'admin')
  puts "admin already exists => skip"
else
  puts "User.create!(admin)"
  User.create!(
    fullname: random_fullname,
    username: "admin",
    email: "admin@skillzz-search.com",
    password: "password",
    admin: true,
    bio: "Manage all of the computer systems at the company as well as everything having to do with the network infrastructure. This includes monitoring, trouble-shooting and overall customer technical support. Can also take apart computers blind-folded and pull cables from one end of the building to the other.",
    profile: nil
  )
end


# --- SKILLS --- #

puts "Skill.delete_all => skipped!"
#Skill.delete_all

category_max = Category.count
category_cnt = 0
admin = User.find_by!(username: 'admin')
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


# --- DEFAULT USERS --- #

puts "Profile.delete_all => skipped!"
#Profile.delete_all

[
    {
        fullname: random_fullname,
        username: "viewer",
        email: "viewer@skillzz-search.com",
        password: "password",
        bio: random_bio,
        profile: nil
    },
    {
        fullname: random_fullname,
        username: "manager",
        email: "manager@skillzz-search.com",
        password: "password",
        bio: random_bio,
        profile: nil
    },
    {
        fullname: random_fullname,
        username: "customer",
        email: "customer@skillzz-search.com",
        password: "password",
        customer: true,
        bio: "As one of the most demanding customers on this planet, I expect nothing less than the very best possible service there is. I am starting to get impatient because I am in immediate need of a skilled professional. For one of my prestigious projects I need someone with the right knowledge and at least five years of experience in the role as a senior architect. The candidate must be an expert but not cost too much.",
        profile: random_profile('customer-demo')
    },
    {
        fullname: random_fullname,
        username: "worker",
        email: "worker@skillzz-search.com",
        password: "password",
        worker: true,
        bio: "With more than ten years experience as a software developer, I view myself as a hard working and determined expert in my field. Prefer the more complex and challenging projects working in a small team. Young at heart and eager to learn more, roll up my sleeves and get the job done. Skills include C/C++, Perl, Ruby, Ruby on Rails, Elixir, JavaScript, HTML5, CSS3, Bootstrap, Linux, Apache and MySQL.",
        profile: random_profile('worker-demo')
    }
].each do |user|
  if User.find_by(username: user[:username])
    puts "username=#{user[:username]} already exists => skip"
  else
    puts "User.create!(username=#{user[:username]},fullname=#{user[:fullname]})"
    User.create!(user)
  end
end


# --- RANDOM USERS (users_max) --- #

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

puts "Total users:     #{User.count}"
puts "      admins:    #{User.where(admin: true).count}"
puts "      customers  #{User.where(customer: true).count}"
puts "      workers:   #{User.where(worker: true).count}"


# --- DEBUG --- #

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
