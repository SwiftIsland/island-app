require './constants'
require './bitrise_ci'
require 'xcodeproj'
require 'fastlane_core'

def isBuildTagged?
    BitriseCI.tag?
end

def isDeployable?
    BRANCHES_DEPLOY.include?(BitriseCI.branch) && !BitriseCI.pull_request?
end

def run_codecov(options)
  if ENV['CODECOV_TOKEN']
      codecov(codecov_package: 'SwiftIsland')
  else
      FastlaneCore::UI.important("Skipping codecov - Missing ENV['CODECOV_TOKEN']")
  end
end