# SkillZZ

This is an advanced website platform for matching highly skilled workers to customers who are searching for the best and most appropriate person for a given task at hand.

Selection criteria includes skills, skill categories, hourly rates, availability for filtering through the results.

An example of such a query might be: I am looking for a senior Ruby developer with knowledge of Linux who charges between 60 - 70 euros per hour and will be available next month for three months.

A query will generate a number of hits which are then ordered according to a ranking scheme weighted according to criteria and preferences of the customer.

The website was designed and built as part of a coding challenge given to me by [E-Accent](https://www.e-accent.com/) for the position of Remote Ruby on Rails Developer.


## Coding Challenge

This is the assignment which was given to me.

> Given a website which matches workers to customers. 
> 
> A worker is a registered user, who possesses one or more skills like “cooking”, “house cleaning”, “fixing wireless networks”, and so on. 
> 
> A customer, also a registered user, can search for workers by skill.
> 
> For example, if a customer needs a worker who can do both cooking and house-cleaning, she will go to the site, choose both these skills from a list, and get a list of workers from which to choose.
> 
> The site could have perhaps up to 1,000 workers, 10,000 customers and 100 skills.
> 
> The challenge: create a prototype of this website, with the main focus on the back end, especially the models and search functionality.

I had two weeks the time to design and build it.


## Authentication

In order to be able to take advantages of the services provided by this website, a user has to first login with his username and password.


## Roles

There are four roles for the website:

* Visitor - the casual Internet user who happens to find the website, gathers information and can sign up was either a worker or a customer.
* Worker - person with collection of skills who is available for employment.
* Customer - user who is looking for workers with a given number of skills.
* Administrator - has complete access rights required for administrating the website.


## Installation

In order to install and start using this application, do the following:

    git clone git@github.com:kgish/skillzz.git
    cd skillzz
    bundle install
    bundle exec rake db:migrate
    bundle exec rails server

The application is now up-and-running and can be viewed by pointing your favorite browser at http://localhost:3000.

## Testing

The functionality of this application is verified by running `rspec` which tests the defined features and scenarios.

In order to run all the tests:

    bundle exec rspec
  
or in order to run just a specific feature, in this example editing categories:

    bundle exec rspec spec/features/editing_categories_spec.rb
    

## References

Of course, I couldn't have done any of this without the following fantastic resources.

* [Ruby on Rails](http://rubyonrails.org/) - the most amazing website on the face of the Earth.
* [RSpec](http://rspec.info/) - behavior driven development for Ruby.
* [Bootstrap](http://getbootstrap.com/) - sleek, intuitive, and powerful front-end framework for (mobile) web development.
* [FontAwesome](http://fontawesome.io/) - cute collection of icons.
* [Sass](http://sass-lang.com/) - powerful turbo CSS extension.
* [Rails 4 in Action](https://www.manning.com/books/rails-4-in-action) - by a long shot the most extensive hands-on Rails guide available.
* [Devise](https://github.com/plataformatec/devise) - authentication solution for Rails.
* [Pundit](https://github.com/elabs/pundit) - authorization solution for Rails using policies.
* [Carrierwave](https://github.com/carrierwaveuploader/carrierwave) - file upload solution for Rails.
* [Heroku](https://www.heroku.com/) - cloud platform for easily deploying Rails applications.
