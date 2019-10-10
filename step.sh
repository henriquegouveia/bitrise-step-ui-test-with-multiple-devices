#!/bin/bash
set -ex

IFS=' ' # space is set as delimiter
read -ra ADDR <<< "$str" # str is read into an array as tokens separated by IFS
for i in "${ADDR[@]}"; do # access each element of array
    echo "$i"
done

COMMAND='xcodebuild  test-without-building -workspace ${workspace_dir_input} -scheme ${scheme_input}'

IFS=',' # comma is set as delimiter
read -ra ADDR <<< "${device_list}" # device_list is read into an array as tokens separated by IFS
for device_name in "${ADDR[@]}"; do # access each element of array
    COMMAND="${COMMAND} -destination 'platform=iOS Simulator,name=$device_name,OS=${os_version}'"
done

COMMAND="${COMMAND" | xcpretty --no-color -r html --output 'Test/test-results.html'"

echo "Executing ${COMMAND}"
eval $COMMAND


#
# --- Export Environment Variables for other Steps:
# You can export Environment Variables for other Steps with
#  envman, which is automatically installed by `bitrise setup`.
# A very simple example:
# envman add --key EXAMPLE_STEP_OUTPUT --value 'the value you want to share'
# Envman can handle piped inputs, which is useful if the text you want to
# share is complex and you don't want to deal with proper bash escaping:
#  cat file_with_complex_input | envman add --KEY EXAMPLE_STEP_OUTPUT
# You can find more usage examples on envman's GitHub page
#  at: https://github.com/bitrise-io/envman

#
# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.
