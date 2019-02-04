install_mode chroot

if [ "${MAIN_ARCH}" = "x86" ]; then
	use_linux32
fi

if [ -z "${BASE}" ]; then
	BASE="/opt/ltsp"
fi

if [ -z "${NAME}" ]; then
	NAME="${ARCH}"
fi

if [ -z "${CHROOT}" ]; then
	CHROOT="${BASE}/${NAME}"
fi

if [ -z "${TIMEZONE}" ]; then
	TIMEZONE="$(</etc/timezone)"
fi

chroot_dir $CHROOT
stage_uri="${STAGE_URI}"


# Skip all this
skip partition
skip setup_md_raid
skip setup_lvm
skip format_devices
skip mount_local_partitions
skip mount_network_shares
skip install_bootloader
skip configure_bootloader

tree_type none
logger none
cron none
rootpw password
tree_type none
timezone ${TIMEZONE}
extra_packages ldm ltsp-client ${PACKAGES}


mount_bind() {
	local source="${1}"
	local dest="${2}"

	spawn "mkdir -p ${source}"
	spawn "mkdir -p ${dest}"
	spawn "mount ${source} ${dest} -o bind"
	echo "${dest}" >> /tmp/install.umount
}

post_unpack_stage_tarball() {
		# protecting locale.gen from updating, /etc is set in CONFIG_PROTECT_MASK
		export CONFIG_PROTECT="/etc/locale.gen"

		if [ -n "$LOCALE" ]; then
				echo "LANG=${LOCALE}" >> ${chroot_dir}/etc/env.d/02locale
				grep ${LOCALE} /usr/share/i18n/SUPPORTED > ${chroot_dir}/etc/locale.gen
		else
				if [ -f /etc/env.d/02locale ]; then
					cp /etc/env.d/02locale ${chroot_dir}/etc/env.d/
				fi

				cat > ${chroot_dir}/etc/locale.gen <<- EOF
				en_US ISO-8859-1
				en_US.UTF-8 UTF-8
				EOF
		fi
}

pre_install_portage_tree() {
	# bind mounting portage and binary package dir
	mount_bind "/usr/portage" "${chroot_dir}/usr/portage"
	mount_bind "/usr/portage/packages/${ARCH}" "${chroot_dir}/usr/portage/packages"

	# bind mounting layman, for overlay packages
	mount_bind "/var/lib/layman" "${chroot_dir}/var/lib/layman"

	if [ -n "${MIRRORS}" ]; then
		echo "GENTOO_MIRRORS=\"${MIRRORS}\"" >> ${chroot_dir}/etc/portage/make.conf
	fi

	if [ -n "${INPUT_DEVICES}" ]; then
		echo "INPUT_DEVICES=\"${INPUT_DEVICES}\"" >> ${chroot_dir}/etc/portage/make.conf
	fi

	if [ -n "${VIDEO_CARDS}" ]; then
		echo "VIDEO_CARDS=\"${VIDEO_CARDS}\"" >> ${chroot_dir}/etc/portage/make.conf
	fi

	cat >> ${chroot_dir}/etc/portage/make.conf <<- EOF
	MAKEOPTS="${MAKEOPTS}"
	source /var/lib/layman/make.conf
	EOF

	cat > ${chroot_dir}/etc/fstab <<- EOF
	# DO NOT DELETE
	EOF

	# linking ltsp profile from overlay
	rm ${chroot_dir}/etc/portage/make.profile
	ln -s "/var/lib/layman/ltsp/profiles/default/linux/${MAIN_ARCH}/10.0/ltsp/" "${chroot_dir}/etc/portage/make.profile"
}

pre_build_kernel() {
	if [ -n "${KERNEL_CONFIG_URI}" ]; then
		kernel_config_uri "${KERNEL_CONFIG_URI}"
	fi

	if [ -n "${KERNEL_SOURCES}" ]; then
 		kernel_sources "${KERNEL_SOURCES}"
 	fi

    genkernel_opts --makeopts="${MAKEOPTS}"

	if [ "${CCACHE}" == "true" ]; then
		spawn_chroot "emerge ccache"
		mount_bind "/var/tmp/ccache/${ARCH}" "${chroot_dir}/var/tmp/ccache"

		cat >> ${chroot_dir}/etc/portage/make.conf <<- EOF
		FEATURES="ccache"
		CCACHE_SIZE="4G"
		EOF

		genkernel_opts --makeopts="${MAKEOPTS}" --kernel-cc="/usr/lib/ccache/bin/gcc" --utils-cc="/usr/lib/ccache/bin/gcc"
	fi
}

pre_install_extra_packages() {
	spawn_chroot "emerge --newuse udev"
	spawn_chroot "emerge --update --deep world"
	# emerge python-2.7 to deal with "python_get_implementational_package is not installed" issues
	# these occur when emerging binary packages which are compiled against a new Python version
	spawn_chroot "emerge python:2.7"
}

post_install_extra_packages() {
	# apply localepurge
	spawn_chroot "emerge localepurge"
	cat ${chroot_dir}/etc/locale.gen | awk '{print $1}' > ${chroot_dir}/etc/locale.nopurge
	spawn_chroot "localepurge"
	spawn_chroot "emerge --unmerge localepurge"

	# remove excluded packages
	for package in ${EXCLUDE}; do
		spawn_chroot "emerge --unmerge ${package}"
	done

	# remove possible dependencies of excluded
	spawn_chroot "emerge --depclean"

	# point /etc/mtab to /proc/mounts
	spawn "ln -sf /proc/mounts ${chroot_dir}/etc/mtab"

	# make sure these exist
	mkdir -p ${chroot_dir}/var/lib/nfs
	mkdir -p ${chroot_dir}/var/lib/pulse
	
	# required for openrc's bootmisc
	mkdir -p ${chroot_dir}/var/lib/misc
}
