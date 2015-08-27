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

require 'common/testcase'
require 'openscap'
require 'openscap/ds/sds'
require 'openscap/source'
require 'openscap/xccdf/benchmark'

class TestBenchmark < OpenSCAP::TestCase
  def test_new_from_file
    b = benchmark_from_file
    b.destroy
  end

  def test_new_from_sds
    @s = OpenSCAP::Source.new '../data/sds-complex.xml'
    sds = OpenSCAP::DS::Sds.new @s
    bench_source = sds.select_checklist!
    assert !bench_source.nil?
    b = OpenSCAP::Xccdf::Benchmark.new bench_source
    assert !b.nil?
    b.destroy
    sds.destroy
  end

  def test_new_from_wrong
    @s = OpenSCAP::Source.new '../data/testresult.xml'
    msg = nil
    begin
      OpenSCAP::Xccdf::Benchmark.new @s
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?('Failed to import XCCDF content from'), msg
  end

  def test_items_in_benchmark
    b = benchmark_from_file
    assert b.items.size == 138
    rules_count = b.items.count { |_, i| i.is_a?(OpenSCAP::Xccdf::Rule) }
    groups_count = b.items.count { |_, i| i.is_a?(OpenSCAP::Xccdf::Group) }
    assert rules_count == 76, "Got #{rules_count} rules"
    assert groups_count == 62, "Got #{groups_count} groups"
  end

  def test_items_title
    b = benchmark_from_file
    prelink_rule = b.items['xccdf_org.ssgproject.content_rule_disable_prelink']
    assert prelink_rule.title == 'Prelinking Disabled', prelink_rule.title
    b.destroy
  end

  private

  def benchmark_from_file
    source = OpenSCAP::Source.new '../data/xccdf.xml'
    b = OpenSCAP::Xccdf::Benchmark.new source
    source.destroy
    assert !b.nil?
    b
  end
end
