#!/bin/bash
set -u
URL=http://www.ftp.ncep.noaa.gov/data/nccf/com/gfs/prod
wget   -O a.html  $URL
cat a.html | lynx -raw -dump -stdin > a.txt
sed '/tmp/d' < a.txt > b.txt
tr [A-Z] [a-z] < b.txt | grep gfs.  > all.txt
grep 12/ < all.txt > all20.txt
tail -1 < all20.txt > c.txt
tr "]" "\n" < c.txt | tr " " "\n" | tr -d "//" | grep gfs > flive.txt
mkdir /data/days
mkdir /data/bak
rm /data/days/sleep.txt
if [ ! -f "/data/fcped.txt" ]; then
  touch /data/fcped.txt
fi
sort -u < /data/fcped.txt > tmp.tmp
mv tmp.tmp /data/fcped.txt
comm -1 -3 /data/fcped.txt flive.txt > tocp.txt
FDAY=`cat flive.txt`
echo $FDAY
mydl() {
        wget -c -nc -O  $1_$2.grib2   $URL/$FDAY/gfs.t12z.pgrb2.1p00.f$1
}
buquan() {
        cat /data/luoboken.nodel | while read line; do mydl $line ; done
        for dled in *.grib2
        do
           if [ ! -s "$dled" ]
           then
                rm "$dled"
           fi
        done
        if [ -s "000_20.grib2" ]; then
                cat tocp.txt >> /data/fcped.txt
                          tail -31 < /data/fcped.txt > tmp.txt
                          cp tmp.txt /data/fcped.txt
                rm /data/days/*.grib2
                mv *.grib2 /data/days/
                echo $FDAY >  /data/days/today.txt
        fi
}
quanma() {
        if [ ! -s "/data/days/240_20.grib2" ]; then
                buquan
        else
           if [ -s "/data/days/000_20.grib2" ]; then
                cp  /data/days/000_20.grib2  /data/bak/$FDAY.t12z.pgrb2.2p50.f000
                LOG_TIME=`date +%Y%m%d@%H:%M:%S`
                echo $FDAY--$LOG_TIME >  /data/days/sleep.txt
                tail -30 < /data/fcped.txt > tmp.txt
                cp  tmp.txt  /data/fcped.txt
           else
               buquan
           fi
        fi
}
if [ -s "tocp.txt" ]; then
        buquan
        else
        quanma
fi
