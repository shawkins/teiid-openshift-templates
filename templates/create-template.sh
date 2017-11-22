#
# Determine the command line options
#
while getopts "t:" opt;
do
	case $opt in
	t) TYPE=$OPTARG ;;
	esac
done

if [ -z "$TYPE" ]; then
  echo "No TYPE specified. Use -t TYPE"
  exit 1
fi

# inject ra.xml
sed -e "s/\${resource-adapter-xml}/$(<$TYPE/$TYPE-ra.xml sed -e 's/[\&/]/\\&/g' -e 's/$//' | tr -d '\n')/g" standalone-teiid-ha.xml > standalone-teiid.tmp
# remove new lines
sed -e ':a;N;$!ba;s/\n/\\n/g' standalone-teiid.tmp > standalone-teiid-1.tmp
sed -e ':a;N;$!ba;s/\n/\\n/g' $TYPE/$TYPE-vdb.xml > vdb.tmp
# inject vdb
sed -e "s/\${vdb-xml}/$(<vdb.tmp sed -e 's/[\&/]/\\&/g' -e 's/$//' | tr -d '\n')/g" -e "s/\${config-xml}/$(<standalone-teiid-1.tmp sed -e 's/[\&/]/\\&/g' -e 's/$//' | tr -d '\n')/g" $TYPE/teiid-$TYPE-template.json > teiid-$TYPE-template.json
rm *.tmp
