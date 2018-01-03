# gtd-bot

The gtd-bot application integrates GlassFrog and Asana in order to automate parts of the Getting Things Done process.

To see all defined strategies, see `app/services/strategies_factory.rb`

Be sure you've read the [instructions for contributing](./CONTRIBUTING.md).


## Initial setup

```
bundle install
bundle exec rake db:create db:migrate
cp .env.example .env
```

Open the newly created `.env` file and fill it with proper credentials for `development` stage.


## Running the bot

### Development

In `development` you can run the bot in two ways:

```
bundle exec ruby workers/bot_worker.rb
```

Or using Heroku CLI:

```
heroku local
```

### Production and Staging

Bot is hosted on Heroku.
To use Heroku CLI on your local machine, you need to be added as a collaborator to both staging and production apps on Heroku. Next, type this in your command line while you're in the bot directory:

```
heroku git:remote -a gtd-bot-staging
git remote rename heroku heroku-staging
heroku git:remote -a gtd-bot
```

You can manage the app from your command line or [Heroku web panel](https://dashboard.heroku.com/pipelines/fa0f00ca-5915-4cbc-9f21-678ca40374b7).

## Tests

Run tests:

```
bundle exec rspec spec
```

## Rubocop

Run rubocop before pushing anything - it's part of CI process.

```
bundle exec rubocop
```

## Guard

You can use `guard` gem to automate above process. Run:

```
bundle exec guard
```

And it will execute matching test and rubocop checks for every file you save.

## Code coverage

Coverage is measured with 'simplecov'. Default output is in `coverage` directory.

## Profiling

You can run bot with `ruby-prof` enabled by executing following command:

```
RAILS_ENV=profile bundle exec ruby workers/bot_worker.rb
```

## Continuous Integration

CI builds run on Codeship: https://app.codeship.com/projects/158630.

## Deploy

After each green build of `dev` branch, there is automatic deploy to Staging.

To deploy from Staging to Production, go to [project Heroku pipeline](https://dashboard.heroku.com/pipelines/fa0f00ca-5915-4cbc-9f21-678ca40374b7) and click on `Promote to Production`.
