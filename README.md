# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:
* Rails 6

* Ruby version: 2.7.1

* System dependencies: ```bundle -j 4```

* Configuration:
  
    Please make sure you are install redis and run it first at all - I used it for caching data.

* How to run the test suite 

    
  1. ```bundle exec rspec spec/ ```

  2. ```bundle exec rspec spec/controllers```

  3. ```actioncable, activejob ...```
   
(Development options)
* Run Rails application: 
  ```rails s```

* Run Puma for ActionCable: 
  ```bundle exec puma -p 28080 cable/config.ru```

* Run webpack:
  ```./bin/webpack-dev-server```
