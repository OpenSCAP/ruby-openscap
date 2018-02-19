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
On Fedora or RHEL you can install requirements by issuing

    yum install ruby-devel rubygem-ffi rubygem-rake rubygem-bundler openscap

Test Requirements
-------------
For tests on RHEL7, you need minitest package and specific older version of rubocop.

    yum install rubygem-minitest
    gem install rubocop -v 0.42.0

On Fedora, more packages are necessary, but rubocop can be latest version

    dnf install rubygem-minitest rubygem-test-unit rubygems-devel
    gem install rubocop

Tests are then performed using script

    ./runtest.sh

