#!/bin/sh
# Decrypt the Symmetrical Key using a SSH Private Key
# matching one of the SSH Public Keys used for its encryption.
#

# Change working directory to the parent folder of the script
# (paths are relative to config.sh there)
cd "$(dirname "$0")"
cd ..

# load config
. ./config.sh

# Look for one of the SSH Public Keys used for encryption in SSH Agent
ssh-add -L |
while read -r agentProtocol agentPublicKey agentPrivateKey
do
  # Look whether this SSH Public Key matches any of the keys used to encrypt
  lineNumber=0
  while read -r protocol publicKey comment
  do
    lineNumber=$(($lineNumber + 1))
    if test "$agentProtocol $agentPublicKey" = "$protocol $publicKey"
    then
      # Encryption key found on line $lineNumber
      # Read the encrypted Symmetrical Key on the same line
      # Decode it from Base64
      # Decrypt it using SSH Private Key matching the SSH Public Key
      tail -n "+$lineNumber" "$encryptedSymKeys" |
      head -n 1 |
      base64 --decode |
      openssl rsautl -decrypt \
        -inkey "$agentPrivateKey"
      break 2
    fi
  done < "$sshPublicKeys"
done
