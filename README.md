# Uptime

Experimental project to monitor website uptime.

The meat of it is in SiteMonitorHandler, SiteMonitor, CheckHandler, and Checker.

SiteMonitorHandler is responsible for spawning new SiteMonitors and tracking their pids.

SiteMonitors are responsible for keeping track of what site they're monitoring, what their current status is, and what time it was last checked. SiteMonitor's are also responsible for triggering each check.

Because we don't know how many sites are going to be monitored, we want to make sure we don't run into a situation where we perform hundreds of HTTP requests all at the same time. To prevent this we use a GenStage flow.

Using GenStages we have a single producer, CheckHandler, and many consumers, Checkers. If we have 5 Checkers subscribed to the CheckHandler events, then we will only ever have up to 5 concurrent HTTP requests all at once.

One thing to keep in mind is that if your checks requests are coming in faster than your checkers can consume then your queue will continue to grow bigger and bigger. The only way to handle this would be to increase the number of subscribed Checkers or to request checks less frequently.


To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
