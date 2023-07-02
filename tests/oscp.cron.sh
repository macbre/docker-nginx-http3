#!/bin/sh

#https://kn007.net/topics/let-nginx-support-ocsp-stapling-when-using-boringssl/
openssl ocsp -no_nonce \
             -CAfile /path/to/root.crt \
             -VAfile /path/to/root.crt \
             -issuer /path/to/issuer.crt \
             -cert /path/to/server.crt \
             -respout /path/to/ocsp.resp \
             -url "$(openssl x509 -in /path/to/bundle.crt -text | grep "OCSP - URI:" | cut -d: -f2,3)" \
             > /tmp/ocsp.reply 2>&1

at $(date -d "$(cat /tmp/ocsp.reply | grep 'Next Update: ' | awk -F': ' '{print $2}') + 1 minutes" +"%H:%M %Y-%m-%d") < ~/ocsp.cron.sh

service nginx reload

exit