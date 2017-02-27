#!/bin/sh
# Encrypt data from the standard input into the vault, in Base64
#
# Parameter:
#   $1 - string, name of the file to save in the vault, in safe/ subfolder.
#        The extension '.encrypted' is added to this name automatically.
#
cd "$(dirname "$0")"

if test -z "$1"
then
  echo 'Usage: ./encrypt.sh name < data'
  exit 1
fi

encryptedFileName="$1"
encryptedFilePath="safe/$encryptedFileName.encrypted"

# load config
. ./config.sh

concatPasswordAndStandardInput(){
  # decrypt symmetrical key, put it on first line
  ./keys/decrypt-keypass.sh
  # append the message to encrypt
  cat -
}

# encrypt standard input with given name into the vault
concatPasswordAndStandardInput |
openssl enc "-$symCypher" \
    -pass stdin \
    -out "$encryptedFilePath" \
    -base64
