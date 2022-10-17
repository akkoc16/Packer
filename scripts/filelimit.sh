sudo sh -c "echo 'session required pam_limits.so' >> /etc/pam.d/common-session"
sudo sh -c "echo 'session required pam_limits.so' >> /etc/pam.d/common-session-noninteractive"
sudo sh -c  "cat <<EOT >> /etc/security/limits.conf

root hard nofile $OPEN_FILE_LIMIT
root hard nproc $OPEN_FILE_LIMIT
root soft nofile $OPEN_FILE_LIMIT
root soft nproc $OPEN_FILE_LIMIT


* hard nofile $OPEN_FILE_LIMIT
* hard nproc $OPEN_FILE_LIMIT
* soft nofile $OPEN_FILE_LIMIT
* soft nproc $OPEN_FILE_LIMIT
EOT"

