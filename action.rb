# require "octokit"
# require "json"
# #
# # Each Action has an event passed to it.
# event = JSON.parse(File.read(ENV['GITHUB_EVENT_PATH']))
# puts event.inspect
#
# # Use GITHUB_TOKEN to interact with the GitHub API
# client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
#
# current_repo = Octokit::Repository.from_url(event["repository"]["html_url"])
#
# # Let's grab all the issues for the current repo
# issues = client.issues(current_repo)
#
# puts "***Printing out this repo's issues***"
# puts issues.inspect


# require "uri"
# require "net/http"
#
# url = URI("https://api.github.com/graphql")
#
# https = Net::HTTP.new(url.host, url.port);
# https.use_ssl = true
#
# request = Net::HTTP::Post.new(url)
# request["Content-Type"] = ["application/vnd.github.packages-preview+json", "application/json"]
# request["Authorization"] = "bearer #{ENV['GITHUB_TOKEN']}"
# request.body = "{\"query\":\"query{organization(login:\\\"yabx-tech\\\"){registryPackages(name:\\\"accounting\\\", first: 100){nodes {versions(last:100){nodes{id version}}}}}}\"}"
#
# response = https.request(request)
# puts JSON.parse(response.read_body)


require 'awesome_print'
require 'octokit'
require 'json'

puts "token from yml #{$2}"
puts "token from github env #{ENV['GITHUB_TOKEN']}"
client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])

org_query = <<-GRAPHQL
query {
  organization(login: "#{$3}") {
    registryPackages(name: "#{$1}", first: 100){
      nodes{
        versions(last:100){
          nodes{
            id
            version
          }
        }
      }
    }
  }
}
GRAPHQL

repo_query = <<-GRAPHQL
query {
  repository(owner: "#{ENV['OWNER']}",name: "#{$4}") {
    registryPackages(name: "#{$1}", first: 100){
      nodes{
        versions(last:100){
          nodes{
            id
            version
          }
        }
      }
    }
  }
}
GRAPHQL

response = client.post '/graphql', { query: "#{(( !$3.nil? && $3.present?) ? org_query : repo_query)}" }.to_json
ap response
