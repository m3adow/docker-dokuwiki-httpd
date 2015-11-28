#!/bin/bash
set -e
set -u

DEFAULT_UID=33
DEFAULT_GID=33

usage(){
	printf "Usage: ./%s -u NEW_UID [-f Force, needed if NEW_UID = 0 ]\n" "$0"
}

while getopts ":u:g:f" opt
do
	case $opt in
		u) WWW_UID=${OPTARG}
		;;
		g) WWW_GID=${OPTARG}
		;;
		f) FORCE=1
		;;
		*) usage
		;;
	esac
done
shift $((OPTIND-1))

WWW_UID=${WWW_UID:-${DEFAULT_UID}}
WWW_GID=${WWW_GID:-${DEFAULT_GID}}
FORCE=${FORCE:-0}

if [ ${WWW_UID} -eq ${DEFAULT_UID} ] && [ ${WWW_GID} -eq ${DEFAULT_GID} ]
then
	# printf "Not changing anything.\n"
	:
elif [ ${WWW_UID} -eq 0 ] || [ ${WWW_GID} -eq 0 ] && [ ${FORCE} -ne 1 ]
then
	printf "ID 0 without -f. Won't change anything.\n"
elif [ `id -u` -ne 0 ]
then
	printf "Need root permissions for this script.\n"
else
	if [ "${WWW_UID}" -ne ${DEFAULT_UID} ]
	then
		# printf "Changing UID to %s\n" "${WWW_UID}"
		usermod -u "${WWW_UID}" www-data
		chown -R --from="33" ${WWW_UID} `find /* -maxdepth 0 -path /proc -prune -o -print`
	fi
	if [ "${WWW_GID}" -ne ${DEFAULT_GID} ]
	then
		# printf "Changing GID to %s\n" "${WWW_GID}"
		groupmod -g "${WWW_GID}" www-data
		chown -R --from=":33" :${WWW_GID} `find /* -maxdepth 0 -path /proc -prune -o -print`
	fi
fi
exec "$@"
