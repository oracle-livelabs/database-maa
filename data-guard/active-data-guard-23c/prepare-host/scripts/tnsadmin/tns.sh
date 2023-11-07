L_resId=$(echo $HOSTNAME | awk -F\- '{print $2}')
L_pdb="mypdb"
L_types="rw ro snap"
L_hosts="adghol0-${L_resId} adghol1-${L_resId}"
L_domain=$(dnsdomainname)

for L_type in ${L_types} ; do
cat <<EOF

${L_pdb}_${L_type}.${L_domain} =
  (DESCRIPTION =
    (CONNECT_TIMEOUT=240)(RETRY_COUNT=150)(RETRY_DELAY=2)
    (TRANSPORT_CONNECT_TIMEOUT=3)
EOF

for L_host in $L_hosts ; do
cat <<EOF
    (ADDRESS_LIST =
      (LOAD_BALANCE=on)
      (ADDRESS=(PROTOCOL=TCP)(HOST=${L_host}.${L_domain})(PORT=1521)))
EOF
done
cat <<EOF
    (CONNECT_DATA=(SERVICE_NAME = ${L_pdb}_${L_type}.${L_domain})))
EOF


done
