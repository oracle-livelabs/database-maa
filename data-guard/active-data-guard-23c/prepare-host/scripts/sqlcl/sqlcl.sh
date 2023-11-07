sql() {
  # REMOTE source this script
  #
  # . <(curl -s https://gist.githubusercontent.com/krisrice/fec43fd9f53e4286e5cc360b554e3c0f/raw/62ec382d7511c7cc44703a9a2f75a4a7f233efe2/sqlcl.sh)

  # Set the stage directory
  STAGE_DIR=/tmp

  # Check whether internet connection exists
  if ping -c 1 download.oracle.com > /dev/null; then

    # Get current ETAG from download
    ETAG=$(curl -I -s https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip | tr -d '\r'  | sed -En 's/^ETag: (.*)/\1/p')

    echo "REMOTE-ETAG: $ETAG"

    # Compare to last ETag saved
    if [[ -e $STAGE_DIR/sqlcl.etag ]]; then
        CURRENT_ETAG=$(cat $STAGE_DIR/sqlcl.etag)
        echo "LOCAL-ETAG: $CURRENT_ETAG"
    else
        CURRENT_ETAG="none"
    fi

    # Check if ETags match
    if [[ "$ETAG" != "$CURRENT_ETAG" ]]; then
      echo "Downloading..."
      curl -sS -o $STAGE_DIR/sqlcl-latest.zip \
            --header 'If-None-Match: "${CURRENT_ETAG}"' \
            https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip
      echo Unzip....
      echo "$ETAG" > $STAGE_DIR/sqlcl.etag
      echo "Removing old SQLcl"
      rm -rf $STAGE_DIR/sqlcl
      echo Unzipping to $STAGE_DIR/sqlcl
      unzip   -qq -d $STAGE_DIR $STAGE_DIR/sqlcl-latest.zip
    else
      echo "SQLcl is current"
    fi
   else
     echo "Internet connection to download.oracle.com not available."
     if [[ ! -f $STAGE_DIR/sqlcl/bin/sql ]]; then
       echo "SQLcl cannot be downloaded, please check internet connection."
       return 1;
     else
       echo "Cannot verify latest SQLcl version."
     fi
   fi

   # Run SQLcl
   $STAGE_DIR/sqlcl/bin/sql $*
}
