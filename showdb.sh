DBNAME=isudb
TABLES=`mysql $DBNAME -N -e 'show tables'`

for tablename in $TABLES; do
    rowcount=`mysql $DBNAME -N -e "select count(*) from $tablename"`
    echo $tablename count:$rowcount
    mysql $DBNAME --table -e "desc $tablename"
    mysql $DBNAME --table -e "show indexes in $tablename"
done