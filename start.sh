#!/bin/sh

exec vmstat 1 90 > /tmp/vmstat.log 2>/dev/null &
