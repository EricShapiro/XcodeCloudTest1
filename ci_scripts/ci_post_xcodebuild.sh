#!/bin/sh

# stop the script on all errors
set -e

# on exit, print "Error" and say "Build error"
function cleanup {
  if [ $? -ne 0 ]; then
    curl http://68.42.67.71:8000/BuildError.txt
  fi
}
trap cleanup EXIT

# Step 1. Can script make network calls?
# Yes! ::ffff:57.103.0.45 - - [14/Aug/2023 16:43:32] "GET /GreetingsFromApple.txt HTTP/1.1" 404 -
# Yes! ::ffff:57.103.0.45 - - [14/Aug/2023 16:43:32] "GET /GreetingsFromApple.txt HTTP/1.1" 404 -
curl http://68.42.67.71:8000/GreetingsFromApple.txt

# Step 2. Can Sparkle run?
./generate_keys
./generate_appcast results
curl http://68.42.67.71:8000/PostSparkle.txt
curl -X POST --data-binary @results/feed.xml http://68.42.67.71:8000

# Step 3. Can hdiutil run?

# Step 4. Done
curl http://68.42.67.71:8000/BuildDone.txt
