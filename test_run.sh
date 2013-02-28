# Tell bash to completely bail on any error
set -e

# Clean out the results directory. Sometimes instruments gets confused and
# reports a "(null)" error. Clean this directory. Then sacrifice a small goat.
rm -rf automation_results
mkdir -p automation_results

xcodebuild \
  clean build \
  -project Schedule.xcodeproj \
  -configuration Release \
  -scheme ScheduleUITests \
  -sdk iphonesimulator \
  CONFIGURATION_BUILD_DIR="/tmp/Schedule"

# Simulator
bin/unix_instruments \
  -t automation/Template.tracetemplate \
  -D automation_results/Trace \
  /tmp/Schedule/Schedule.app \
  -e UIARESULTSPATH automation_results \
  -e UIASCRIPT automation/test_favorites.js \
  -e UI_TESTS 1

# Device
bin/unix_instruments \
  -w `bin/device_uuid` \
  -t automation/Template.tracetemplate \
  -D automation_results/Trace \
  /tmp/Schedule/Schedule.app \
  -e UIARESULTSPATH automation_results \
  -e UIASCRIPT automation/test_favorites.js \
  -e UI_TESTS 1

