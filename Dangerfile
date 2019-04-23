# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

# Read log
build_output_file = "build/logs/SwiftIsland-SwittIsand.log"
return unless File.file?(build_output_file)

build_output_log = File.read build_output_file

# Parse log to erros.json
%x(cat #{build_output_file}|bundle exec xcpretty -f `bundle exec xcpretty-json-formatter` &> /dev/null)

# Xcode Summary
build_errors_file = "build/reports/errors.json"
return unless File.file?(build_errors_file)

xcode_summary.report build_errors_file

# Xcode profiler
xcprofiler.inline_mode = false
xcprofiler.thresholds = {
  warn: 300,
  fail: 500
}
xcprofiler.report 'SwiftIsland'