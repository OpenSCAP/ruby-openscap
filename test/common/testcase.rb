# frozen_string_literal: true

require 'test/unit'

module OpenSCAP
  class TestCase < Test::Unit::TestCase
    def setup
      workdir = 'test/output'
      if Dir.pwd.end_with? 'test/output'
        cleanup # Older TestCase do not run cleanup method.
      end
      FileUtils.rm_rf workdir
      Dir.mkdir workdir
      Dir.chdir workdir
      @s = nil
      OpenSCAP.oscap_init
    end

    def cleanup
      @s&.destroy
      Dir.chdir '../..'
      OpenSCAP.raise! if OpenSCAP.error?
      OpenSCAP.oscap_cleanup
    end

    protected

    def assert_default_score(scores, low, high)
      assert scores.size == 1
      s = scores['urn:xccdf:scoring:default']
      assert !s.nil?
      assert s[:system] == 'urn:xccdf:scoring:default'
      assert low < s[:value]
      assert s[:value] < high
      assert s[:max] == 100
    end
  end
end
