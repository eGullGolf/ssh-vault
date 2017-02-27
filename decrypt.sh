#!/bin/sh
# Decrypt Base64 data from the vault to standard output
#
# Parameter:
#   $1 - string, name of the file to read in the vault, in safe/ subfolder.
#        The extension '.encrypted' is added to this name automatically.
#        Alternatively, the relative path to the file to decrypt may be given
#        directly, e.g. 'safe/private.file.encrypted'.
#
cd "$(dirname "$0")"

if test -z "$1"
then
  echo 'Usage: ./decrypt.sh nameOrPath | less'
  exit 1
fi

case "$1" in
  'safe/'*'.encrypted'|'./safe/'*'.encrypted')
    encryptedFilePath="$1"
  ;;
  *)
    encryptedFileName="$1"
    encryptedFilePath="safe/$encryptedFileName.encrypted"
  ;;
esac

# load config
. ./config.sh

# decrypt symmetrical key |
# decrypt file from the vault
./keys/decrypt-keypass.sh |
openssl enc -d "-$symCypher" \
  -base64 \
  -in "$encryptedFilePath" \
  -pass stdin \

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
