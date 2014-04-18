require 'bundler'

Bundler::GemHelper.install_tasks

task :test do
  $LOAD_PATH.unshift('lib')
  Dir.glob('./test/**/*_test.rb') { |f| require f }
end
