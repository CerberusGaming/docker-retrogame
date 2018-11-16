#!/bin/bash
set -e

if [ ! -f /usr/src/ogame/config/application.properties ]; then
	cp /usr/src/ogame/.application.properties.default /usr/src/ogame/config/application.properties
fi

exec "$@"