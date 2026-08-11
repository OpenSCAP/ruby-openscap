# frozen_string_literal: true

require 'openscap'
require 'common/testcase'

class TestSessionDS < OpenSCAP::TestCase
  def test_sds_true
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    assert @s.sds?
  end

  def test_session_load
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load
    @s.evaluate
  end

  def test_session_load_ds_comp
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load(datastream_id: 'scap_org.open-scap_datastream_tst2', component_id: 'scap_org.open-scap_cref_second-xccdf.xml2')
    @s.evaluate
  end

  def test_session_load_bad_datastream
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    msg = nil
    begin
      @s.load(datastream_id: 'nonexistent')
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("Failed to locate a datastream with ID matching 'nonexistent' ID and checklist inside matching '<any>' ID.")
  end

  def test_session_load_bad_component
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    msg = nil
    begin
      @s.load(component_id: 'nonexistent')
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("Failed to locate a datastream with ID matching '<any>' ID and checklist inside matching 'nonexistent' ID.")
  end

  def test_session_set_profile
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load(component_id: 'scap_org.open-scap_cref_second-xccdf.xml')
    @s.profile = 'xccdf_moc.elpmaxe.www_profile_1'
    @s.evaluate
  end

  def test_session_set_profile_bad
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load
    msg = nil
    begin
      @s.profile = 'xccdf_moc.elpmaxe.www_profile_1'
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("No profile 'xccdf_moc.elpmaxe.www_profile_1' found")
  end

  def test_session_export_rds
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load
    @s.evaluate
    @s.export_results(rds_file: 'report.rds.xml')
    assert_exported ['report.rds.xml']
  end

  def test_session_export_xccdf_results
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load(component_id: 'scap_org.open-scap_cref_second-xccdf.xml')
    @s.profile = 'xccdf_moc.elpmaxe.www_profile_1'
    @s.evaluate
    @s.export_results(xccdf_file: 'result.xccdf.xml')
    assert_exported ['result.xccdf.xml']
  end

  def test_session_export_html_report
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load(component_id: 'scap_org.open-scap_cref_second-xccdf.xml')
    @s.profile = 'xccdf_moc.elpmaxe.www_profile_1'
    @s.evaluate
    @s.export_results(report_file: 'report.html', xccdf_file: 'result.xccdf.xml')
    assert_exported ['report.html', 'result.xccdf.xml']
  end

  def test_session_export_oval_variables
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load(component_id: 'scap_org.open-scap_cref_second-xccdf.xml')
    @s.profile = 'xccdf_moc.elpmaxe.www_profile_1'
    @s.evaluate
    @s.export_results(oval_variables: true)
    assert_exported []
  end

  def test_remediate
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load(component_id: 'scap_org.open-scap_cref_second-xccdf.xml')
    @s.profile = 'xccdf_moc.elpmaxe.www_profile_1'
    @s.evaluate
    @s.remediate
  end

  def assert_exported(files)
    # libopenscap compiled with --enable-debug creates debug files
    FileUtils.rm_rf(Dir.glob('oscap_debug.log.*'))
    assert files.sort == Dir.glob('*')
  end
end
