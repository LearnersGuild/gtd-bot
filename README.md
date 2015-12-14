# GTD Bot

## The purpose

Application integrates GlassFrog and Asana in order to automize parts of Getting Things Done process.

For example application is suppose to automatically add task "Add Next Action to the project" to all projects which does not have Next Action defined.

To see all defined strategies, see `app/services/strategies_factory.rb`

## Initial setup

```
bundle exec rake db:create db:create
bundle exec rake db:create db:migrate
```

```
cp config/configuration.yml.example config/configuration.yml
```

Open the file and fill it with proper credentials

```
touch log/god.log
chmod 755 log/god.log
```

## Running the bot

In `development` you can run the bot in two ways:

```
bundle exec ruby workers/bot_worker.rb
```

Or the same as it's being run on `demo`/`production`, using `god`:

```
god -c config/god.rb -D
```

You can check status of the bot, start/stop/restart bot or terminate `god` with following commands:

```
god status
god start/stop/restart bot
god terminate
```

## Tests

Run tests:

```
bundle exec rspec spec
```

## Rubocop

Run rubocop before pushing anything - it's part of CI process.

```
rubocop
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

## CircleCI

Add https://circleci.com/gh/LunarLogic/gtd-bot to your watched projects.

## Deploy

Deploy is done using `capistrano` gem.

After each green build of `dev` branch, there is automatic deploy to the
demo configured.

If for some reason you want to deploy to `demo` manually execute:

```
bundle exec cap demo deploy
```

Or to deploy to production:

```
bundle exec cap production deploy
```

## Capistrano tasks

Restart bot (done during deploy):

```
bundle exec cap demo/production bot:restart
```

Restart whole `god` process

```
bundle exec cap demo/production god:restart
```

Clean roles in the database. Be careful with this one. Use it only if
you know what you are doing :].

It will cause all `Role` to be deleted, so if you have not delete
project-roles in Asana, they will be dupplicated there.

It's useful only on `demo`, when you want to start from the scratch.

```
bundle exec cap demo/production clean:roles
```


## HoneyBadger

https://app.honeybadger.io/projects/45378/faults

## Demo

You can ssh to the `demo` server using one of the following commands:

```
ssh lunar@gtd-bot.demo.llp.pl -p 20057
ssh root@gtd-bot.demo.llp.pl -p 20057
```

## Production

You can ssh to the `production` server using one of the following commands:

```
ssh lunar@107.170.211.92
ssh root@107.170.211.92
```

## Things installed on production servers

Current application code is in `/home/lunar/apps/gtd-bot/current` directory

* `ruby`, version 2.2.3 with gemset `gtd-bot`
* `postgres` database
* `monit` - configured to monitor `god`, see `/etc/monit/conf.d/god.conf`
* `/home/lunar/apps/gtd-bot/shared/configuration.yml` as symbolic link to `/home/lunar/apps/gtd-bot/current/config/configuration.yml`
* `god` gem
  * custom god service in `/etc/init.d/god`
  * there is master `god` configuration in `/etc/god/god.rb` which loads `/etc/god/*.god` configurations, so for gtd-bot `/etc/god/gtd-bot_app.god`
  * it is symbolic link for `/home/lunar/apps/gtd-bot/shared/config/god.rb`
  * `/home/lunar/apps/gtd-bot/shared/config/god.rb` is copied from `/home/lunar/apps/gtd-bot/current/config/god.rb` by
    `capistrano` during deploy
  * to sum up, if you need to change `god` configuration, you should do
    it just in the repository, in `config/god.rb`
  * `god` logs to `/home/lunar/apps/gtd-bot/shared/log/god.log` - file
    needs to be created before running `god`

* logrotate for `god` and `production` logs
