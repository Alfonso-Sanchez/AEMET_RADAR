#/bin/bash
#generateGif.sh [-h] [-c province] [-d dir] -e delay -f num_images -o output_dir -- program for generating GIF from AEMET Rain Radar images

#where:
#    -h  show this help text
#    -c  set province value (default: Madrid)
#    -d  set temporary directory to download images (default: /tmp/img)
#        -o set output full path

#provinces:
#        am Almería
#        sa Asturias
#        ba Barcelona
#        cc Cáceres
#        pm Illes Balears
#        ca Las Palmas
#        ma Madrid
#        ml Málaga
#        mu Murcia
#        vd Palencia
#        se Sevilla
#        va Valencia
#        ss Vizcaya

#Change this variables.

PROVINCE=mu
DELAY=30
NUM_IMAGES=30  #MAX IMAGES = 30

./generateGif.sh -c $PROVINCE -d ~/AEMET_RADAR/temp -e $DELAY -f $NUM_IMAGES -o ~/AEMET_RADAR/
