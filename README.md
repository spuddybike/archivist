## README

[![Build Status](https://travis-ci.org/CLOSER-Cohorts/archivist.svg?branch=develop)](https://travis-ci.org/CLOSER-Cohorts/archivist)
[![Inline docs](http://inch-ci.org/github/CLOSER-Cohorts/archivist.svg?branch=develop)](http://inch-ci.org/github/CLOSER-Cohorts/archivist)
[![Coverage Status](https://coveralls.io/repos/github/CLOSER-Cohorts/archivist/badge.svg?branch=develop)](https://coveralls.io/github/CLOSER-Cohorts/archivist?branch=master)
[![Code Climate](https://codeclimate.com/github/CLOSER-Cohorts/archivist/badges/gpa.svg)](https://codeclimate.com/github/CLOSER-Cohorts/archivist)
[![Issue Stats](http://issuestats.com/github/CLOSER-Cohorts/archivist/badge/issue)](http://issuestats.com/github/CLOSER-Cohorts/archivist)

### Model Relationship Diagram
![](/app/assets/images/diagrams/erd.png)

## Configuration
* Ruby: 2.3.1
* Rails: 5.0.X
* Postgres: 9.5.X
* Redis: 3.2.X

## Deployment
Currently Archivist has only been designed to be deployed to [Heroku][heroku], but rolling your own deployment should not be too difficult.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/CLOSER-Cohorts/archivist/tree/master)

#### Some basic steps
1. `git clone -b master --single-branch https://github.com/CLOSER-Cohorts/archivist.git`
2. `cd archivist`
3. `gem install bundler`
4. `bundler install`
5. Set the environment variable  `RAILS_ENV=production` (e.g. `export RAILS_ENV=production`)
6. Copy `config/application.yml.dist` to `config/application.yml`
7. Set the mailer and database password in the above file
8. `rails db:migrate`
9. Start server: `foreman run web`

This _could_ cause the webserver to start...

## Testing
To run the test suite just call `rails test`. Currently 197 tests and 256 assertions.

## Stats
| Name                 |   Lines |     LOC | Classes | Methods | M/C | LOC/M |
|----------------------|---------|---------|---------|---------|-----|-------|
| Controllers          |    1168 |     746 |      33 |      76 |   2 |     7 |
| Jobs                 |     206 |     167 |      10 |       9 |   0 |    16 |
| Models               |    2895 |    1615 |      40 |     158 |   3 |     8 |
| Mailers              |      12 |      11 |       2 |       1 |   0 |     9 |
| Javascripts          |    4527 |    3929 |       0 |     477 |   0 |     6 |
| Libraries            |    3463 |    2750 |      32 |     126 |   3 |    19 |
| Tasks                |     390 |     322 |       0 |       1 |   0 |   320 |
| Controller tests     |     862 |     713 |      18 |      93 |   5 |     5 |
| Model tests          |     663 |     478 |      30 |      97 |   3 |     2 |
| Mailer tests         |      11 |       5 |       2 |       0 |   0 |     0 |
| **Total**            |**14221**|**10755**|  **167**| **1040**|**6**|  **8**|

  - Code LOC: 9559
  - Test LOC: 1196
  - Code to Test Ratio: 1:0.1

## Archivist Realtime
Archivist is both a module within Archivist and an entirely separate 
webapp. [Archivist-realtime][realtime] is very slim Node.js app that 
provides a communications channel between the [Redis][redis] cache and 
all active users via websockets (Socket.io). The purpose of this is to 
be able to lock objects while editing them and to update a users 
screen as changes are made to an instrument.

[realtime]: https://github.com/CLOSER-Cohorts/archivist-realtime
[redis]: http://redis.io
[heroku]: http://heroku.com
