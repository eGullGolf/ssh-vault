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

{
  # Read the SSH public key used to encrypt on this machine
  cat "$sshPublicKeyUsedToEncrypt"
  # make sure that the file ends with a newline
  echo
} |
if read -r thisProtocol thisPublicKey thisComment
then
  # Look whether this SSH Public Key matches any of the keys used to encrypt
  lineNumber=0
  while read -r thatProtocol thatPublicKey thatComment
  do
    lineNumber=$(($lineNumber + 1))
    if test "$thisProtocol $thisPublicKey" = "$thatProtocol $thatPublicKey"
    then
      # Encryption key found on line $lineNumber
      # Read the encrypted Symmetrical Key on the same line
      # Decode it from Base64
      # Decrypt it using the SSH Private Key matching the SSH Public Key
      tail -n "+$lineNumber" "$encryptedSymKeys" |
      head -n 1 |
      base64 --decode |
      openssl rsautl -decrypt \
        -inkey "$sshPrivateKeyUsedToDecrypt"
      break 2
    fi
  done < "$sshPublicKeys"
fi

# ============================================================================
#   Copyright 2017-2018 eGull SAS
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
