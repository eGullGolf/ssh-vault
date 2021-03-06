# ssh-vault
A vault to store encrypted documents, using a list of SSH Public Keys

## Language

Shell

## Platform

Tested on macOS High Sierra,  
running `openssl version`: `LibreSSL 2.2.7`

## Configuration

Copy the list of SSH Public Keys to use for encryption to the file
'vault.public.ssh.keys' in keys/ folder.

Generate the symmetrical key used for encryption of the documents,
and encrypt it with each of the SSH Public Keys in turn (SSH Public
Keys can only encrypt safely small amounts of data directly):

```
keys/create-keys.sh
```

You can modify the list of SSH Public Keys and update the list of encrypted
symmetrical keys (effectively reencrypting the same key with the updated keys)
if you have access to at least one of the private keys needed to decrypt the
symmetrical keys in their current form:

```
keys/update-keys.sh
```

## Usage

Encrypt a document from the clipboard (using `pbpaste`):

```
pbpaste | ./encrypt.sh 'my.document'
```

The document is encrypted to 'safe/my.document.encrypted'.
If you make your own copy of this repository, the encrypted document
can even be added and committed to your git repository.

Decrypt the same document to the clipboard (using 'pbcopy'):

```
./decrypt.sh 'my.document' | pbcopy
```

or

```
./decrypt.sh safe/my.document.encrypted | pbcopy
```

In order to decrypt the file, a private SSH key matching one of the
public SSH keys used for encryption must be found on the local machine.
The location of the local SSH keys can be changed in the file config.sh:

```
# Absolute path to the SSH private key used for decryption on this machine
sshPrivateKeyUsedToDecrypt="$HOME/.ssh/id_rsa"

# Absolute path to the SSH public key used for encryption on this machine
sshPublicKeyUsedToEncrypt="$sshPrivateKeyUsedToDecrypt.pub"
```

## License

Copyright 2017-2018 eGull SAS  
Licensed under the [Apache License, Version 2.0][APACHE2]

[APACHE2]: http://www.apache.org/licenses/LICENSE-2.0
