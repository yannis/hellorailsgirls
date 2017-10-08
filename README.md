# Deploy your app on [hidora.com](https://www.hidora.com)

![](/readme_images/1.png)
![](/readme_images/2.png)
![](/readme_images/3.png)
![](/readme_images/4.png)
![](/readme_images/5.png)

Set Environment Variables (Env Vars) in your application configuration. Since we're using the default Passenger server, we have to add the following lines at he bottom of the `server {}` in `/etc/nginx/app_servers/nginx-passenger.conf`.

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

Once deployed this configuration will then inherit from the Env Vars that you have set above.
