# README

This README provides the necessary steps to set up, run, and deploy the PhD Annual Review System application, as well as to test the app. Ensure that PostgreSQL is installed locally to create the database. If not, follow the instructions at [Heroku Postgres Local Setup](https://devcenter.heroku.com/articles/local-setup-heroku-postgres).

## Ruby and Rails Versions

The project is compatible with the following versions of Ruby and Rails:

- Ruby version: 3.2.2 or newer (for Rails 7.0.Z)

The gemfile has ruby 3.2.2 and rails 7.0.8.

Install Heroku CLI following the [Heroku CLI Installation Guide](https://devcenter.heroku.com/articles/heroku-cli) .

## Steps to setup and run the code locally

1. Clone the repo to your local machine using `git clone -b main <repo url>`.
2. Navigate to the `PhD-Annual-Review-System` directory.
3. Run `bundle install`.
4. Run `rails db:migrate`.
5. Run `rails db:seed`.
6. Run `rails s` to run the code locally.
7. Run `bundle exec cucumber` to execute cucumber test cases.
8. Run `bundle exec rspec` to run rspec test cases.

## Steps to deploy the code on Heroku

1. Log in to Heroku:
    - Run `heroku login` and enter your credentials.
2. Create a new app on Heroku (if not already created):
    - Run `heroku create phd-review-app` to create a new app on Heroku.
3. Link the app to your local git repository:
    - Run `git remote add heroku <git url to Heroku app>`. To find the `<git url to Heroku app>`, go to the Heroku webpage, select your app, go to settings, and copy the "Heroku git URL".
4. Push the changes to the Heroku main branch to deploy the code:
    - Run `git push heroku main`.
5. Create all the tables in the database:
    - Run `heroku run rails db:migrate`.
6. Add dummy values to the table:
    - Run `heroku run rails db:seed`.
7. Access the deployed app at the provided URL. To find the URL, go to the Heroku webpage, select your app, and click on `Open app` in the top right.

## Steps to test the app

1. Use the provided dummy users in the database for testing:
    - Student: emailId: harshsurolia@tamu.edu, password: 12345678.
    - Faculty: emailId: profexample@tamu.edu, password: 12345678.
    - Admin: emailId: adminexample@tamu.edu, password: 12345678.
