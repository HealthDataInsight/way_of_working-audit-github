# frozen_string_literal: true

require 'way_of_working/cli'
require_relative 'github/paths'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem_extension(WayOfWorking::Audit)
loader.setup

module WayOfWorking
  module Audit
    module Github
      class Error < StandardError; end
    end
  end

  module SubCommands
    # This reopens the "way_of_working exec" sub command
    class Exec
      register(Audit::Github::Generators::Exec, 'audit_github', 'audit_github',
               <<~LONGDESC)
                 Description:
                     This runs the GitHub audit

                 Example:
                     way_of_working exec audit_github
               LONGDESC
    end

    # # This reopens the "way_of_working init" sub command
    # class Init
    #   register(Audit::Github::Generators::Init, 'audit', 'audit',
    # end

    # # This reopens the "way_of_working new" sub command
    # class New
    #   register(Audit::Github::Generators::New, 'audit', 'audit [NAME]',
    # end
  end
end
