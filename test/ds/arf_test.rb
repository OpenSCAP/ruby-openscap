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
require 'openscap/ds/arf'
require 'common/testcase'

class TestSession < OpenSCAP::TestCase
  def test_arf_new_nil
    msg = nil
    begin
      s = OpenSCAP::DS::Arf.new(nil)
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("No filename specified!"), "Message was: " + msg
  end

  def test_arf_new_wrong_format
    msg = nil
    begin
      s = OpenSCAP::DS::Arf.new("data/xccdf.xml")
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?('failed to load external entity "data/xccdf.xml"'), "Message was: " + msg
    assert msg.include?('Could not create Result DataStream session: File is not Result DataStream.'),
        "Message was: " + msg
  end

  def test_create_arf_and_get_html
    arf = new_arf
    html = arf.html
    arf.destroy
    assert html.start_with?('<!DOCTYPE html><html'), "DOCTYPE missing."
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

  private
  def new_arf
    @s = OpenSCAP::Xccdf::Session.new("../data/sds-complex.xml")
    @s.load(:component_id => "scap_org.open-scap_cref_second-xccdf.xml")
    @s.profile = "xccdf_moc.elpmaxe.www_profile_1"
    @s.evaluate
    @s.export_results(:rds_file => "report.rds.xml")
    arf = OpenSCAP::DS::Arf.new("report.rds.xml")
  end
end