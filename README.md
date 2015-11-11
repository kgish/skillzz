# SkillZZ

This is an advanced website platform for matching highly skilled workers to customers who are searching for the best and most appropriate person for a given task at hand.

Selection criteria includes categories, skills, user-defined tags, bio, hourly rates, availability for filtering
through the results.

An example of such a query might be: "I am looking for a senior Ruby developer with knowledge of Linux who charges
between 60-70 euros per hour and will be available starting next month for three months."

You can select a number of pre-defined labels (tags) to narrow down the search or introduce your own user-defined tags to be more specific.

A query will generate a number of hits which are then ordered according to a ranking scheme weighted according to 
criteria and preferences of the customer.

The website was designed and built as part of a coding challenge given to me by [E-Accent](https://www.e-accent.com/) for the position of Remote Ruby on Rails Developer.

Special thanks to the authors of the book [Rails 4 in Action](https://www.manning.com/books/rails-4-in-action) which provided me with invaluable guidance. This is a fantastic book.

I took the liberty of using some of the ideas and implementations from this source of inspiration.

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

I was given plus minus two weeks to design, build, test and deploy it: quite the challenge indeed!


## Installation

In order to install and start using this application, do the following:

    $ git clone git@github.com:kgish/skillzz.git
    $ cd skillzz
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:seed
    $ bundle exec rails server

The application is now up-and-running and can be viewed by pointing your favorite browser at http://localhost:3000.

If you are cloning this repository for development purposes, it is recommended that you also do the following from
within the project root directory just after you run `bundle install`:

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

During the installation the user table is populated with a number of pre-defined users, these are:

* admin@skillzz.com / password
* worker@skillzz.com / password
* customer@skillzz.com / password
* viewer@skillzz.com / password
* manager@skillzz.com / password

In order to facilitate a more usable demo, the worker and customer are pre-seeded with programming skills along with a number of other randomly selected categories and skills.

In addition to those pre-defined users, the database is seeded with a number of random users using the [Faker](https://github.com/stympy/faker) gem.


## Roles

There are four roles for the website:

* Visitor - Happens to find the website, gathers information and can sign up either as a worker or a customer.
* Worker - Is available for employment whose profile is a collection of skills that can be searched.
* Customer - Looking for workers with a given number of skills and can search using tags.
* Administrator - Has complete access rights required for administrating the website.

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

In order to be able to group similar skills together and improving searchability tags are used. These are single word labels attached to a given skill.

A given skill can have one or more tags.

In this version, a tag can only consist of a single word, and a list of tags is a series of words separated by spaces.

As a workaround you can use dashes, for example `continuous-integration`.


## Data Model

The database tables, data types and relationships together define the different ways that the application interacts with the underlying data model in order to adhere to the user requirements.

On the highest level we have 'Categories' with a name (unique) and a description.

Each category can consist of one or more 'Skills' with name (unique) and a description.

Finally, each skill can be correlated to one or more user-defined 'Tags' for helping with the search.

Here is a diagram which shows the high-level structure:

![](images/database-diagram.png?raw=true)


## Database

I decided to use [MySQL](https://www.mysql.com/) for development and testing since the default 
[SQLite](https://www.sqlite.org/) that Rails uses is not robust enough for my large datasets.

For production I use [PostgreSQL](http://www.postgresql.org/) since that is the default for Heroku.


## Seeding

If after the installation, you decide that you want to pre-populated the database with a bunch of random data then you first have to remember to re-create the database from scratch.

    $ bundle exec rake db:migrate:reset
    $ bundle exec rake db:seed

Otherwise, running `rake db:seed` without doing this will abort with errors about non-unique names.

## Testing

The functionality of this application is verified by running `rspec` which tests the defined features and scenarios.

In order to run all the tests:

    $ bundle exec rspec
  
or in order to run just a specific feature, in this example editing categories:

    $ bundle exec rspec spec/features/editing_categories_spec.rb
    

## Todos

Even if I had more time to create a more improved version of this application, being a developer at heart in pursuit of perfection means that there will always be stuff to do for later.

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

Of course, I couldn't have done any of this without the following fantastic resources which have helped me out very much. The open source community is a fantastic place with lots of coding heroes.

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

Kiffin Gish
kiffin.gish@planet.nl

- You're never too old to learn new stuff.
