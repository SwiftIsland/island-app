class BitriseCI 
  
  ENVIRONMENT_VARIABLES = {
    build: 'BITRISE_BUILD_NUMBER',
    branch: 'BITRISE_GIT_BRANCH',
    tag: 'BITRISE_GIT_TAG',
    pull_request: 'BITRISE_PULL_REQUEST',
    pull_request_url: 'BITRISEIO_PULL_REQUEST_REPOSITORY_URL'
  }
  
  class << self
    ## Set all the ENVIROMENT_VARIABLES to actual enviroment variables
    ENVIRONMENT_VARIABLES.each do |key, environment_variable|
        define_method(key) do
            ENV[environment_variable]
        end

        define_method("#{key}?") do
            self.send(key).to_s.length != 0
        end
    end
    
    ## Define wether we are running on a CI or not
    def isCI?
        ENV["CI"].to_s.length != 0
    end
    
    def isReleaseBranch?
      %r{release\/+([0-9]).+([0-9]).+([0-9])}.match(BitriseCI.branch)
    end
    
    def isDevelop?
      BitriseCI.branch == "develop"
    end
    
    def isPullrequest?
      BitriseCI.pull_request != nil && !BitriseCI.isReleaseBranch?
    end
  end
end
