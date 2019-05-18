# frozen_string_literal: true

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
    assert msg.start_with?("Find element 'TestResult' while expecting element: 'Benchmark'"), msg
  end

  def test_items_in_benchmark
    b = benchmark_from_file
    assert b.items.size == 138
    rules_count = b.items.count { |_, i| i.is_a?(OpenSCAP::Xccdf::Rule) }
    groups_count = b.items.count { |_, i| i.is_a?(OpenSCAP::Xccdf::Group) }
    assert rules_count == 76, "Got #{rules_count} rules"
    assert groups_count == 62, "Got #{groups_count} groups"
    b.destroy
  end

  def test_items_title
    b = benchmark_from_file
    prelink_rule = b.items['xccdf_org.ssgproject.content_rule_disable_prelink']
    assert prelink_rule.title == 'Prelinking Disabled', prelink_rule.title
    b.destroy
  end

  def test_items_description
    b = benchmark_from_file
    install_hids_rule = b.items['xccdf_org.ssgproject.content_rule_install_hids']
    expected_result = "\nThe Red Hat platform includes a sophisticated auditing system\nand SELinux, which provide host-based intrusion detection capabilities.\n"
    assert install_hids_rule.description == expected_result, install_hids_rule.description
    b.destroy
  end

  def test_items_rationale
    b = benchmark_from_file
    aide_rule = b.items['xccdf_org.ssgproject.content_rule_package_aide_installed']
    expected_rationale = "\nThe AIDE package must be installed if it is to be available for integrity checking.\n"
    assert aide_rule.rationale == expected_rationale, aide_rule.rationale
    b.destroy
  end

  def test_items_severity
    b = benchmark_from_file
    prelink_rule = b.items['xccdf_org.ssgproject.content_rule_disable_prelink']
    assert prelink_rule.severity == 'Low', prelink_rule.severity
    b.destroy
  end

  def test_items_references
    b = benchmark_from_file
    install_hids_rule = b.items['xccdf_org.ssgproject.content_rule_install_hids']
    expected_references = [{ :title => 'SC-7',
                             :href => 'http://csrc.nist.gov/publications/nistpubs/800-53-Rev3/sp800-53-rev3-final.pdf',
                             :html_link => "<a href='http://csrc.nist.gov/publications/nistpubs/800-53-Rev3/sp800-53-rev3-final.pdf'>SC-7</a>" },
                           { :title => '1263',
                             :href => 'http://iase.disa.mil/cci/index.html',
                             :html_link => "<a href='http://iase.disa.mil/cci/index.html'>1263</a>" }]
    assert_equal(expected_references, install_hids_rule.references.map(&:to_hash), 'Install hids references should be equal')
    b.destroy
  end

  def test_items_fixes
    b = benchmark_from_file
    login_defs_rule = b.items['xccdf_org.ssgproject.content_rule_accounts_minimum_age_login_defs']
    expected_content = ["var_accounts_minimum_age_login_defs=\"<sub xmlns=\"http://checklists.nist.gov/xccdf/1.2\" idref=\"xccdf_org.ssgproject.content_value_var_accounts_minimum_age_login_defs\" use=\"legacy\"/>\"\ngrep -q ^PASS_MIN_DAYS /etc/login.defs &amp;&amp; \\\nsed -i \"s/PASS_MIN_DAYS.*/PASS_MIN_DAYS\\t$var_accounts_minimum_age_login_defs/g\" /etc/login.defs\nif ! [ $? -eq 0 ]\nthen\n  echo -e \"PASS_MIN_DAYS\\t$var_accounts_minimum_age_login_defs\" &gt;&gt; /etc/login.defs\nfi\n"]
    expected_hashes = [{
      :id => nil,
      :platform => nil,
      :content => expected_content.first,
      :system => 'urn:xccdf:fix:script:sh'
    }]
    assert_equal(expected_content, login_defs_rule.fixes.map(&:content), 'Fix content should match')
    assert_equal(expected_hashes, login_defs_rule.fixes.map(&:to_hash), 'Fix hash should match')
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
