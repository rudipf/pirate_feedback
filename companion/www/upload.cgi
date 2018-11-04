#!/bin/bash

tmpout=/opt/pirate_feedback/pirate_feedback/companion/files/`date '+%Y%m%d%H%M%S'`

cat > $tmpout

echo "Content-type: text/html\n\n"
echo "status: 200\n\n" 
