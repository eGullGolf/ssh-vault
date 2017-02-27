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

# ============================================================================
#   Copyright 2017 eGull SAS
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
# ============================================================================
