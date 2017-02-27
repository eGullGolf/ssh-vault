# Configuration of parameters for Encryption and Decryption

# Length of the Symmetrical Key in bits
# (see reference below for maximum size according to size of SSH Public Keys)
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
