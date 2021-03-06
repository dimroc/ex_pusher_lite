defmodule ExPusherLite.EventsController do
  use ExPusherLite.Web, :controller
  use Guardian.Phoenix.Controller

  plug ExPusherLite.Authentication

  def create(conn, %{"app_slug" => app_slug, "event" => event, "topic" => topic, "scope" => scope} = params, _user, _claims) do
    message = (params["payload"] || "{}") |> Poison.decode!
    topic_event =
      if topic == "#general" do
        event
      else
        "#{topic}:#{event}"
      end
    ExPusherLite.Endpoint.broadcast! "#{scope}:#{app_slug}", topic_event, message
    json conn, %{}
  end
end
