# frozen_string_literal: true

require 'openscap'
require 'openscap/ds/arf'
require 'common/testcase'

class TestArf < OpenSCAP::TestCase
  REPORT = 'report.rds.xml'

  def test_arf_new_nil
    msg = nil
    begin
      OpenSCAP::DS::Arf.new(nil)
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("Cannot initialize OpenSCAP::DS::Arf with ''"), 'Message was: ' + msg
  end

  def test_arf_new_wrong_format
    msg = nil
    begin
      OpenSCAP::DS::Arf.new('../data/xccdf.xml')
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.include?('Could not create Result DataStream session: File is not Result DataStream.'),
           'Message was: ' + msg
  end

  def test_create_arf_and_get_html
    arf = new_arf
    html = arf.html
    arf.destroy
    assert html.start_with?('<!DOCTYPE html><html'), 'DOCTYPE missing.'
    assert html.include?('OpenSCAP')
    assert html.include?('Compliance and Scoring')
  end

  def test_create_arf_and_get_profile
    arf = new_arf
    tr = arf.test_result
    assert tr.profile == 'xccdf_moc.elpmaxe.www_profile_1',
           "TestResult.profile was '#{tr.profile}'"
    tr.destroy
    arf.destroy
  end

  def test_new_memory
    create_arf
    raw_data = File.read(REPORT)
    refute raw_data.empty?
    arf = OpenSCAP::DS::Arf.new :content => raw_data, :path => REPORT
    arf.destroy
  end

  def test_new_bz_memory
    bziped_file = new_arf_bz
    raw_data = File.open(bziped_file, 'rb').read
    assert !raw_data.empty?
    len = File.size(bziped_file)
    FileUtils.rm bziped_file
    arf = OpenSCAP::DS::Arf.new :content => raw_data, :path => bziped_file, :length => len
    arf.destroy
  end

  def test_new_bz_file
    bziped_file = new_arf_bz
    arf = OpenSCAP::DS::Arf.new(bziped_file)
    arf.destroy
    FileUtils.rm bziped_file
  end

  private

  def new_arf_bz
    create_arf
    system('/usr/bin/bzip2 ' + REPORT)
    REPORT + '.bz2'
  end

  def new_arf
    create_arf
    OpenSCAP::DS::Arf.new(REPORT)
  end

  def create_arf
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load(:component_id => 'scap_org.open-scap_cref_second-xccdf.xml')
    @s.profile = 'xccdf_moc.elpmaxe.www_profile_1'
    @s.evaluate
    @s.export_results(:rds_file => 'report.rds.xml')
  end
end
