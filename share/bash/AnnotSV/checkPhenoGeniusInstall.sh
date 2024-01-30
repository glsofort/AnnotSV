#!/bin/bash


# Bash script: 
# A successfully executed code should exit with code 0. 
# Other values indicate an error. 


# Poetry is required
####################
poetryDir=`which poetry` 

# The "$poetryDir" directory should exist
if [ ! -e "$poetryDir" ]
then
    echo "Poetry seems not to be installed"
    echo "WARNING: No PhenoGenius annotations available."
	exit 1
fi


# Poetry version
################
# poetryVersion=`poetry --version | sed "s/Poetry (version //" | sed "s/)//"`
# e.g. Poetry (version 1.5.1)
# echo "Poetry: $poetryVersion"


# Phenogenius install (if needed)
#################################
mkdir -p $ANNOTSV/share/python3/phenogenius
cd $ANNOTSV/share/python3/phenogenius
if [ ! -d PhenoGenius ]
then
	git clone git@github.com:kyauy/PhenoGenius.git --branch v1.0.0 &> PhenoGenius.install.log
	cd ./PhenoGenius
	rm -rf .git .gitattributes .github .gitignore
    poetry install &> ../poetry_install.log
fi

cd $ANNOTSV/share/python3/phenogenius/PhenoGenius

if [ `poetry run python phenogenius_cli.py --help | grep -c -- "--hpo_list"` ]
then
	exit 0
else
	poetry install &> ../poetry_install.log ;# Can be run from different servers
	if [ `poetry run python phenogenius_cli.py --help | grep -c -- "--hpo_list"` ]
	then
		exit 0
	else
		echo "phenogenius_cli.py not installed"	
		echo "WARNING: No Exomiser annotations available."
		exit 1
	fi
fi

