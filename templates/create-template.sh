#
# Determine the command line options
#
HA=''

while getopts "t:" opt;
do
	case $opt in
	t) TYPE=$OPTARG ;;
	n) TYPE_NAME=$OPTARG ;;
	h) HA="-ha" ;;
	esac
done

if [ -z "$TYPE" ]; then
  echo "No TYPE specified. Use -t TYPE"
  exit 1
fi

if [ -z "$TYPE_NAME" ]; then
  TYPE_NAME=$TYPE
fi

# inject ra.xml or ds.xml
if [ -f "$TYPE/$TYPE-ra.xml" ]; then
  sed -e "s/<!--resource-adapter-xml-->/$(<$TYPE/$TYPE-ra.xml sed -e 's/[\&/]/\\&/g' -e 's/$//' | tr -d '\n')/g" standalone-teiid${ha}.xml > standalone-teiid.tmp
else
  sed -e "s/<!--datasource-xml-->/$(<$TYPE/$TYPE-ds.xml sed -e 's/[\&/]/\\&/g' -e 's/$//' | tr -d '\n')/g" standalone-teiid${ha}.xml > standalone-teiid.tmp
fi

# remove new lines
sed -e ':a;N;$!ba;s/\n/\\n/g' standalone-teiid.tmp > standalone-teiid-1.tmp
sed -e ':a;N;$!ba;s/\n/\\n/g' $TYPE/$TYPE-vdb.xml > vdb.tmp
# inject vdb

#select or create the base template
TEMPLATE_FILE=$TYPE/teiid-$TYPE-template.json
if [ ! -f "$TEMPLATE_FILE" ]; then
  sed -e "s/#name#/$TYPE/g" -e "s/#full-name#/$TYPE_NAME/g" teiid-template.json > teiid-$TYPE-template.tmp
  TEMPLATE_FILE=teiid-$TYPE-template.tmp
fi

sed -e "s/\${vdb-xml}/$(<vdb.tmp sed -e 's/[\&/]/\\&/g' -e 's/$//' | tr -d '\n')/g" -e "s/\${config-xml}/$(<standalone-teiid-1.tmp sed -e 's/[\&/]/\\&/g' -e 's/$//' | tr -d '\n')/g" $TEMPLATE_FILE > teiid-$TYPE-template.json
rm *.tmp
