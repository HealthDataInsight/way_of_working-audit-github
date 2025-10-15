# frozen_string_literal: true

require 'test_helper'

module WayOfWorking
  module Audit
    module Github
      module Generators
        class ExecTest < Rails::Generators::TestCase
          tests WayOfWorking::Audit::Github::Generators::Exec
          destination File.expand_path('../../../../../tmp', __dir__)

          setup do
            # Set required environment variables
            ENV['GITHUB_TOKEN'] = 'test_token'
            ENV['GITHUB_ORGANISATION'] = 'test_org'

            # Mock Git operations
            mock_git = mock
            mock_git.stubs(:remotes).returns([
              stub(url: 'https://github.com/test_org/test_repo.git')
            ])
            Git.stubs(:open).returns(mock_git)
          end

          teardown do
            # Clean up environment variables
            ENV.delete('GITHUB_TOKEN')
            ENV.delete('GITHUB_ORGANISATION')
          end

          test 'generator has all_repos option' do
            assert generator_class.class_options.key?(:all_repos)
            assert_equal :boolean, generator_class.class_options[:all_repos].type
            assert_equal false, generator_class.class_options[:all_repos].default
          end

          test 'generator has topic option' do
            assert generator_class.class_options.key?(:topic)
            assert_equal :string, generator_class.class_options[:topic].type
            assert_nil generator_class.class_options[:topic].default
          end

          test 'generator has fix option' do
            assert generator_class.class_options.key?(:fix)
            assert_equal :boolean, generator_class.class_options[:fix].type
            assert_equal false, generator_class.class_options[:fix].default
          end

          test 'prep_audit passes fix option to auditor when false' do
            # Mock the auditor
            mock_auditor = mock
            mock_auditor.stubs(:repositories).returns([])

            # Expect Auditor to be initialized with fix=false
            Auditor.expects(:new).with('test_token', 'test_org', false).returns(mock_auditor)

            # Run generator with fix=false (default)
            generator = generator_class.new([], {}, {})
            generator.instance_variable_set(:@github_token, 'test_token')
            generator.instance_variable_set(:@github_organisation, 'test_org')
            generator.prep_audit
          end

          test 'prep_audit passes fix option to auditor when true' do
            # Mock the auditor
            mock_auditor = mock
            mock_auditor.stubs(:repositories).returns([])

            # Expect Auditor to be initialized with fix=true
            Auditor.expects(:new).with('test_token', 'test_org', true).returns(mock_auditor)

            # Run generator with fix=true
            generator = generator_class.new([], { fix: true }, {})
            generator.instance_variable_set(:@github_token, 'test_token')
            generator.instance_variable_set(:@github_organisation, 'test_org')
            generator.prep_audit
          end

          test 'prep_audit filters repositories when all_repos is false' do
            # Mock the auditor
            mock_repo1 = stub(name: 'test_repo', archived?: false)
            mock_repo2 = stub(name: 'other_repo', archived?: false)
            mock_auditor = mock
            mock_auditor.stubs(:repositories).returns([mock_repo1, mock_repo2])

            Auditor.stubs(:new).returns(mock_auditor)

            # Run generator with all_repos=false (default)
            generator = generator_class.new([], {}, {})
            generator.instance_variable_set(:@github_token, 'test_token')
            generator.instance_variable_set(:@github_organisation, 'test_org')
            # Stub the github_organisation_remotes method to return test_repo
            generator.stubs(:github_organisation_remotes).returns(['test_repo'])
            generator.prep_audit

            repositories = generator.instance_variable_get(:@repositories)
            # Should only include test_repo (from git remotes)
            assert_equal 1, repositories.length
            assert_equal 'test_repo', repositories.first.name
          end

          test 'prep_audit does not filter repositories when all_repos is true' do
            # Mock the auditor
            mock_repo1 = stub(name: 'test_repo', archived?: false)
            mock_repo2 = stub(name: 'other_repo', archived?: false)
            mock_auditor = mock
            mock_auditor.stubs(:repositories).returns([mock_repo1, mock_repo2])

            Auditor.stubs(:new).returns(mock_auditor)

            # Run generator with all_repos=true
            generator = generator_class.new([], { all_repos: true }, {})
            generator.instance_variable_set(:@github_token, 'test_token')
            generator.instance_variable_set(:@github_organisation, 'test_org')
            generator.prep_audit

            repositories = generator.instance_variable_get(:@repositories)
            # Should include all repos
            assert_equal 2, repositories.length
          end

          test 'prep_audit filters repositories by topic when topic is specified' do
            # Mock the auditor
            mock_repo1 = stub(name: 'test_repo', archived?: false, topics: ['way-of-working', 'ruby'])
            mock_repo2 = stub(name: 'other_repo', archived?: false, topics: ['python'])
            mock_repo3 = stub(name: 'third_repo', archived?: false, topics: ['way-of-working'])
            mock_auditor = mock
            mock_auditor.stubs(:repositories).returns([mock_repo1, mock_repo2, mock_repo3])

            Auditor.stubs(:new).returns(mock_auditor)

            # Run generator with topic filter
            generator = generator_class.new([], { all_repos: true, topic: 'way-of-working' }, {})
            generator.instance_variable_set(:@github_token, 'test_token')
            generator.instance_variable_set(:@github_organisation, 'test_org')
            generator.prep_audit

            repositories = generator.instance_variable_get(:@repositories)
            # Should only include repos with 'way-of-working' topic
            assert_equal 2, repositories.length
            assert_includes repositories.map(&:name), 'test_repo'
            assert_includes repositories.map(&:name), 'third_repo'
          end
        end
      end
    end
  end
end
