# frozen_string_literal: true

require 'test_helper'
require 'way_of_working/audit/github'

module WayOfWorking
  module Audit
    class GithubTest < Minitest::Test
      def test_that_it_has_a_version_number
        refute_nil ::WayOfWorking::Audit::Github::VERSION
      end
    end
  end
end
