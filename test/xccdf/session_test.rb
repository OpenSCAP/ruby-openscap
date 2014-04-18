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

require 'test/unit'
require 'openscap'

class TestSession < Test::Unit::TestCase
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

  def test_session_export_rds
    s = OpenSCAP::Xccdf::Session.new("../data/sds-complex.xml")
    s.load
    s.evaluate
    s.export_results(rds_file="report.rds.xml")
    assert Dir.glob("*").size == 1
    assert Dir.glob("*").include?("report.rds.xml")
  end

  def setup
    workdir = "test/output"
    FileUtils.rm_rf workdir
    Dir.mkdir workdir
    Dir.chdir workdir
  end

  def cleanup
    Dir.chdir "../.."
    OpenSCAP.raise! if OpenSCAP.error?
  end
end
