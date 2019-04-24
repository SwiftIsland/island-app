module Fastlane
  module Actions
    class CodecovAction < Action
      def self.run(params)
       
        cmd = ['curl -s https://codecov.io/bash | bash -s --']
        cmd << "-t #{params[:codecov_token]}" if params[:codecov_token]
        cmd << "-J #{params[:codecov_package]}" if params[:codecov_package]

        return sh(cmd.join(' '))
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload your coverage files to Codecov"
      end

      def self.details
        "https://codecov.io"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :codecov_token,
                                       env_name: "CODECOV_TOKEN",
                                       description: "private repository token",
                                       is_string: true,
                                       optional: true
                                       ),
          FastlaneCore::ConfigItem.new(key: :codecov_package,
                                       description: "Specify packages to build coverage. This *significantly* reduces time to build coverage reports",
                                       is_string: true,
                                       optional: true
                                       )
        ]
      end

      def self.output
        []
      end

      def self.return_value
      end

      def self.author
        "Flávio Caetano (@fjcaetano)"
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end