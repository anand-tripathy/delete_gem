#!/bin/sh

set -e

sh -c "gem install octokit"
sh -c "gem install json"
sh -c "gem install awesome_print"

sh -c "ruby /action.rb $*"
