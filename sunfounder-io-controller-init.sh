#!/bin/bash
#/etc/init.d/sunfounder-io-controller

### BEGIN INIT INFO
# Provides: embbnux
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: sunfounder-io-controller initscript
# Description: This server is used to manage a controller
### END INIT INFO

case "$1" in
    start)
        echo "Starting sunfounder-io-controller"
        sunfounder-io-controller &
        ;;
    stop)
        echo "Stopping sunfounder-io-controller"
        kill $(ps aux | grep -m 1 'sunfounder-io-controller' | awk '{print $2}')
        ;;
    *)
        echo "Usage: sudo /etc/init.d/sunfounder-io-controller start|stop"
        exit 1
        ;;
esac
exit 0
