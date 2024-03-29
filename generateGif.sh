#!/bin/bash
DIR_HASSIO=
LST_COMUNITY=(am sa ba cc pm ca ma ml mu vd se va ss za)
NUM_MAX_IMG=30

usage="$(basename "$0") [-h] [-c province] [-d dir] -e delay -f num_images -o output_dir -- program for generating GIF from AEMET Rain Radar images

where:
    -h  show this help text
    -c  set province value (default: Madrid)
    -d  set temporary directory to download images (default: /tmp/img)
	-o set output full path
	
provinces:
	am Almería
	sa Asturias
	ba Barcelona
	cc Cáceres
	pm Illes Balears
	ca Las Palmas
	ma Madrid
	ml Málaga
	mu Murcia
	vd Palencia
	se Sevilla
	va Valencia
	ss Vizcaya
"
DIR_DOWNLOAD=/tmp/img
PROVINCE=ma

while getopts ':hc:e:f:d:o:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    c) PROVINCE=$OPTARG
       ;;
        e) DELAY=$OPTARG
       ;;
        f) NUM_IMAGES=$OPTARG
       ;;
	d) DIR_DOWNLOAD=$OPTARG
       ;;
	o) DIR_HASSIO=$OPTARG
       ;;
    :) printf "!! missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "!! illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

if [ $NUM_IMAGES -gt $NUM_MAX_IMG ]
then
	printf "!! You cant use more than $NUM_MAX_IMG images.\n" >&2
	echo "$usage" >&2
	exit 1
fi

mkdir -p $DIR_DOWNLOAD
rm -f $DIR_DOWNLOAD/*

for (( i=1; i<=$NUM_IMAGES; i++ ))
do
  time=`expr $i \* 10`
  eval $(date -u +Y=%Y\;m=%m\;d=%d\;H=%H\;M=%M -d "$time min ago")
  [[ "$M" < "10" ]] && M=00 # cater for octal clash
  M=$(((M/10)*10))
  ((M==0)) && M=00 # the math returns 0, so make it 00  
  url=http://www.aemet.es/imagenes_d/eltiempo/observacion/radar/${Y}${m}${d}${H}${M}_r8${PROVINCE}.gif
  wget -q -P $DIR_DOWNLOAD $url
done
convert -delay $DELAY -loop 0 -resize 150% $DIR_DOWNLOAD/*.gif $DIR_HASSIO/radar_rain.gif
./imgur.sh $DIR_HASSIO/radar_rain.gif
