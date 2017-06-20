#!/bin/bash

set -e

function usage()
{
	echo ""
	echo "Usage:"
	echo "./build_deploy.sh"
	echo "	-h --help"
	echo "    --access-key=AWS_ACCESS_KEY_ID"
    echo "    --access-secret=AWS_SECRET_ACCESS_KEY"
    echo "    --edx-platform-repo=CUSTOM_EDX_PLATFORM_REPO"
    echo "    --theme-repo=EDX_CUSTOM_THEME_REPO"
    echo "    --sudo-password=SUDO_PASSWORD"
    echo ""
}

if [[ $# -ne 5 ]]
	then
	usage
	exit 1
fi

while [[ $1 != "" ]]
do
	PARAM=`echo $1 | awk -F= '{print $1}'`
	VALUE=`echo $1 | awk -F= '{print $2}'`

	case $PARAM in
		-h | --help)
			usage
			exit
			;;
		--access-key)
			AWS_ACCESS_KEY_ID=$VALUE
			;;
		--access-secret)
			AWS_SECRET_ACCESS_KEY=$VALUE
			;;
		--edx-platform-repo)
			EDX_PLATFORM=$VALUE
			;;
		--theme-repo)
			EDX_THEME=$VALUE
			;;
		--sudo-password)
			PASSWD=$VALUE
			;;
		*)
			echo "ERROR: unknown parameter \"$PARAM\""
			usage
			exit 1
			;;
	esac
	shift
done

BASE_DIR=$(pwd)

# Set Environment variables
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export EDX_PLATFORM=$EDX_PLATFORM
export EDX_THEME=$EDX_THEME

# Install unzip for ubuntu
echo $PASSWD | sudo -S apt-get update
echo $PASSWD | sudo -S apt-get install unzip

# Install compatible Packer release
curl -L https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_linux_amd64.zip -o /var/tmp/packer.zip
echo $PASSWD | sudo -S unzip -o /var/tmp/packer.zip -d /usr/local/bin

# Build image
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
packer build ${BASE_DIR}/packer/edxapp.json