# frozen_string_literal: true

require 'test_helper'

module WayOfWorking
  module Audit
    module Github
      class TestRule < Rules::Base
      end

      class RuleTest < Minitest::Test
        def test_tags
          # Test class method
          assert_equal [:way_of_working], TestRule.tags

          # Test instance method
          client = mock
          name = mock
          repo = stub(full_name: 'test')
          rulesets = mock
          test_rule = TestRule.new(client, name, repo, rulesets)
          assert_equal [:way_of_working], test_rule.tags
        end
      end
    end
  end
end
