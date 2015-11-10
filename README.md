# SkillZZ

This is an advanced website platform for matching highly skilled workers to customers who are searching for the best
and most appropriate person for a given task at hand.

Selection criteria includes categories, skills, user-defined tags, bios, hourly rates, availability for filtering
through the results.

An example of such a query might be: I am looking for a senior Ruby developer with knowledge of Linux who charges
between 60-70 euros per hour and will be available starting next month for three months.

A query will generate a number of hits which are then ordered according to a ranking scheme weighted according to 
criteria and preferences of the customer.

The website was designed and built as part of a coding challenge given to me by [E-Accent](https://www.e-accent.com/) 
for the position of Remote Ruby on Rails Developer.

Special thanks to the authors of the book [Rails 4 in Action](https://www.manning.com/books/rails-4-in-action) which 
provided me with invaluable guidance. This is a fantastic book.

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

    git clone git@github.com:kgish/skillzz.git
    cd skillzz
    bundle install
    bundle exec rake db:migrate
    bundle exec rake db:seed
    bundle exec rails server

The application is now up-and-running and can be viewed by pointing your favorite browser at http://localhost:3000.


## Authentication

In order to be able to take advantages of the services provided by this website, a user has to first login with his 
username and password.


## Users

During the installation the user table is populated with a number of pre-defined users, these are:

* admin@skillzz.com / password
* worker@skillzz.com / password
* customer@skillzz.com / password
* viewer@skillzz.com / password
* manager@skillzz.com / password

In addition to those, the database is seeded with random users using the [Faker](https://github.com/stympy/faker) gem.


## Roles

There are four roles for the website:

* Visitor - Happens to find the website, gathers information and can sign up either as a worker or a customer.
* Worker - Has collection of skills who is available for employment.
* Customer - Looking for workers with a given number of skills.
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

In order to be able to group similar skills together and improving searchability tags are used. These are single word
labels attached to a given skill.

A given skill can have one or more tags.

In this version, a tag can only consist of a single word, and a list of tags is a series of words separated by spaces.


## Data Model

The database tables, data types and relationships together define the different ways that the application interacts 
with the underlying data model in order to adhere to the user requirements.

On the highest level we have 'Categories' with a name (unique) and a description.

Each category can consist of one or more 'Skills' with name (unique) and a description.

Finally, each skill can be correlated to one or more user-defined 'Tags' for helping with the search.

Here is a diagram which shows the high-level structure:

-Diagram goes here-


## Testing

The functionality of this application is verified by running `rspec` which tests the defined features and scenarios.

In order to run all the tests:

    bundle exec rspec
  
or in order to run just a specific feature, in this example editing categories:

    bundle exec rspec spec/features/editing_categories_spec.rb
    

## Todos

Even if I had more time to create a more improved version of this application, being a developer at heart in pursuit of
perfection means that there will always be stuff to do for later.

Here is a list of todo items for a rainy day.

* Allow users to login using either username or email
* Allow users to include profile picture that can be uploaded.
* Take into account the availability of workers when matching.
* Take into account the hourly rate of workers when matching.
* Allow customers to create user-defined searches and save them.
* Email notifications when there are new matches detected.
* Allow tags to consist of multiple words.
* Ad infinitum...


## References

Of course, I couldn't have done any of this without the following fantastic resources which have helped me out very 
much. The open source community is a fantastic place with lots of coding heroes.

* [Ruby on Rails](http://rubyonrails.org/) - The most amazing website on the face of the Earth.
* [Rails 4 in Action](https://www.manning.com/books/rails-4-in-action) - By a long shot the most extensive hands-on Rails guide available.
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

Never to old to learn new stuff.
