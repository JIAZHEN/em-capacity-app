# README

This README would normally document whatever steps are necessary to get the
application up and running.

## The model

```
./bin/rails g model Absence employee:references calendar_date:date half_day:boolean absence_type:string
```

## DB migration

```
./bin/rake db:create
./bin/rake db:migrate
```
