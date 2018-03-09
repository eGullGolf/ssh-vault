# Configuration of parameters for Encryption and Decryption

# Length of the Symmetrical Key in bits
# (see reference below for maximum size according to size of SSH Public Keys,
# and note that the random key is encoded in hex which doubles the number of
# bytes before the encryption)
# Reference:
# What RSA max block size to encode?
# http://stackoverflow.com/q/11822607
symKeyLength='128'

# Algorithm used for the Symmetric Encryption
symCypher='aes-256-cbc'

# Relative path to the SSH Public Keys used to encrypt Symmetrical Keys
# (in the same format as SSH authorized_keys)
sshPublicKeys='keys/vault.public.ssh.keys'

# Relative path to the Symmetrical Key encrypted with each SSH public key
# (one encrypted key per line, in the same order as authorized_keys)
encryptedSymKeys='keys/vault.sym.keypass.encrypted'

# Absolute path to the SSH private key used for decryption on this machine
sshPrivateKeyUsedToDecrypt="$HOME/.ssh/id_rsa"

# Absolute path to the SSH public key used for encryption on this machine
sshPublicKeyUsedToEncrypt="$sshPrivateKeyUsedToDecrypt.pub"

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
