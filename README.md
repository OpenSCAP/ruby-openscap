![ruby-openscap icon](http://isimluk.fedorapeople.org/ruby-OpenSCAP-small.png) ruby-OpenSCAP
=============

Description
-------------
A FFI wrapper around the OpenSCAP library.

Features/problems
-------------
Current version supports minimal set of functions needed to build own scanner. This module
is self documented by its test suite.

Sample Scanner Implementation
-------------

    require 'openscap'
    s = OpenSCAP::Xccdf::Session.new("ssg-fedora-ds.xml")
    s.load
    s.profile = "xccdf_org.ssgproject.content_profile_common"
    s.evaluate
    s.export_results(:rds_file => "results.rds.xml")
    s.destroy

Development Requirements
-------------
On Fedora, command is

    dnf install ruby-devel rubygem-rake rubygem-ffi rubygem-bundler openscap

On RHEL you can install requirements by issuing

    yum install ruby-devel rubygem-rake rubygem-bundler openscap
    gem install ffi # or install rubygem-ffi RPM package from EPEL


Test Requirements
-------------
On Fedora, more packages are necessary, but rubocop can be of the latest version

    dnf install rubygem-minitest rubygem-test-unit rubygems-devel bzip2
    gem install rubocop

For tests on RHEL7, you need minitest package and specific older version of rubocop.
Newer versions of rubocop requires Ruby >= 2.1.0

    yum install rubygem-minitest bzip2
    gem install rubocop -v 0.50.0

Tests are then performed using script

    ./runtest.sh

