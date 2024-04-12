#!/bin/bash

# SMTP server details
SMTP_SERVER="smtp.datagix.net"
SMTP_PORT="587"
SMTP_USER="your_smtp_username"
SMTP_PASSWORD="your_smtp_password"

# Email details
EMAIL_FROM="your_email@example.com"
EMAIL_TO="noc@datagix.com,noc@oxxodata.com"
EMAIL_SUBJECT="VM Information"
VM_IP=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)

# Construct email body
EMAIL_BODY="IP of the VM: $VM_IP\nHostname: $HOSTNAME"

# Send email using mailx command with SMTP authentication
echo -e "$EMAIL_BODY" | mailx \
    -S smtp="smtp://$SMTP_SERVER:$SMTP_PORT" \
    -S smtp-use-starttls \
    -S smtp-auth=login \
    -S smtp-auth-user="$SMTP_USER" \
    -S smtp-auth-password="$SMTP_PASSWORD" \
    -r "$EMAIL_FROM" \
    -s "$EMAIL_SUBJECT" \
    "$EMAIL_TO"
