#!/usr/bin/env bash
curl -s https://raw.githubusercontent.com/BigWigsMods/packager/master/release.sh | bash -s -- -c -d -z
rsync -a --del .release/Informant/libs .