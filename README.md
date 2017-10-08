# Deploy your app on [hidora.com](https://www.hidora.com)

## Set up your enviroment on hidora.

![](/readme_images/-1.png)

Chose "Create a new environment" and click on "Ruby" at the top of the modal window.

![](/readme_images/0.png)

### SSL setup

Start by setting 'SSL' by chosing the default Jelastic SSL.

SSL (Secure Sockets Layer) is the standard security technology for establishing an encrypted link between a web server and a browser. This link ensures that all data passed between the web server and browsers remain private and integral. It's now somehow required by default by most users and Chrome now mark website that don't use it as "not secure".

![](/readme_images/1.png)

### Balancing setup

Load balancing across multiple application instances is a commonly used technique for optimizing resource utilization, maximizing throughput, reducing latency, and ensuring fault-tolerant configurations. Even if you don't use multiple application instances yet, it's good to set it up now to be future-proof.

![](/readme_images/2.png)

### Ruby server setup

We also need a server that support Ruby. Hidora is proposing [Phusion Passenger](https://en.wikipedia.org/wiki/Phusion_Passenger) as the default Ruby server which is a good choice. Here, we will just increase the ruby version to the last one, 2.4.1.

![](/readme_images/3.png)

### Database (DB) setup

Here will set the database that our app will use. `Postgres` has become the _de facto_ relational database for a production app.

![](/readme_images/4.1.png)
![](/readme_images/4.2.png)

We will also add a Redis instance because we need it for the Websockets used in this app.

![](/readme_images/4.3.png)

Finally click the "Apply" or "Create" button located on the bottom right of the modal window.

You'll then get two emails by Hidora containing your credentials for the Postgres and for the Redis cartridges. These emails contain your password to access these cartridges. Keep these emails preciously, you'll need them later.

![](/readme_images/5.1.png)
![](/readme_images/5.2.png)

For security reasons, we don't want to hardcode these credentials in our code. To set them up, we will use [Environment Variables (Env Vars)](https://en.wikipedia.org/wiki/Environment_variable).

We have to set this Env Vars in our application configuration. Since we're using the default Passenger server, we have to edit the `/etc/nginx/app_servers/nginx-passenger.conf` configuration file.

To reach this file, click on the config icon of the `Nginx Ruby` service.

![](/readme_images/6.png)

Then open the following path `Root > etc > nginx > app_servers` and open the `nginx-passenger.conf` file.

![](/readme_images/7.png)

Add the following lines at he bottom of the `server {}` declaration in `/etc/nginx/app_servers/nginx-passenger.conf`.

```
passenger_env_var SECRET_KEY_BASE
'{your secret token}';
passenger_env_var DATABASE_URL
'postgres://{your database subdomain}.hidora.com';
passenger_env_var DATABASE_USERNAME
'{your database username}';
passenger_env_var DATABASE_PASSWORD
'{your database password}';
passenger_env_var REDIS_URL 'redis://:{redis password}@{redis node}.hidora.com'
```

the final config file should look like:

```
passenger_root /usr/lib/rvm/gems/current-gems/gems/passenger-version;
passenger_ruby /usr/lib/rvm/wrappers/current-wrapper/ruby;
include /etc/nginx/ruby.env ;

server {
    listen       *:80;
    server_name  _;
    root /var/www/webroot/ROOT/public ;   # <--- be sure to point to 'public'!
    passenger_enabled on;
    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
    passenger_env_var SECRET_KEY_BASE
    '{your secret token}';
    passenger_env_var DATABASE_URL
    'postgres://{your database subdomain}.hidora.com';
    passenger_env_var DATABASE_USERNAME
    '{your database username}';
    passenger_env_var DATABASE_PASSWORD
    '{your database password}';
    passenger_env_var REDIS_URL 'redis://:{redis password}@{redis node}.hidora.com'
}
```

You can generate a secret token for your app with `bin/rails secret ENV=production`.

Once this line added, save the file by clicking on the "Save" icon.

### Change your app configuration

You have to change the database configuration of your app too. The configuration file is located at `/config/database.yml`.

Change the `production:` part as the following:

```
production:
  <<: *default
  host: <%= ENV['DATABASE_URL'] %>
  database: hellorailsgirls_production
  username: <%= ENV['DATABASE_USERNAME'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
```

You also have to change `config/cable.yml` as following:

```
development: &development
  adapter: redis
  url: redis://localhost:6379

test: *development

production:
  adapter: redis
  url: <%= ENV['REDIS_URL'] %>
```

Once deployed, our app configurations will inherit from the Env Vars that you have set above.

### Deploy your app

We will deploy our app from github. To do that click the "Add project" icon from the "Nginx Ruby Service".

![](/readme_images/8.png)
![](/readme_images/9.png)

Enter the url to your github project and click "Add".

The Jelastic tool on which Hidora is based can perform post deployment application configuration via `rake`. This is usually needed to finalize configuration of complex applications, to run additional applications or specific steps for application configuration like `db:migrate`. We will use this mechanism to create and migrate our database upon deploy. [more info](https://docs.jelastic.com/ruby-post-deploy-configuration)

For this, we will create a `rake_deploy` file at the root of our application with the following content:

```
db:create RAILS_ENV=production
db:migrate RAILS_ENV=production
assets:precompile RAILS_ENV=production
```

Now commit your code and push it to github. Once done,
redeploy it by clickining on the "Update from git" icon of the "Production" context.

![](/readme_images/10.png)
