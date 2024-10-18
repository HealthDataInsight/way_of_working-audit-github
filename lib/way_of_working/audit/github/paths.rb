# frozen_string_literal: true

require 'pathname'

module WayOfWorking
  module Audit
    # Mixin that provides a couple of pathname convenience methods
    module Github
      class << self
        def root
          Pathname.new(File.expand_path('../../../..', __dir__))
        end

        def source_root
          root.join('lib', 'way_of_working', 'audit', 'github', 'templates')
        end
      end
    end
  end
end
