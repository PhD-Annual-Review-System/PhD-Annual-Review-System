# README

This README provides the necessary steps to set up, run, and deploy the PhD Annual Review System application, as well as to test the app. Ensure that PostgreSQL is installed locally to create the database. If not, follow the instructions at [Heroku Postgres Local Setup](https://devcenter.heroku.com/articles/local-setup-heroku-postgres).

## Team Contact Information

**Product Owner:** Neha Joshi  
- Email: nehayj100@tamu.edu

**Scrum Master:** Prachi Surbhi  
- Email: psurbhi@tamu.edu

**Team Members:**
1. William Harper
   - Email: wdharper@tamu.edu

2. Shashank Jagtap
   - Email: shashankjagtap@tamu.edu

3. Shwetima Sakshi
   - Email: shwetimasakshi@tamu.edu

4. Harshvardhan Surolia
   - Email: harshsurolia2609@tamu.edu

## Ruby and Rails Versions

The project is compatible with the following versions of Ruby and Rails:

- Ruby version: 3.2.2 or newer (for Rails 7.0.Z)

The gemfile has ruby 3.2.2 and rails 7.0.8.

## Steps to install ruby

```bash
cd ~
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc
source ~/.bashrc
rbenv install 3.2.2
cd <project directory>
rbenv local 3.2.2
```

Install Heroku CLI following the [Heroku CLI Installation Guide](https://devcenter.heroku.com/articles/heroku-cli) .

## Steps to setup and run the code locally

1. Clone the repo to your local machine using `git clone -b main <repo url>`.
2. Navigate to the `PhD-Annual-Review-System` directory.
3. Run `bundle install`. This will install rails and all the other dependencies
4. Run `rails db:create`.
5. Run `rails db:migrate`.
6. Run `rails db:seed`.
7. Run `rails s` to run the code locally.
8. Run `bundle exec cucumber` to execute cucumber test cases.
9. Run `bundle exec rspec` to run rspec test cases.

## Steps to deploy the code on Heroku. Make sure you are in the project directory

1. Log in to Heroku:
    - Run `heroku login` and enter your credentials.
2. Create a new app on Heroku (if not already created):
    - Run `heroku create <app-name>` to create a new app on Heroku.
3. Link the app to your local git repository:
    - Run `git remote add heroku <git url to Heroku app>`. To find the `<git url to Heroku app>`, go to the Heroku webpage, select your app, go to settings, and copy the "Heroku git URL".
4. Provision a Heroku Postgres database:
    - Run `heroku addons:create heroku-postgresql:mini`.
5. Push the changes to the Heroku main branch to deploy the code:
    - Run `git push heroku main`.
6. Create all the tables in the database:
    - Run `heroku run rails db:migrate`.
7. Add dummy values to the table:
    - Run `heroku run rails db:seed`.
8. We have a rake task to populate database using csv file:
    - Run `heroku run rake db:populate`.
    - Make sure the csv files are added to the resources folder in the application and the application is pushed to Heroku with the csv files
9. Access the deployed app at the provided URL. To find the URL, go to the Heroku webpage, select your app, and click on `Open app` in the top right.

## Steps to test the app

1. Use the provided dummy users in the database for testing:
    - Student: emailId: harshsurolia@tamu.edu, password: 12345678.
    - Faculty: emailId: profexample@tamu.edu, password: 12345678.
    - Admin: emailId: adminexample@tamu.edu, password: 12345678.

## Troubleshooting

If you encounter any issues while setting up, running, or deploying the PhD Annual Review System application, refer to the following troubleshooting guide. If your issue persists, consider creating an issue on the [GitHub repository](https://github.com/PhD-Annual-Review-System/PhD-Annual-Review-System/issues).

### 1. Bundler and Gem Issues

If you encounter errors related to Bundler or gem dependencies, follow these steps:

- Run `bundle install` to ensure all gems are installed correctly.
- Check for any specific gem version requirements in the Gemfile.lock and update accordingly.

### 2. Database Setup Issues

#### Local Database Setup

If you face problems with setting up the local database, ensure that PostgreSQL is installed and properly configured. Follow the [Heroku Postgres Local Setup guide](https://devcenter.heroku.com/articles/local-setup-heroku-postgres) for assistance.

#### Heroku Database Setup

When deploying to Heroku, run the following commands:

```bash
heroku addons:create heroku-postgresql:mini
git push heroku main
heroku run rails db:migrate
heroku run rails db:seed


