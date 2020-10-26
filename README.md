# Getting Started

### Clone this repo
```sh
$ git clone git@github.com:rgabriel01/covid_stats.git
$ cd covid_stats
```

### Install postgresql
Easiest way is to go homebrew route
currently, `9.6` version is being supported
```sh
$ brew install postgresql@9.6
```
You need to add this `export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"` on your selected shell (zshrc, bashrc, etc.)
You can check if postgres is installed correctly by:
```sh
$ postgres -V
```
To start postgres:
```sh
$ brew services start postgresql@9.6
```
or if you want postgres to start automatically
```sh
$ pg_ctl -D /usr/local/var/postgresql@9.6 start
```

### Installing Gems
**note** that you should be on the directory of the project before doing this step
Install bundler gem
```sh
$ gem install bundler
```
Run bundler to install gems
```sh
$ bundle install
```

### Create Databases, Migrate Database
```sh
bundle exec rails db:create
bundle exec rails db:migrate
```

### Running the app
```sh
bundle exec rails s
```

### Importing csv
**note** one can access importation by means of
```
localhost:3000
```

### Covid observation statistics
**note** one can query covid observation stats by means of:
```
localhost:3000/top/:statistic?observation_date=[YYYY-MM-DD]&max_results=[integer]
```
**note** statistic can be interchange by providing the ff keywords:
* confirmed
* deaths
* recoveries

