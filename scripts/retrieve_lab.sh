#!/bin/bash

function error_branch_not_found()
{
    echo "Le labo ${1} n'existe pas"
    exit 1
}

function error_class_not_found()
{
    echo "Le cours ${1} n'existe pas"
    exit 1
}

function error_not_connected()
{
    echo "Vous n'êtes pas connecté(e) à internet"
    exit 1
}

function git_url()
{
    echo "https://gitlab.com/reds-public/${1}_student.git"
}

function is_connected()
{
    nc -z 8.8.8.8 53 -w 3 > /dev/null
}

function repo_exists()
{
    wget -q --method=HEAD ${1} > /dev/null
    echo $?
}

function repo_branch_exists()
{
    local lines=$(git ls-remote --heads ${1} ${2} | wc -l)
    if [[ ${lines} -eq "0" ]]; then
        echo "1"
    else
        echo "0"
    fi
}

function usage()
{
    echo "Vous devez spécifier le nom du cours et le nom du laboratoire:"
    echo "$1 <course_name> <lab_name>"
    echo "  Ex: $1 sye21 lab01"
    exit 1
}

if [[ -z $2 ]]; then
    usage $0
fi

if [[ ! is_connected ]]; then
    error_not_connected
fi

GIT_REPO=$(git_url $1)

GIT_EXISTS=$(repo_exists ${GIT_REPO})
if [[ ${GIT_EXISTS} -ne "0" ]]; then
    error_class_not_found ${1}
fi

BRANCH_EXISTS=$(repo_branch_exists ${GIT_REPO} ${2})
if [[ ${BRANCH_EXISTS} -ne "0" ]]; then
    error_branch_not_found ${2}
fi

git clone $GIT_REPO --branch ${2} --single-branch ${1}_${2}
