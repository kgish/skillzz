# SkillZZ

This is an advanced website platform for matching highly skilled workers to customers who are searching for the best and most appropriate person for a given task at hand.

Selection criteria includes categories, skills, user-defined tags, user bio, hourly rates, availability which can be selected in order to filter through the results and select the most appropriate match.

An example of such a query might be: "I am looking for a senior Ruby developer with knowledge of Linux and MySQL who charges
between 70-85 euros per hour and who will be available starting next month for three months."

A customer can select a number of pre-defined labels (tags) to narrow down the search or introduce his own user-defined tags to be more specific.

A given query will (hopefully) generate a number of hits which are then ordered via a ranking scheme weighted according to criteria and preferences of the customer.

The website was designed and built as part of a coding challenge given to me by [E-Accent](https://www.e-accent.com/) for the position of Remote Ruby on Rails Developer.

Special thanks go to the authors of the book [Rails 4 in Action](https://www.manning.com/books/rails-4-in-action) which provided me with invaluable guidance and insights, a really fantastic book.

Please note that I took the liberty of using some of their ideas and implementation details.


## Coding Challenge

This is the assignment which was given to me.

> *Given a website which matches workers to customers.*
> 
> *A worker is a registered user, who possesses one or more skills like “cooking”, “house cleaning”, “fixing wireless 
> networks”, and so on.*
> 
> *A customer, also a registered user, can search for workers by skill.*
> 
> *For example, if a customer needs a worker who can do both cooking and house-cleaning, she will go to the site, 
> choose both these skills from a list, and get a list of workers from which to choose.*
> 
> *The site could have perhaps up to 1,000 workers, 10,000 customers and 100 skills.*
> 
> *The challenge: create a prototype of this website, with the main focus on the back end, especially the models and 
> search functionality.*

I was given plus minus two weeks to design, build, test and deploy it. Quite the challenge, indeed!


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

In order to be able to take advantages of the services provided by this website, a user has to first login with his username and password.

The setup used is the one defined by the standard [Devise](https://github.com/plataformatec/devise) setup after running:

    $ rails generate devise:install
    $ rails generate devise user


## Users

During the installation the user table is populated with a number of pre-defined users, namely the following:

* admin@skillzz.com / password
* worker@skillzz.com / password
* customer@skillzz.com / password
* viewer@skillzz.com / password
* manager@skillzz.com / password

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

In order to be able to group similar skills together and improve overall searchability, a 'Tag' may be used. This is a single-word label attached to a given skill thus giving it extra granuality for searching.

A given skill can have one or more tags, and unique tags can be shared across different skills.

In this version, a tag can only consist of a single word, and a list of tags is a series of words separated by spaces.

As a workaround you can use dashes for multi-word labels, for example `continuous-integration` or `ruby-on-rails`.


## Data Model

The database tables, data types and relationships together define the different ways that the application interacts with the underlying data model in order to adhere to the user requirements (see code challenge).

On the highest level we have 'Categories' with a name (unique) and a description.

Each category can consist of one or more 'Skills' with a name (unique) and a description.

Finally, each skill can be correlated to one or more user-defined 'Tags' for helping with the search.

Here is a diagram which shows the high-level schema structure:

![](images/database-diagram.png?raw=true)


## Database

I decided to use [MySQL](https://www.mysql.com/) for development and testing since the default [SQLite](https://www.sqlite.org/) that Rails uses is not robust enough for my large datasets. 

By using the [Awesome Nested Set](https://github.com/collectiveidea/awesome_nested_set) gem for heirarchical model (Profile-Categories-Skills-Tags), and extra level of complexity is introduced.

For production I use [PostgreSQL](http://www.postgresql.org/) since that is the default for Heroku.


## Seeding

If after the installation, you decide that you want to pre-populate the database with a bunch of fresh random data, then you MUST remember to re-create the database from scratch like this:

    $ bundle exec rake db:migrate:reset
    $ bundle exec rake db:seed

Otherwise if you do not do this, running just `rake db:seed`  will abort with errors about non-unique names when attempting to create records that already exist.


## Testing

The functionality of this application is verified by running [RSpec](http://rspec.info/) which tests the defined user requirements by using features and sub-scenarios.

In order to run all of the tests do this:

    $ bundle exec rspec
  
or in order to run just a specific test, for example editing categories:

    $ bundle exec rspec spec/features/editing_categories_spec.rb
    

## Todos

Since I am a hard-core developer at heart, I tend to be a bit of a perfectionist. Even if I had more time for improving this application, I could go on forever. There will always be more to do later and even more after that.

Here is a list of todo items for a rainy day.

* Allow users to login using either their username or email.
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
* [Sunspot](https://github.com/sunspot/sunspot) - library for expressive, powerful interaction with the Solr search engine.
* [Awesome Nested Set](https://github.com/collectiveidea/awesome_nested_set) - implementation of the nested set pattern for ActiveRecord models.
* [Carrierwave](https://github.com/carrierwaveuploader/carrierwave) - File upload solution for Rails.
* [RSpec](http://rspec.info/) - Behavior driven development (BDD) testing framework for Ruby.
* [Cabybara](https://github.com/jnicklas/capybara) - Acceptance test framework for web applications.
* [Heroku](https://www.heroku.com/) - Cloud platform for easily deploying Rails applications.


## Author

Kiffin Gish \< kiffin.gish@planet.nl \>

\- You're never too old to learn new stuff.
