#
# Copyright (c) 2014 Red Hat Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
#

require 'openscap'
require 'common/testcase'

class TestSession < OpenSCAP::TestCase
  def test_session_new_bad
    msg = nil
    begin
      s = OpenSCAP::Xccdf::Session.new("")
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("Unable to open file: ''")
  end

  def test_sds_true
    s = OpenSCAP::Xccdf::Session.new("../data/sds-complex.xml")
    assert s.sds?
  end

  def test_sds_false
    s = OpenSCAP::Xccdf::Session.new("../data/xccdf.xml")
    assert ! s.sds?
  end

  def test_session_load
    s = OpenSCAP::Xccdf::Session.new("../data/sds-complex.xml")
    s.load
    s.evaluate
  end

  def test_session_load_ds_comp
    s = OpenSCAP::Xccdf::Session.new("../data/sds-complex.xml")
    s.load(datastream_id:"scap_org.open-scap_datastream_tst2", component_id:"scap_org.open-scap_cref_second-xccdf.xml2")
    s.evaluate
  end

  def test_session_load_bad_datastream
    s = OpenSCAP::Xccdf::Session.new("../data/sds-complex.xml")
    msg = nil
    begin
      s.load(datastream_id:"nonexistent")
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("Failed to locate a datastream with ID matching 'nonexistent' ID and checklist inside matching '<any>' ID.")
  end

  def test_session_load_bad_component
    s = OpenSCAP::Xccdf::Session.new("../data/sds-complex.xml")
    msg = nil
    begin
      s.load(component_id:"nonexistent")
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("Failed to locate a datastream with ID matching '<any>' ID and checklist inside matching 'nonexistent' ID.")
  end

  def test_session_set_profile
    s = OpenSCAP::Xccdf::Session.new("../data/sds-complex.xml")
    s.load(component_id:"scap_org.open-scap_cref_second-xccdf.xml")
    s.profile = "xccdf_moc.elpmaxe.www_profile_1"
    s.evaluate
  end

  def test_session_set_profile_bad
    s = OpenSCAP::Xccdf::Session.new("../data/sds-complex.xml")
    s.load
    msg = nil
    begin
      s.profile = "xccdf_moc.elpmaxe.www_profile_1"
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("No profile 'xccdf_moc.elpmaxe.www_profile_1' found")
  end

  def test_session_export_rds
    s = OpenSCAP::Xccdf::Session.new("../data/sds-complex.xml")
    s.load
    s.evaluate
    s.export_results(rds_file:"report.rds.xml")
    assert Dir.glob("*").size == 1
    assert Dir.glob("*").include?("report.rds.xml")
  end
end
