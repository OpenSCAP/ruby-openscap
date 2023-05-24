# frozen_string_literal: true

require 'openscap'
require 'openscap/source'
require 'openscap/ds/sds'
require 'common/testcase'

class TestSds < OpenSCAP::TestCase
  def test_new
    new_sds.destroy
  end

  def test_new_non_sds
    filename = '../data/xccdf.xml'
    @s = OpenSCAP::Source.new filename
    assert !@s.nil?
    msg = nil
    begin
      OpenSCAP::DS::Sds.new source: @s
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?('Could not create Source DataStream session: File is not Source DataStream.'), msg
  end

  def test_select_checklist
    sds = new_sds
    benchmark = sds.select_checklist!
    assert !benchmark.nil?
    sds.destroy
  end

  def test_show_guides
    sds = new_sds
    benchmark_source = sds.select_checklist!
    benchmark = OpenSCAP::Xccdf::Benchmark.new benchmark_source
    benchmark.profiles.each_key do |id|
      guide = sds.html_guide id
      assert !guide.nil?
      assert guide.include?(id)
    end
    benchmark.destroy
    sds.destroy
  end

  def tests_select_checklist_wrong
    sds = new_sds
    msg = nil
    begin
      benchmark = sds.select_checklist! datastream_id: 'wrong'
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?('Failed to locate a datastream with ID matching'), msg
    assert benchmark.nil?
    sds.destroy
  end

  private

  def new_sds
    filename = '../data/sds-complex.xml'
    @s = OpenSCAP::Source.new filename
    assert !@s.nil?
    sds = OpenSCAP::DS::Sds.new source: @s
    assert !sds.nil?
    sds
  end
end
