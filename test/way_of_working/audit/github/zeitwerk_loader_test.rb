# frozen_string_literal: true

require 'test_helper'

module WayOfWorking
  module Audit
    module Github
      class ZeitwerkLoaderTest < Minitest::Test
        def setup
          @root = Pathname.new(File.expand_path('../../../..', __dir__))

          namespace = WayOfWorking::Audit
          @loader = Zeitwerk::Loader.new
          @loader.tag = "#{namespace.name}-github.rb"
          @loader.inflector = Zeitwerk::GemInflector.new(@root.join('lib/way_of_working/audit/github.rb'))
          @loader.push_dir(@root.join('test'))
          @loader.ignore(@root.join('test/test_helper.rb'))
          @loader.setup
        end

        def teardown
          @loader.unload
        end

        def test_eager_load
          @loader.eager_load(force: true)
        rescue Zeitwerk::NameError => e
          flunk "Eager loading failed with error: #{e.message}"
        else
          assert true
        end
      end
    end
  end
end
