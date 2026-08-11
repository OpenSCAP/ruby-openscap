![ruby-openscap icon](http://isimluk.fedorapeople.org/ruby-OpenSCAP-small.png) ruby-OpenSCAP
=============

Description
-------------
A FFI wrapper around the OpenSCAP library.

Features/problems
-------------
Current version supports minimal set of functions needed to build own scanner. This gem
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
On Fedora, commands are

    dnf install openscap
    bundle install


Test Requirements
-------------
On Fedora, more packages are necessary, but rubocop can be of the latest version

    dnf install bzip2

Tests are then performed using script

    ./runtest.sh

