require 'awesome_print'
require 'octokit'
require 'json'


puts "environments  from yml #{ENV['INPUT_PACKAGE-NAME']}"
puts "workspace path #{ENV['GITHUB_WORKSPACE']}"
puts "workspace all directories #{Dir['*']}"
puts "current working directory #{Dir.pwd}"

require_relative "#{ENV['GITHUB_WORKSPACE']}/#{ENV['INPUT_PACKAGE-NAME']}/lib/#{ENV['INPUT_PACKAGE-NAME']}/version"

client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])

org_query = <<-GRAPHQL
query {
  organization(login: "#{ENV['INPUT_ORGANISATION-NAME']}") {
    registryPackages(name: "#{ENV['INPUT_PACKAGE-NAME']}", first: 100){
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
  repository(owner: "#{ENV['OWNER']}",name: "#{ENV['INPUT_REPO-NAME']}") {
    registryPackages(name: "#{ENV['INPUT_PACKAGE-NAME']}", first: 100){
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

is_org = (!"#{ENV['INPUT_ORGANISATION-NAME']}".nil? && !"#{ENV['INPUT_ORGANISATION-NAME']}".empty?)
response = client.post '/graphql', {query: "#{(is_org ? org_query : repo_query)}"}.to_json
ap response
version_to_be_deleted = Kernel.const_get("#{ENV['INPUT_PACKAGE-NAME']}".capitalize)::VERSION
puts "version to be deleted  #{version_to_be_deleted}"
version_obj = response[:data][(is_org ? :organization : :repository)][:registryPackages][:nodes][0][:versions][:nodes].find {|x| x[:version].to_s == version_to_be_deleted.to_s}
puts "version object #{version_obj}"
if !version_obj.nil?
puts " inside if version present check with query #{mutation}"
  mutation = <<-GRAPHQL
mutation {
  deletePackageVersion (input:{packageVersionId: #{version_obj[:id]}}){
     success
   }
 }
GRAPHQL
  puts " inside if version present check with query #{mutation}"
  mutation_response = client.post '/graphql', {query: mutation}.to_json
  
  mutation_response

end




