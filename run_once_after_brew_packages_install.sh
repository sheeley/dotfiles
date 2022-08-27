#! /usr/bin/env bash

if [ "$VIM" != "" ]; then
    echo "No install within VIM"
    exit 0
fi

cat <<EOS >/opt/homebrew/etc/dovecot/dovecot.conf
mail_home=/srv/mail/%Lu
mail_location=sdbox:~/Mail

## this is sometimes needed
#first_valid_uid = uid-of-vmail-user

# if you want to use system users
passdb {
  driver = pam
}

userdb {
  driver = passwd
  args = blocking=no
  override_fields = uid=vmail gid=vmail
}

ssl=yes
ssl_cert=</path/to/cert.pem
ssl_key=</path/to/key.pem
# if you are using v2.3.0-v2.3.2.1 (or want to support non-ECC DH algorithms)
# since v2.3.3 this setting has been made optional.
#ssl_dh=</path/to/dh.pem

namespace {
  inbox = yes
  separator = /
}

plugin {
  # Use editheader
  sieve_extensions = +copy +body +environment +variables +vacation +relational +imap4flags +subaddress +spamtest +virustest +date +index +editheader +reject +enotify +ihave +mailbox +mboxmetadata +servermetadata +foreverypart +mime +extracttext +include +duplicate +regex 

}
EOS
