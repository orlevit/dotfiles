 #!/bin/bash

CURRENT=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
THRESHOLD=10

if [ "$CURRENT" -gt "$THRESHOLD" ] ; then
    mail -s 'Disk Space Alert' orlevitas@gmail.com << EOF
Openu: Your root partition remaining free space is critically low. Used: $CURRENT%
EOF
fi
