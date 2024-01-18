#!/bin/bash
source /home/pi/auto-wefax/schedule.list
hora=$(date +%R -u)
dia=$(date +%y-%m-%d)
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
    dia=$(date +%y-%m-%d)
    sleep 10
    echo "current workdate set as $hora"
    if [ "$(echo "${schedule[@]}" | grep "$hora")" == "" ]
    then
        echo "No job to do."
    else # comença el proces

        echo "Job found, initating..."
#       htarget=$(array_indexof "${schedule[@]}" $hora)  # | awk '{print substr($1,length($1)-2) }')
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
# PER RTLSDR       
# timeout -k 10 $timeout rtl_fm -f 138881000 -M usb -T -s 48k -d 1 | sox -r 48k -t raw -e s -b 16 -c 1 - -d | timeout -k 10 $timeout fldigi

# Per AirSpy
        timeout -k 10 $timeout airspy-fmradion -t airspyhf -q -m usb -c freq=13881000,hf_att=0 -P - | timeout -k 10 $timeout fldigi
        find /home/pi/.fldigi/images -type f -size +2M -exec mv "{}" /var/www/html/data/wefax-images/ \;
        cname=$(ls -tr /var/www/html/data/wefax-images | tail -n 1)
        cd /var/www/html/data/wefax-images
        ls -tr /var/www/html/data/wefax-images | tail -n 1 | xargs -I{} mv {} "/var/www/html/data/wefax-images/$hora-$dia-wefax.png"
        cd /home/pi/auto-wefax
        convert /var/www/html/data/wefax-images/$hora-$dia-wefax.png -roll +1215+0 /var/www/html/data/wefax-images/$hora-$dia-wefax.png
        rtl_biast -d 0 -b 0

    fi
done
