# Teams, Buckets, Issues

I Got Issues provides a few simple building blocks for organization and then gets out of the way so you can do your work.

![football](http://f.cl.ly/items/0u2T313B0I0X0O0E1p08/Screen%20Recording%202014-11-11%20at%2011.05%20PM.gif)

I Got Issues is team specific and repository agnostic so you can import issues from any number of repositories into your team's buckets.

I Got Issues does not force a specific workflow but it was developed with a workflow in mind.

## Our Workflow

My team at work prioritizes our issues into three buckets, In Progress, Up Next, and Icebox.

![buckets](http://cl.ly/image/0j2B0f0I3H2H/Issues.jpg)

Approximately once a week we have a meeting where we move issues between the buckets, discussing in progress and completed issues, figuring out what issues are up next to work on, and triaging the icebox.

![prioritizing](http://cl.ly/image/0e0l3M06452S/prioritize.gif)

We only import issues that we need to talk about and possibly work on.

![importing](http://cl.ly/image/0m0T1P3z0m1s/importing.gif)

When I start working on an issue I move it from Up Next to In Progress and assign it to myself.

![start working](http://cl.ly/image/2a2D300H353X/start%20working.gif)

I can close the issue by simply checking the box once I have completed the work.

![completing](http://cl.ly/image/1i1V0d2q3X1T/completing.gif)

At our next prioritization meeting we discuss and then ship the completed issues which are then rolled up into a Markdown ship list that we can post somewhere for the rest of the company to see.

![shipping](http://cl.ly/image/0u3M1J3m3O3k/shipping.gif)

Finally we can audit the history of decisions we made.

![auditing](http://cl.ly/image/1E2s0o0G0O12/auditing.gif)

## Usage

Clone the repo and run bundler.

```bash
git clone https://github.com/jonmagic/i-got-issues.git
cd i-got-issues
bundle
```

Now go to https://github.com/settings/applications and register a new application. You'll need the *Client ID* and *Client Secret*, if you run the server locally the *Authorization callback URL* is http://127.0.0.1:3000/auth/github/callback.

Create a `.env` file in the root of the project and enter the following details filling in with the values you just copied after registering a new application:

```
GITHUB_KEY=client_id_from_the_app_you_just_registered
GITHUB_SECRET=client_secret_from_the_app_you_just_registered
```

Now bootstrap the database and start the server.

```bash
rake db:setup
rails server
```

Open your browser to http://localhost:3000 and choose a team :) Enjoy!

## Development

Run the tests with `rake`.

## Deploying

I setup the app on Heroku in a matter of minutes. You shouldn't have any problems.

1. Create the Heroku app and add the remote to your local git repository
1. Register app on GitHub https://github.com/settings/applications
1. Set the two environment variables `GITHUB_KEY` and `GITHUB_SECRET` using `heroku config:add`
1. Deploy the app to Heroku with `git push heroku`
1. Run database migrations with `heroku run rake db:migrate`

Fire it up in your browser and see if it worked.

## Contributing

Read the [guide to contributing](https://github.com/jonmagic/i-got-issues/blob/master/CONTRIBUTING.md).

### Contributors

* [@jonmagic](https://github.com/jonmagic)
* [@juliamae](https://github.com/juliamae)
* [*jankeesvw](https://github.com/jankeesvw)
* [@muan](https://github.com/muan)

## License

See [LICENSE](https://github.com/jonmagic/i-got-issues/blob/master/LICENSE).
