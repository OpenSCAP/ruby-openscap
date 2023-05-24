# frozen_string_literal: true

require 'openscap'
require 'openscap/source'
require 'common/testcase'

class TestSource < OpenSCAP::TestCase
  def test_source_new_nil
    msg = nil
    begin
      OpenSCAP::Source.new(nil)
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?('No filename specified!'), "Message was: #{msg}"
  end

  def test_source_new_ok
    s = OpenSCAP::Source.new('../data/xccdf.xml')
    s.destroy
  end

  def test_source_new_memory
    raw_data = File.read('../data/xccdf.xml')
    refute raw_data.empty?
    s = OpenSCAP::Source.new(content: raw_data, path: '/mytestpath')
    s.destroy
  end

  def test_type_xccdf
    s = OpenSCAP::Source.new('../data/xccdf.xml')
    assert s.type == 'XCCDF Checklist', "Type was #{s.type}"
    s.validate!
    s.destroy
  end

  def test_type_sds
    s = OpenSCAP::Source.new('../data/sds-complex.xml')
    assert s.type == 'SCAP Source Datastream', "Type was #{s.type}"
    s.validate!
    s.destroy
  end

  def test_type_test_result
    s = OpenSCAP::Source.new('../data/testresult.xml')
    assert s.type == 'XCCDF Checklist', "Type was #{s.type}"
    s.validate!
    s.destroy
  end

  def test_validate_invalid
    s = OpenSCAP::Source.new('../data/invalid.xml')
    msg = nil
    begin
      s.validate!
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?('Invalid XCCDF Checklist (1.2) content in ../data/invalid.xml.'),
           "Message was: #{msg}"
    assert msg.include?("../data/invalid.xml:3: Element '{http"),
           "Message was: #{msg}"
    assert msg.include?('This element is not expected. Expected is'),
           "Message was: #{msg}"
    s.destroy
  end

  def test_save
    s = OpenSCAP::Source.new('../data/testresult.xml')
    filename = './newly_created.xml'
    assert !File.exist?(filename)
    s.save(filename)
    assert File.exist?(filename)
    FileUtils.rm_rf filename
  end
end
