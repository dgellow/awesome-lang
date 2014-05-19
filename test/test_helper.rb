require 'minitest/reporters'
reporter = Minitest::Reporters::DefaultReporter.new
Minitest::Reporters.use! reporter
require 'minitest/autorun'
