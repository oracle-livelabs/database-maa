echo ##########################
echo Setting the Static Listener Entry
grep SID_LIST_LISTENER $ORACLE_HOME/network/admin/listener.ora || cat <<EOF >> $ORACLE_HOME/network/admin/listener.ora
# add static listener registration for Data Guard and duplicate
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = ${ORACLE_SID})
      (GLOBAL_DBNAME=${ORACLE_UNQNAME}_DGMGRL.$(dnsdomainname))
      (ORACLE_HOME = $ORACLE_HOME)
    )
  )
EOF
cat $ORACLE_HOME/network/admin/listener.ora
lsnrctl reload

echo ##########################
echo Setting the DEFAULT_DOMAIN in sqlnet.ora
grep DEFAULT_DOMAIN $ORACLE_HOME/network/admin/sqlnet.ora || cat <<EOF >> $ORACLE_HOME/network/admin/sqlnet.ora

# add DEFAULT_DOMAIN to resolve unqualified connection strings
NAMES.DEFAULT_DOMAIN=$(dnsdomainname)
EOF

echo ##########################
echo Creating the entries in tnsnames.ora
sh /home/oracle/database-maa/data-guard/active-data-guard-23ai/prepare-host/scripts/tnsadmin/tns.sh > $ORACLE_HOME/network/admin/tnsnames.ora
cat $ORACLE_HOME/network/admin/tnsnames.ora
