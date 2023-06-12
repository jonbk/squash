#!/bin/sh

exec /usr/lib64/chromium-browser/chromium-browser-original --disable-site-isolation-trials --disable-dev-shm-usage --disable-gpu --no-sandbox "$@"
