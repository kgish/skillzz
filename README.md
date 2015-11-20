# SkillZZ

This is an advanced website platform for matching highly skilled workers to customers who are searching for the best and most appropriate person for a given task at hand.

Selection criteria includes categories, skills, user-defined tags, user bio, hourly rates, availability which can be selected in order to filter through the results and select the most appropriate match.

An example of such a query might be: "I am looking for a senior Ruby developer with knowledge of Linux and MySQL who charges
between 70-85 euros per hour and who will be available starting next month for three months."

A customer can select a number of pre-defined labels (tags) to narrow down the search or introduce his own user-defined tags to be more specific.

A given query will (hopefully) generate a number of hits which are then ordered via a ranking scheme weighted according to criteria and preferences of the customer.

Special thanks go to the authors of the book [Rails 4 in Action](https://www.manning.com/books/rails-4-in-action) which provided me with invaluable guidance and insights, a really fantastic book.

Please note that I took the liberty of using some of their ideas and implementation details.


## Installation

In order to install and start using this application, do the following:

    $ git clone git@github.com:kgish/skillzz.git
    $ cd skillzz
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:seed
    $ bundle exec rails server

The application is now up-and-running and can be viewed by pointing your favorite browser at good ol' http://localhost:3000.

If you are cloning this repository for development purposes, it is recommended that you also do the following from
within the project root directory just after you run the `bundle install` command above:

    $ rvm use ruby-2.2.2@skillzz --create
    $ rvm --rvmrc ruby-2.2.2@skillzz
    $ rvm rvmrc trust `pwd`
    $ rvm rvmrc warning ignore  `pwd`/.rvmrc
    $ gem install bundler
    $ bundle update 


## Authentication

In order to be able to take advantages of the services provided by this website, a user first has to login using either his username or email and password.

The setup used is the one defined by the standard [Devise](https://github.com/plataformatec/devise) setup after running:

    $ rails generate devise:install
    $ rails generate devise user


## Users

During the installation the user table is populated with a number of pre-defined users, namely the following:

* admin (admin@skillzz.com) / password
* worker (worker@skillzz.com) / password
* customer (customer@skillzz.com) / password
* viewer (viewer@skillzz.com) / password
* manager (manager@skillzz.com) / password

You can login using either the user's email or username and the password is simply 'password'.

In order to facilitate a more usable demo, the worker and customer are pre-seeded with `programming skills` along with a number of other randomly selected categories and skills.

In addition to those pre-defined users, the database is seeded with a number of random users using the [Faker](https://github.com/stympy/faker) gem.

Of course, later on you can always create additional user via the Admin dashboard.


## Roles

There are four roles defined for the website:

* Visitor - Happens to find the website, gathers information and can sign up either as a worker or a customer.
* Worker - Is available for employment and whose profile is a collection of skills that can be searched.
* Customer - Looking for workers with a given number of skills and can search using combinations of categories, skills and tags.
* Administrator - Has complete access rights required for administrating the website, including role definitions.

Here are the rules for categories:

* Anyone can view the index action, but they will only see categories they are a member of.
* Only admins can see the new and create actions.
* Only members of a category can see the show action.
* Only admins or project managers can see the edit and update actions.
* Only admins can see the destroy action.

A user can update a skill if one of the following is true:

* The user is an admin.
* The user is a manager of the project.
* The user is an editor of the project, and the user is also the author of the skill.


## Tags

In order to be able to group similar skills together and improve overall searchability, a 'Tag' may be used. This is a single-word label attached to a given skill thus giving it extra granularity for searching.

A given skill can have one or more tags, and unique tags can be shared across different skills.

In this version, a tag can only consist of a single word, and a list of tags is a series of words separated by spaces.

As a workaround you can use dashes for multi-word labels, for example `continuous-integration` or `ruby-on-rails`.


## Profile

Each user has a profile which is a hierarchical tree-structure with the root being the user who has one or more categories, each category having one or more skills, and each skill with one or more tags.

![](images/profile-tree.png?raw=true)

This implementation of the nested set pattern was created using the [Awesome Nested Set](https://github.com/collectiveidea/awesome_nested_set) gem.

```ruby
class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.integer :this_id

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      
      t.integer :depth, default: 0
      t.integer :children_count, default: 0

    end
    add_index :profiles, [:parent_id, :lft, :rgt, :depth]
    add_reference :users, :profile, index: true, foreign_key: true
  end
end
```

The `name` is one of `%w{root category skill tag}` and `this_id` is the record `id` of the given table. Access the given object by doing the following:

```ruby
obj = Model.find(this_id)
```

So for instance, if we have `name == 'category'` and `this_id = 234` we can grab that record like this:

```ruby
category = Category.find(this_id)
```

Sure, I realize that I could have used the `depth` attribute for the same thing where values of `1, 2 or 3` correspond to `category, skill or tag`, but `name` strings are easier for me to read than raw digits.

In order to make the search more efficient, the profile is `flattened` by serializing it into a string which is saved in the `flattened_profile` attribute.

The `flattened_profile` attribute is built upon user creation and updated whenever the profile is changed, for example adding and or deleting elements (category, skill or tag).

This flattened representation is an array of arrays containing every possible route through the tree, each array item identified using the (unique) model id for that level.

```ruby
require 'json'

def flatten_profile(profile)
  graphs = []
  graphs_1 = []
  graphs_2 = []
  graphs_3 = []
  profile.children.each do |category|
    graphs_1.push([category.this_id])
    category.children.each do |skill|
      graphs_2.push([category.this_id, skill.this_id])
      skill.children.each do |tag|
        graphs_3.push([category.this_id, skill.this_id, tag.this_id])
      end
    end
  end
  graphs.push(graphs_1)
  graphs.push(graphs_2)
  graphs.push(graphs_3)
  graphs.to_json
end
```


## Search

A given customer has a profile which is used to compare with each worker when finding the best match based on a ranking scheme.

```ruby
workers = User.find_by(worker: true)
workers.each do |worker|
  rank = rank_match(customer, worker)
end
```

![](images/search-results.png?raw=true)

## Ranking

The ranking algorith is simple and pretty straight forward. Basically, the two profiles are compared by taking the lengths of the intersecting arrays and weighting them according to how far down the tree (more specific) the match is.

```ruby
def rank_match(customer, worker)
  categories = []
  skills = []
  tags = []
  0.upto 2 do |n|
    intersection = customer[n] & worker[n]
    if intersection.length
      intersection.each do |arr|
        case n
          when 0
            categories << Category.find(arr[0]).name
          when 1
            skills << Skill.find(arr[1]).name
          when 2
            tags << Tag.find(arr[2]).name
        end
      end
    end
  end
  # Weighted results, the further down the tree, the better.
  rank = categories.length + 2 * skills.length + 3 * tags.length
  return rank, categories, skills, tags
end
```


## Data Model

The database tables, data types and relationships together define the different ways that the application interacts with the underlying data model in order to adhere to the user requirements.

On the highest level we have 'Categories' with a name (unique) and a description.

Each category can consist of one or more 'Skills' with a name (unique) and a description.

Finally, each skill can be correlated to one or more user-defined 'Tags' for helping with the search.

Here is a diagram which shows the high-level schema structure:

![](images/database-diagram.png?raw=true)


## Database

I decided to use [MySQL](https://www.mysql.com/) for development and testing since the default [SQLite](https://www.sqlite.org/) that Rails uses is not robust enough for my large datasets. 

By using the [Awesome Nested Set](https://github.com/collectiveidea/awesome_nested_set) gem for hierarchical model (Profile-Categories-Skills-Tags), and extra level of complexity is introduced.

For production I use [PostgreSQL](http://www.postgresql.org/) since that is the default for Heroku.


## Seeding

If after the installation, you decide that you want to pre-populate the database with a bunch of fresh random data, then this is possible by running the following command:

    $ bundle exec rake db:seed

Any users, categories or skills that already exist in the database will remain. The tags are completely regenerated during each run.

You can also pass a number of options via the command line like this:

    $ bundle exec db:seed opt=value
    
Where `opt` can be one of the following:

* users_max=n (default 30)
* customers_every=n (default 10)
* tag_max=n (default 12)
* debug=[true|false] (default false)

So for example, in order to generate in total 100 random users a user with role 'customer' every ten times and 20 tags:

    $ bundle exec rake db:seed users_max=100 customers_every=20 tag_max=20


## Testing

The functionality of this application is verified by running [RSpec](http://rspec.info/) which tests the defined user requirements by using features and sub-scenarios.

In order to run all of the tests do this:

    $ bundle exec rspec
  
or in order to run just a specific test, for example editing categories:

    $ bundle exec rspec spec/features/editing_categories_spec.rb
    

## Deployment

A demo version of this application can be found on Heroku:

https://mysterious-cliffs-8546.herokuapp.com
    
In order to enable this, I changed my `Gemfile` to include these lines:

```ruby
group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'puma'
end
```

See [Deploying Rails Applications with the Puma Web Server](https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server).

In order to set up the deployment process, I went to the application root directory `/path/to/skillz` and did the following:
    
    $ heroku login
    $ heroku apps:create
    $ git push heroku master
    $ heroku run rake db:migrate
    $ heroku run rake db:seed
    
For each stable version which has been verified by `rspec` (all tests green), I run the following commands:
    
    $ (feature-branch) bundle exec rspec
    ...
    92 examples, 0 failures
    $ (feature-branch) git add .
    $ (feature-branch) git commit -m"Some informative message explaining things"
    $ (feature-branch) git push
    $ (feature-branch) git checkout master
    $ (master) git pull
    $ (master) git merge feature-branch
    $ (master) bundle exec rspec
    ...
    92 examples, 0 failures
    $ (master) git push
    $ (master) git push heroku master

Voilà, it should be up and running now.

## Todos

Since I am a hard-core developer at heart, I tend to be a bit of a perfectionist. Even if I had more time for improving this application, I could go on forever. There will always be more to do later and even more after that.

Here is a list of todo items for a rainy day.

* ~~Allow users to login using either their username or email.~~
* Allow user to sign up via the registration form.
* Allow users to include profile picture that can be uploaded.
* Take into account the availability of workers when matching.
* Take into account the hourly rate of workers when matching.
* Allow workers to create multiple profile and save them by title.
* Allow customers to create user-defined searches and save them.
* Policy scopes for workers and customers as well.
* Email notifications when there are new matches detected.
* Allow tags to consist of multiple words.
* Responsive design for mobiles
* Ad infinitum...


## References

Of course, I couldn't have done any of this without the following fantastic resources which have helped me out very much. The open source community is a fantastic place with lots of coding heroes who are great at helping each other.

* [Ruby on Rails](http://rubyonrails.org/) - The most amazing website on the face of the Earth which includes everything you'd ever want to know about this fantastic web framework.
* [Rails 4 in Action](https://www.manning.com/books/rails-4-in-action) - By a long shot the most extensive hands-on Rails guide available.
* [The Twelve-Factor App](http://12factor.net/) - A modern methodology for building [Software-as-a-Service](https://en.wikipedia.org/wiki/Software_as_a_service) applications.
* [Bootstrap](http://getbootstrap.com/) - Sleek, intuitive, and powerful front-end framework for (mobile) web development.
* [FontAwesome](http://fontawesome.io/) - Cute collection of awesome icons.
* [Sass](http://sass-lang.com/) - Powerful CSS extension on steroids.
* [FactoryGirl](https://github.com/thoughtbot/factory_girl_rails) - Fixtures replacement using definition syntax.
* [Faker](https://github.com/stympy/faker) - Library for generating fake data such as fullnames, usernames, emails and bios.
* [Devise](https://github.com/plataformatec/devise) - Advanced authentication solution for Rails.
* [Pundit](https://github.com/elabs/pundit) - Advanced authorization solution for Rails using policies.
* [Searcher](https://github.com/radar/searcher) - Simple search by pre-defined labels and wildcard matching queries.
* [will_paginate](https://github.com/mislav/will_paginate) - Simple yet effective pagination library.
* [Awesome Nested Set](https://github.com/collectiveidea/awesome_nested_set) - implementation of the nested set pattern for ActiveRecord models.
* [RSpec](http://rspec.info/) - Behavior driven development (BDD) testing framework for Ruby.
* [Cabybara](https://github.com/jnicklas/capybara) - Acceptance test framework for web applications.
* [Heroku](https://www.heroku.com/) - Cloud platform for easily deploying Rails applications.


## Author

Kiffin Gish \< kiffin.gish@planet.nl \>

\- You're never too old to learn new stuff.
