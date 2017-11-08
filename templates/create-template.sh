sed -e ':a;N;$!ba;s/\n/\\n/g' standalone-teiid-sf.xml > standalone-teiid-sf.txt
sed -e "s/\${vdb-xml}/$(<sf-vdb.xml sed -e 's/[\&/]/\\&/g' -e 's/$//' | tr -d '\n')/g" -e "s/\${config-xml}/$(<standalone-teiid-sf.txt sed -e 's/[\&/]/\\&/g' -e 's/$//' | tr -d '\n')/g" teiid-salesforce-db-template.json > teiid-salesforce-db.json
