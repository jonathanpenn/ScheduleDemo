BUILD_DIR             = "/tmp/Schedule"
APP_BUNDLE            = "#{BUILD_DIR}/Schedule.app"
AUTOMATION_TEMPLATE   = "automation/Template.tracetemplate"
RESULTS_PATH          = "automation_results"
OUTPUT_TRACE_DOCUMENT = "#{RESULTS_PATH}/Trace"

# If the automation_results directory isn't there, Instruments balks.
mkdir_p RESULTS_PATH

desc "Remove the automation_results directory and start fresh"
task "clean_results" do
  rm_rf RESULTS_PATH
end

desc "Run tests for iPhone Simulator"
task "default" do
  build

  FileList["automation/test_*.js"].each do |script|
    automate script
  end

  close_sim
  puts "\nWin condition acquired!"
end

desc "Run tests for connected device"
task "device" do
  $is_testing_on_device = true
  Rake::Task["default"].invoke
end

desc "Focused test run. Things in progress."
task "focus" do
  build
  automate "automation/test_session_details.js"

  close_sim

  puts "\nWin condition acquired!"
end


#
# Composable steps
#

def build
  sh %{
    xcodebuild \\
      clean build \\
      -project Schedule.xcodeproj \\
      -configuration Release \\
      -scheme ScheduleUITests \\
      -sdk iphonesimulator \\
      CONFIGURATION_BUILD_DIR="#{BUILD_DIR}"
  }
end

def automate script
  if $is_testing_on_device
    device_uuid = `bin/device_uuid`.strip
    device_arg = "-w #{device_uuid}"
  end

  sh %{
    bin/unix_instruments \\
      #{device_arg} \\
      -t "#{AUTOMATION_TEMPLATE}" \\
      -D "#{OUTPUT_TRACE_DOCUMENT}" \\
      "#{APP_BUNDLE}" \\
      -e UIARESULTSPATH "#{RESULTS_PATH}" \\
      -e UI_TESTS 1 \\
      -e UIASCRIPT "#{script}"
  }
end

def close_sim
  sh %{killall "iPhone Simulator" || true}
end

