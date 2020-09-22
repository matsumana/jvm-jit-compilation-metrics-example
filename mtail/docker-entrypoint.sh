#!/bin/sh

LOG_FILE=/app/jvm-unified-log/jit-compilation.log

# Exit if the log file doesn't exist
if [ ! -e $LOG_FILE ]; then
  echo "Can't find $LOG_FILE"
  exit 1
fi

# Need to use `exec`. otherwise shutdown signal can't reach to mtail
exec /mtail/bin/mtail --progs=/mtail/conf/jvm-jit-compilation.mtail --logs=$LOG_FILE --logtostderr
