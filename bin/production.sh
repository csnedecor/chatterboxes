#!/bin/bash

echo "Deploy to production!"
git checkout production && git merge master && git pull origin production && git push origin production && git push production production:master
echo "Deploy Complete"
git checkout master

