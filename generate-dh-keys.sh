#!/bin/sh
# Copyright 2019 The Morning Consult, LLC or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may
# not use this file except in compliance with the License. A copy of the
# License is located at
#
#         https://www.apache.org/licenses/LICENSE-2.0
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.

set -e 

ROOT=$( cd "$( dirname "${0}" )/.." && pwd )
ROOT=$(pwd)
TEMPDIR="${ROOT}/$( mktemp -d generate-dh-keys.XXXXXX )"
echo "ROOT=$ROOT"
echo "TEMPDIR=[$TEMPDIR]"
cd "${TEMPDIR}"
echo "$ROOT"
cat <<EOF > main.go
package main

import (
	"encoding/base64"
	"io/ioutil"
	"encoding/json"
	"log"

	"github.com/hashicorp/vault/helper/dhutil"
)

const dhpath = "/tmp/test/file-foo-dhpath"

type PrivateKeyInfo struct {
	Curve25519PrivateKey string \`json:"curve25519_private_key"\`
}

func main() {
	pub, pri, err := dhutil.GeneratePublicPrivateKey()
	if err != nil {
		log.Fatal(err)
	}

	mPubKey, err := json.Marshal(&dhutil.PublicKeyInfo{
		Curve25519PublicKey: pub,
	})
	if err != nil {
		log.Fatal(err)
	}

	mPrivKey, err := json.Marshal(&PrivateKeyInfo{
		Curve25519PrivateKey: base64.StdEncoding.EncodeToString(pri),
	})
	if err != nil {
		log.Fatal(err)
	}


	if err := ioutil.WriteFile("DH_PUBLIC_KEY_FILENAME_JINJA2_VAR", mPubKey, 0644); err != nil {
		log.Fatal(err)
	}

	if err := ioutil.WriteFile("DH_PRIVATE_KEY_FILENAME_JINJA2_VAR", mPrivKey, 0644); err != nil {
		log.Fatal(err)
	}
}
EOF


# 
# Note hat either docker or the go compiler and full dev environement have to be installed
# So that we can build the go executable from source code inside [main.go]; 
# GO111MODULE=on go run main.go
# 


# -
# Notes :
# The [dhutil] helper is versioned inside the https://github.com/hashicorp/vault repository.
# I mirrored it to my personal https://github.com/Jean-Baptiste-Lasselle/hashicorp-vault-helper-dhutil/import  
# -  
docker run --rm -v $(pwd)/generate-dh-keys.KXGz0I:/usr/src/myapp -w /usr/src/myapp golang:1.8 sh -c "go get github.com/hashicorp/vault/helper/dhutil && go run main.go"

# cp dh-*-key.json "${ROOT}"

# cd "${ROOT}"

# rm -rf "${TEMPDIR}"

echo "Done. The following Diffie-Hellman keys were created inside [TEMPDIR=$TEMPDIR] :"

ls -allh $TEMPDIR

cp $TEMPDIR/dh-*-key.json "${ROOT}"

cd $ROOT

# find . -name "dh-*-key.json" | grep -v "testdata"
echo "Those Diffie-Hellman symetric keys were copied to [$ROOT]" : 

ls -allh .
