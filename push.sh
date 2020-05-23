#!/bin/bash
dt="Source updated: "`date "+%Y-%m-%d %H:%M:%S"`
git add .
git commit -m "$dt"
git push origin