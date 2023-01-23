#!/bin/bash
source /home/pi/auto-wefax/schedule.list
hora=$(date +%R -u)

function array_indexof() {
  [ $# -lt 2 ] && return 1
  local a=("$@")
  local v="${a[-1]}"
  unset a[-1]
  local i
  for i in ${!a[@]}; do
    if [ "${a[$i]}" = "$v" ]; then
      echo $i
      return 0
    fi
  done
  return 1
}
containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}
function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

while true 
do 
    hora=$(date +%R -u)
    sleep 10
    echo "current workdate set as $hora"
    if [ "$(echo "${schedule[@]}" | grep "$hora")" == "" ]
    then
        echo "No job to do."
    else
        echo "Job found, initating..."
        htarget=$(array_indexof "${schedule[@]}" $hora)  # | awk '{print substr($1,length($1)-2) }')
        # containsElement "$hora" "${ptimeb[@]}"
        # if [ $(echo $?) == 0 ]; then
        #     echo "20 minuts"
        # containsElement "$hora" "${ptimea[@]}"
        # elif [ $(echo $?) == 0 ]; then
        #     echo "19 minuts"
        # else
        #     echo "11 minuts"
        # fi
        if [ $(contains "${ptimea[@]}" "$hora") == "y" ]; then
            echo "19 minuts"
            timeout=1140
        elif [ $(contains "${ptimeb[@]}" "$hora") == "y" ]; then
            echo "20 minuts"
            timeout=1200
        else
            echo "11 minuts"
            timeout=660
        fi
        timeout $timeout rtl_fm -f 138881000 -M usb -T -s 48k | sox -r 48k -t raw -e s -b 16 -c 1 - -d | timeout $timeout fldigi
    fi
done
