#!/bin/sh

if [ $# -lt 6 ]; then
   echo "script need 6 parameters"
   exit 1
fi

SHELL_PATH=`pwd -P`

PROJECT=$1
VERSION=$2
SCAN_FOLDER=$3
API_TOKEN=$4
EXCLUDED_FOLDERS=$5
DEPENDENCY=$6

if [ "$SCAN_FOLDER" != "" ] && [ "$(echo "$SCAN_FOLDER" | cut -c1)" != "/" ]; then
    echo "Please input the absolute path!!"
    exit 1
fi

JAVA=$SHELL_PATH/output/tools/Black_Duck_Scan_Installation/scan.cli-0.1.4/jre/bin/java

BLACKDUCK_URL="https://osas.ahnlab.com/"
SORT_MODE="oldest"
NO_DELETE="no_delete"

# choose detector types to exclude (set to --detect.excluded.detector.types)
# NONE,BITBAKE,CARGO,CARTHAGE,COCOAPODS,CONAN,CONDA,CPAN,CRAN,DART,GIT,GO_MOD,GO_DEP,GO_VNDR,GO_VENDER,GO_GRADLE,GRADLE,HEX,IVY,LERNA,MAVEN,NPM,NUGET,PACKAGIST,PEAR,PIP,PNPM,POETRY,RUBYGEMS,SBT,SETUPTOOLS,SWIFT,YARN,CLANG,XCODE
DETECTOR_TYPES="NUGET"

$JAVA -jar $SHELL_PATH/DeleteVersion-1.0.0-jar-with-dependencies.jar \
--blackduck.url=$BLACKDUCK_URL \
--blackduck.api.token=$API_TOKEN \
--detect.project.name="$PROJECT" \
--detect.project.version.name="$VERSION" \
--sort.mode=$SORT_MODE \
--comments.no_delete=$NO_DELETE

$JAVA -jar $SHELL_PATH/blackduck-opensource-scanner.jar \
--blackduck.url=$BLACKDUCK_URL \
--blackduck.api.token=$API_TOKEN \
--blackduck.trust.cert=false \
--executable.java.path=$JAVA \
--blackduck.script.path=$SHELL_PATH \
--detect.accuracy.required=NONE \
--detect.detector.search.depth=20 \
--detect.output.path=$SHELL_PATH/output \
--detect.excluded.directories.search.depth=100 \
--detect.project.name="$PROJECT" \
--detect.project.version.name="$VERSION" \
--detect.source.path=$SCAN_FOLDER \
--detect.excluded.directories=$EXCLUDED_FOLDERS \
--detect.snippet=true \
--detect.clone.project.version.latest=true \
--detect.blackduck.signature.scanner.individual.file.matching=ALL \
--detect.excluded.detector.types=$DETECTOR_TYPES \
--dependency=$DEPENDENCY

$JAVA -jar $SHELL_PATH/InitCustomField-1.0.0-jar-with-dependencies.jar \
--blackduck.url=$BLACKDUCK_URL \
--blackduck.api.token=$API_TOKEN \
--detect.project.name="$PROJECT" \
--detect.project.version="$VERSION" \
--customfield.names.list="Submitter,Open Source Verification Stages" \
--customfield.values.list=",Tool execution completed" \
--customfield.types.list="TEXT,DROPDOWN"

exit 0
