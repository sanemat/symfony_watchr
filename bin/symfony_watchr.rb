# Run me with:
#
#   $ watchr bin/symfony_watchr.rb

# --------------------------------------------------
# Convenience Methods
# --------------------------------------------------
require 'rubygems'
require 'screenout'
Screenout::statusline = "%{= wb} %-w%{=bu dr}%n %t%{-}%+w %= %{=b wk} %{=b wb}%Y-%m-%d %{=b wm}%c"
def run(cmd)
  Screenout::message('Testing', :black)
  puts(cmd)
  str = `#{cmd}`
  puts(str)
  message = parse(str)
  Screenout::message(message[:message], message[:color])
end

def parse(string)
  if /All tests successful/ =~ string
    {:message => 'All Green', :color => :green}
  else
    {:message => 'Failed', :color => :red}
  end
end
def run_unit_tests
  cmd = "php symfony test:unit"
  run(cmd)
end
def run_functional_tests(application)
  cmd = "php symfony test:functional %s" % application
  run(cmd)
end
def run_all_tests
  cmd = "php symfony test:all"
  run(cmd)
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch ( '^test.*/unit/.*\.php' ) {|m| run_unit_tests }
watch ( '^test.*/functional/(.*)/.*\.php' ) {|m| run_functional_tests(m[1]) }
watch ( '^lib.*/model/.*\.php' ) {|m| run_unit_tests }
#watch( '^test.*/test_.*\.rb'   )   { |m| run( "ruby -rubygems %s"              % m[0] ) }
#watch( '^lib/(.*)\.rb'         )   { |m| run( "ruby -rubygems test/test_%s.rb" % m[1] ) }
#watch( '^lib/.*/(.*)\.rb'      )   { |m| run( "ruby -rubygems test/test_%s.rb" % m[1] ) }
#watch( '^test/test_helper\.rb' )   { run_all_tests }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }
