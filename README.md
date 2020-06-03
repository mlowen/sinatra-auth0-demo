# Sinatra Auth0 Demo

This repository contains the demo code for performing authentication and authorization in [Sinatra](http://sinatrarb.com/) applications utilising [Auth0](https://auth0.com/). In addition to Sinatra this demo utilises the following libraries to provide this capability:

* [Warden](https://github.com/wardencommunity/warden)
* [Omniauth](https://github.com/omniauth/omniauth)
* [JWT](https://github.com/jwt/ruby-jwt)

This demo uses [SQLite](https://sqlite.org/) with [Sequel](https://sequel.jeremyevans.net/) ORM for data storage and [foreman](https://github.com/ddollar/foreman) for running tasks. This repository contains two applications each in their own sub-directory. The `app` directory contains a "front end" web application which is used to demo:

* Authenticating and getting a token with the [oAuth2 authorisation grant flow](https://tools.ietf.org/html/rfc6749#section-4.1).
* Refreshing a token when it has expired using the [oAuth2 refresh flow](https://tools.ietf.org/html/rfc6749#section-6).
* Interacting with a token secured API from either the client or via a [backend for frontend](https://samnewman.io/patterns/architectural/bff/) style pattern.

The `api` directory contains an API service which uses an Auth0 token to secure access to the endpoints. This is implmented via a [rack](https://github.com/rack/rack) middleware. It contains two endpoints `/success` which will work based on the default scopes and `/fails` which if you do not add any additional scopes will not allow access.

## Setting Up

Before anything else you will need [ruby](https://www.ruby-lang.org/) installed, this demo was developed on version 2.7.0.

### Auth0

Once you have created your Auth0 account you will need to create a regular web application with the following configuration:

* Allowed callback URL:  `http://localhost:9292/auth/callback`.
* Allowed logout URL: `http://localhost:9292`.

You will also need to create an API with the identifier `http://localhost:9293` and allow offline access enabled.

### Code

Once you have cloned the repository to your local machine you need to install the dependencies with the following command:

```
bundle install
```

Once installed you will need to setup the datastore, this can be done by running:

```
bundle exec rake db:migrate
```

### Environment

This demo relies on a set of environment variables, if you like me don't want to pollute your environment with these variables I would suggest installing [foreman](https://github.com/ddollar/foreman). Which you can install with the following:

```
gem install foreman
```

You will then need to create a `.env` file with the following contents filling in the blank variables with the values you get from Auth0.

```
AUTH0_DOMAIN=
AUTH0_ID=
AUTH0_SECRET=
AUTH0_AUDIENCE=http://localhost:9293
COOKIE_SECRET=mycookiesecret
```

## Running

The API should be running before you run the app, or at the very least the API needs to be running before you sign into the demo application. If you are using foreman as the task running you can start the API with:

```
foreman run api
```

You can run the app with:

```
foreman run app
```

If you are not using foreman checkout the `Procfile` in the root of the repository for the appropriate commands to run.