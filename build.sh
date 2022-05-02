#!/bin/bash

rpifo=$(echo rpifo-$(cat public/VERSION))

npm run build
cp -r dist $rpifo

tar cvf $rpifo.tar $rpifo
rm -rf $rpifo

cp -r dist/* site
rm -rf site/scripts site/*.sh site/*.py

