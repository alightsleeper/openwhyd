TITLE="Playback errors codes per week"
DB=openwhyd_dump
LISTNAME=list-error-codes-per-week
COLUMNS="Week,Total errors,Code 0,Code 100,Code 150,Timeout,Video playback error,Unrecognized track,Bad key"
FIELDS="_id,value.total,value.0,value.100,value.150,value.timeout,value.video_playback_error,value.unrecognized_track,value.bad key"
OUT=plot-error-codes-per-week

echo "generate data from mongodb data ... (⚠️ may take several minutes)"
# SECONDS=0
# mongo --quiet $DB ./$LISTNAME.mongo.js
# echo ⏲ $SECONDS seconds.
# write resulting collection into output csv file, with custom header row
echo $COLUMNS >$OUT.temp.csv
mongoexport -d $DB -c "$LISTNAME" --type=csv --fields "$FIELDS" | tail -n+2 >>$OUT.temp.csv
sed -i '' -e '$ d' $OUT.temp.csv # remove last line

echo "plot data to ../plots/$OUT.png ..."
mkdir ../plots &>/dev/null
gnuplot -c plot-row-stacked-histogram.gp $OUT.temp.csv "$TITLE" >../plots/$OUT.png

echo "open ../plots/$OUT.png ..."
open ../plots/$OUT.png
# rm $OUT.temp.csv
