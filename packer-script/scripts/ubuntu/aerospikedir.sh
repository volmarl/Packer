/^### END INIT INFO.*/a\
    if [ ! -d /var/run/aerospike ]; then \
        mkdir /var/run/aerospike \
        chmod 0755 /var/run/aerospike \
    fi \
