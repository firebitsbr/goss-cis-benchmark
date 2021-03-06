#!/bin/bash
#
# 6.2.15 Ensure all groups in /etc/passwd exist in /etc/group
#
# Description:
# Over time, system administration errors and changes can lead
# to groups being defined in /etc/passwd but not in /etc/group.

set -o errexit
set -o nounset

declare i=""
declare status="0"
declare stderr="0"

for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
    grep -q -P "^.*?:[^:]*:$i:" /etc/group || status=1
    if [ ${status} -ne 0 ]; then
        echo "Group ${i} is referenced by /etc/passwd but does not exist in /etc/group"
        stderr="1"
    fi
done

if [ ${stderr} != "0" ]; then
    exit 1
fi
