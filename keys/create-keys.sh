#!/bin/sh
# Create and encrypt the Symmetrical Key using a list of SSH Public Keys
#
# SSH Public Keys can only encrypt short files: an SSH Public Key of 4096 bits
# can only encrypt safely up to 446 bytes of data. This is the reason why we
# create a random symmetrical key for encryption with a length of less than
# 446 bytes, for example 128 bytes, which is used like some kind of binary
# password to encrypt and decrypt files in a symmetrical fashion.
#
# The secret to protect is now this symmetrical encryption key, which shall be
# encrypted separately with each of the SSH authorized keys, to make the
# decryption possible by each matching SSH private key. The decrypted key is
# then used in turn to decrypt the original file, which results in asymmetrical
# encryption and decryption, in two steps.
#
# The configuration is read from the file config.sh found in the parent folder:
#
# - the path to read the list of SSH Public Keys
# - the path to write the list of encrypted symmetrical keys
#
# Each encrypted symmetrical key is stored in Base64 on a different line,
# in the same order as the public SSH keys used for their encryption, as read
# in the configured authorized_keys file.
#
# References:
# [1] Keeping Secrets with OpenSSL
# http://bigthinkingapplied.com/key-based-encryption-using-openssl/
#
# [2] A Guide to Encrypting Files with Mac OS X
# https://gist.github.com/colinstein/de1755d2d7fbe27a0f1e
#
# [3] openssl
# https://www.openssl.org/docs/manmaster/apps/openssl.html
#
# [4] what RSA max block size to encode?
# http://stackoverflow.com/q/11822607

# Change working directory to the parent folder of the script
# (paths are relative to config.sh there)
cd "$(dirname "$0")"
cd ..

echo 'Load configuration'
. ./config.sh

echo "Generate random Symmetrical Key of $symKeyLength bits"
symKey="$(openssl rand "$symKeyLength")"

echo "Create empty file for Encrypted Symmetrical Keys: $encryptedSymKeys"
> "$encryptedSymKeys"

echo 'Encrypt Symmetrical Key with each authorized SSH Public Key in turn'
cat "$sshPublicKeys" |
while read -r protocol sshKey comment
do
  if test -n "$protocol"
  then
    echo "Read $protocol key '$comment'"

    sshPublicKey="$(mktemp)"
    echo "Write SSH Public Key in temporary file $sshPublicKey"
    echo "$protocol $sshKey" > "$sshPublicKey"

    opensslPublicKey="$(mktemp)"
    echo "Convert SSH key to PKCS8 format in temporary file $opensslPublicKey"
    ssh-keygen -e -f "$sshPublicKey" -m PKCS8 > "$opensslPublicKey"
    echo "Encrypt Symmetrical Key using SSH Public Key in PKCS8 format,"
    echo "and append it to $encryptedSymKeys using Base64 encoding"
    echo "$symKey" |
    openssl rsautl -encrypt \
      -pubin -inkey "$opensslPublicKey" |
    base64 >> "$encryptedSymKeys"
    echo "Delete temporary files $sshPublicKey and $opensslPublicKey"
    rm "$sshPublicKey"
    rm "$opensslPublicKey"
  fi
done
