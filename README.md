# generate-diffie-hellman-keypair-w-oci

A dockerized recipe to generate diffie hellman key pairs. 

Did that first for use with [hashicorp vault docker credentials helper](https://github.com/morningconsult/docker-credential-vault-login)


# How to use

### Requirements

On the machine you will run this recipe : 

* `Docker` must be installed, 
* and the `golang:1.8` oci images available in the docker context : one of the cofngiured docker registries

### Execute the recipe

Before executing the recipe, be informed that setting the `DH_PUBLIC_KEY_FILENAME` and `DH_PRIVATE_KEY_FILENAME` env. variables will allow you to set the names of the generated key files :

```bash
export MY_ORGANIZATION=mycompany
export DH_PUBLIC_KEY_FILENAME=dh-${MY_ORGANIZATION}-pub-key.json
export DH_PRIVATE_KEY_FILENAME=dh-${MY_ORGANIZATION}-priv-key.json
```

### GNU/Linux , *NIXes

* Those key files will be generated in pwd, as you will check yourself by executing : 

```bash
export OPS_ALIAS=provisioning-something
export OPS_HOME=`mktemp -d --tmpdir diffie.hellman.generation.$OPS_ALIAS.XXXXXX`

# export SSH_URI_TO_RECIPE_REPO=git@github.com:Jean-Baptiste-Lasselle/generate-diffie-hellman-keypair-w-oci.git
# git clone $SSH_URI_TO_RECIPE_REPO $OPS_HOME && cd $OPS_HOME

export THIS_RECIPES_URI=https://github.com/Jean-Baptiste-Lasselle/generate-diffie-hellman-keypair-w-oci.git
git clone $THIS_RECIPES_URI $OPS_HOME && cd $OPS_HOME

chmod +x ./operations.sh
./operations.sh
```
