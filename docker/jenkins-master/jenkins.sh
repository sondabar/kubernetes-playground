#! /bin/bash

set -e

# Copy files from /usr/share/jenkins/ref into /var/jenkins_home
# So the initial JENKINS-HOME is set with expected content.
# Don't override, as this is just a reference setup, and use from UI
# can then change this, upgrade plugins, etc.
copy_reference_file() {
	f="${1%/}"
	b="${f%.override}"
	echo "$f" >> "${COPY_REFERENCE_FILE_LOG}"
	rel="${b:23}"
	dir=$(dirname "${b}")
	echo " $f -> $rel" >> "${COPY_REFERENCE_FILE_LOG}"
	if [[ ! -e /var/jenkins_home/${rel} || $f = *.override ]]
	then
		echo "copy $rel to JENKINS_HOME" >> "${COPY_REFERENCE_FILE_LOG}"
		mkdir -p "/var/jenkins_home/${dir:23}"
		cp -r "${f}" "/var/jenkins_home/${rel}";
		# pin plugins on initial copy
		[[ ${rel} == plugins/*.jpi ]] && touch "/var/jenkins_home/${rel}.pinned"
	fi;
}
export -f copy_reference_file
touch "${COPY_REFERENCE_FILE_LOG}" || (echo "Can not write to ${COPY_REFERENCE_FILE_LOG}. Wrong volume permissions?" && exit 1)
echo "--- Copying files at $(date)" >> "${COPY_REFERENCE_FILE_LOG}"
find /usr/share/jenkins/ref/ -type f -exec bash -c "copy_reference_file '{}'" \;

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
  exec /bin/bash -c "java ${JAVA_OPTS} -jar /usr/share/jenkins/jenkins.war ${JENKINS_OPTS} $@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"