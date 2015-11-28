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
		u) NUUID=${OPTARG}
		;;
		g) NUGID=${OPTARG}
		;;
		f) FORCE=1
		;;
		*) usage
		;;
	esac
done
shift $((OPTIND-1))

NUUID=${NUUID:-${DEFAULT_UID}}
NUGID=${NUGID:-${DEFAULT_GID}}
FORCE=${FORCE:-0}

if [ ${NUUID} -eq ${DEFAULT_UID} ] && [ ${NUGID} -eq ${DEFAULT_GID} ]
then
	# printf "Not changing anything.\n"
	:
elif [ ${NUUID} -eq 0 ] || [ ${NUGID} -eq 0 ] && [ ${FORCE} -ne 1 ]
then
	printf "ID 0 without -f. Won't change anything.\n"
elif [ `id -u` -ne 0 ]
then
	printf "Need root permissions for this script.\n"
else
	if [ "${NUUID}" -ne ${DEFAULT_UID} ]
	then
		# printf "Changing UID to %s\n" "${NUUID}"
		usermod -u "${NUUID}" www-data
		chown -R --from="33" ${NUUID} `find /* -maxdepth 0 -path /proc -prune -o -print`
	fi
	if [ "${NUGID}" -ne ${DEFAULT_GID} ]
	then
		# printf "Changing GID to %s\n" "${NUGID}"
		groupmod -g "${NUGID}" www-data
		chown -R --from=":33" :${NUGID} `find /* -maxdepth 0 -path /proc -prune -o -print`
	fi
fi
exec "$@"
