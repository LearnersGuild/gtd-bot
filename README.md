# GTD Bot

To run server:
```
bundle exec rake db:create db:migrate
bundle exec rails s
```

To run `god` in development:
```
touch log/god.log
chmod 755 log/god.log

god -c config/god.rb -D
```

Additional commands for `god`:
```
god status
god start/stop/restart bot
god terminate
```
