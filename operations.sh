
dockerISRequired () {
  echo "Docker is required to use this recipe. Please install Docker."
  exit 1
}

docker version || dockerISRequired

docker pull golang:1.8

export MY_ORGANIZATION=${MY_ORGANIZATION:-'example-company.com']
if [ "x$DH_PUBLIC_KEY_FILENAME" == "x" ]; then 
  export DH_PUBLIC_KEY_FILENAME=dh-$MY_ORGANIZATION-pub-key.json
fi;
if [ "x$DH_PRIVATE_KEY_FILENAME" == "x" ]; then 
  export DH_PRIVATE_KEY_FILENAME=dh-$MY_ORGANIZATION-priv-key.json
fi;

sed -i "s#DH_PUBLIC_KEY_FILENAME_JINJA2_VAR#$DH_PUBLIC_KEY_FILENAME#g"  ./generate-dh-keys.sh

sed -i "s#DH_PRIVATE_KEY_FILENAME_JINJA2_VAR#$DH_PRIVATE_KEY_FILENAME#g"  ./generate-dh-keys.sh

./generate-dh-keys.sh

