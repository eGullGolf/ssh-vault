#!/bin/sh
# Decrypt and reencrypt the Symmetrical Key using updated SSH Public Keys
#
# Run this script to replace one of the Public SSH keys used for encryption,
# when access to a private key is lost or compromised.
#
# The user running the script must still have access to the private key
# which matches one of the Public SSH keys previously used for the encryption.
#
# The Symmetrical Key is encrypted again, but not modified, which allows
# to keep unchanged the files already encrypted in the safe.
#
# The configuration is identical to the one used in create-keys.sh.
# Check the documentation at the start of create-keys.sh for details.

# Change working directory to the parent folder of the script
# (paths are relative to config.sh there)
cd "$(dirname "$0")"
cd ..

echo 'Load configuration'
. ./config.sh

echo 'Decrypt Symmetrical Key before updating Public SSH Keys'
symKey="$(./keys/decrypt-keypass.sh)"

echo "Empty the file for Encrypted Symmetrical Keys: $encryptedSymKeys"
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
