#!/bin/sh -e

while getopts "d:r:s:k:p:q:o:" opt; do
	case "$opt" in 
		d) rootdir="$OPTARG";;
		r) rootname="$OPTARG";;
		s) efistub="$OPTARG";;
		k) kerndir="$OPTARG";;
		p) partauuid="$OPTARG";;
		q) partbuuid="$OPTARG";;
		o) outdir="$OPTARG";;
		*) echo "error";exit 1;;
	esac
done
echo "
options:
	rootdir=${rootdir}
	rootname=${rootname}
	kerndir=${kerndir}
	partauuid=${partauuid}
	outdir=${outdir}
"

# if [ $rootname == "" ]; then
# 	rootname="root"
# fi 
# if [ $part == "" ]; then
# 	part="uni"
# fi

rootimg="${rootname}-root.img"
hashimg="${rootname}-hash.img"
#outdir="out"

kerndir="${rootdir}/boot"
# echo $rootdir
# echo $rootimg
# echo $hashimg		
header="${hashimg}.header_info.txt"

# DDI amd64 root partition. Root A in my system
# ROOTA_UUID="d17c04a8-398e-4809-92ee-c7f17f4d6fdb"
# HASHA_UUID="2c7357ed-ebd2-46d9-aec1-23d437ec2bf5"
# ROOTA_PARTUUID="d17c04a8-398e-4809-92ee-c7f17f4d6fdb"

# DDI amd64 /usr partition. Using this for now as
# root B
# ROOTB_UUID="59364898-e253-49e8-bce4-ddc225293b33"
# HASHB_UUID="77ff5f63-e7b6-4633-acf4-1565b864c0e6"
# ROOTB_PARTUUID="59364898-e253-49e8-bce4-ddc225293b33"

echo "part= ${part}"
if  [ "$part" = "a" ] ; then
	# rootpartuuid="d17c04a8-398e-4809-92ee-c7f17f4d6fdb"
	rootpartuuid="$partauuid"

fi

if [ "$part" = "b" ] ; then
    # rootpartuuid="59364898-e253-49e8-bce4-ddc225293b33"
    rootpartuuid="$partbuuid"

fi
# echo rootdev=$rootdev
# echo hashdev=$hashdev

create_part() {
	# generate the root image
	#mkfs.erofs \
	#	--all-root \
	UUID_ARGS="" #"U $rootu "
	mkfs.erofs \
		-zlz4hc \
		-d 0 \
		-L roota \
		$UUID_ARGS		\
		$outdir/$rootimg $rootdir

	# Generate the hash tree
	veritysetup format \
  		--salt 48fb834b564d6763300b00bc6825474a903b026491c686a62be12ad9de82c25f \
		--fec-device="${outdir}/${rootimg}.fec.img" \
		 $outdir/$rootimg $outdir/$hashimg >  "$outdir/${hashimg}.header_info.txt"

	# cat $outdir/$rootimg $outdir/$hashimg > "$outdir/${rootname}-no-fec.img"
	cat $outdir/$hashimg >> $outdir/$rootimg  
	mv  $outdir/$rootimg  "$outdir/${rootname}-no-fec.img"


	# cat  "$outdir/${rootname}-no-fec.img" "${outdir}/${rootimg}.fec.img" >   "$outdir/${rootname}.img"
	cat "${outdir}/${rootimg}.fec.img" >> "$outdir/${rootname}-no-fec.img"
	mv "$outdir/${rootname}-no-fec.img" "$outdir/${rootname}.img"


}
create_boot_part() {
	uki_part=$1
	vmlinuz=$kerndir/bzImage
	if [ ! -f $vmlinuz ]; then 
		return
	fi 
	# efistub=$stub
	if [ ! -f $efistub ]; then 
		return
	fi 

	objcopy_efi_osrel="$rootdir/etc/os-release"
	if [ ! -f "$objcopy_efi_osrel" ];then
		echo "os-release $objcopy_efi_osrel does not exist!"
		exit 1
	fi
	
	objcopy_efi_cmdline="${outdir}/${rootname}.img.cmdline_uki_${uki_part}.txt"
	if [ ! -f "$objcopy_efi_cmdline" ];then
		echo "kernel command-line file $objcopy_efi_cmdline does not exist!"
		exit 1
	fi

	reloc=$(objdump -h -f  "${efistub}" | grep ".reloc" )
	i=0
	for f in $(echo "${reloc}") ; do 
		if [ $i -eq 2 ]; then 
			reloc_size=$f
		elif [ $i -eq 3 ]; then 
			reloc_start=$f
		fi  
		i=$((i+1)) 
	done

	DECEND=$(( $((16#$reloc_start))+$((16#$reloc_size)) )) 
	OSREL_OFFSET=$(printf '%x\n' $DECEND) 
	CMDLINE_OFFSET=$(printf '%x\n' $(( $DECEND+65536)) )
	VMLINUZ_OFFSET=$( printf '%x\n' $((  $((16#$CMDLINE_OFFSET)) +33751040)) )


	objcopy_efi_manifest="
	objcopy_efi_osrel=$objcopy_efi_osrel
	\
	objcopy_efi_cmdline=$objcopy_efi_cmdline
	\
	vmlinuz=$vmlinuz
	\
	efistub=$efistub
	\
	out=${outdir}/${rootname}-vmlinuz-${uki_part}.efi
	\
	"
	
	echo "${objcopy_efi_manifest}" > "${outdir}/${rootname}-vmlinuz-${uki_part}.efi.manifest"
	

	llvm=0
	command -v llvm-objcopy && llvm="1"

	if [ "${llvm}" == "1" ]; then 
		echo "using llvm"
		llvm-objcopy \
			--add-section .osrel="$objcopy_efi_osrel" --set-section-flags .osrel=readonly,data  \
			--add-section .cmdline="$objcopy_efi_cmdline" --set-section-flags .cmdline=readonly,data \
			--add-section .linux="$vmlinuz" --set-section-flags .linux=readonly,data \
			"$efistub" \
			"${outdir}/${rootname}-vmlinuz-${uki_part}.efi"

	else
		echo "using binutils"
		objcopy \
			--add-section .osrel="$objcopy_efi_osrel"  --change-section-vma .osrel="0x"$OSREL_OFFSET \
			--add-section .cmdline="$objcopy_efi_cmdline" --change-section-vma .cmdline="0x"$CMDLINE_OFFSET  \
			--add-section .linux="$vmlinuz" --change-section-vma .linux="0x"$VMLINUZ_OFFSET \
			"$efistub" \
			"${outdir}/${rootname}-vmlinuz-${uki_part}.efi"
	fi
	echo "uki ${outdir}/${rootname}-vmlinuz-${uki_part}.efi created"
	
	
	# if [ -d "$kerndir/secureboot" ]; then
	# 	bwrap --bind / / --bind $kerndir/secureboot /usr/share/secureboot sbctl sign "${outdir}/${rootname}-vmlinuz-${uki_part}.efi"
	# else	
	# 	sbctl sign "${outdir}/${rootname}-vmlinuz-${uki_part}.efi"
	# fi
	

	rm -rf "${outdir}/${rootname}-boot-${uki_part}.img"


	mkdir -p "${outdir}/${rootname}-EFI-${uki_part}"
	# efi_dir="${outdir}/${rootname}-EFI-${uki_part}/LINUX${uki_part}"
	efi_dir="${outdir}/${rootname}-EFI-${uki_part}/Linux"


	rm -rf "${efi_dir}"
	mkdir -p "${efi_dir}"
	the_date="$(date +%Y-%m-%d_%I-%M)"
	# cp "${outdir}/${rootname}-vmlinuz-${uki_part}.efi" "${efi_dir}/${rootname}-vmlinuz-${uki_part}-${the_date}.efi" 
	cp "${outdir}/${rootname}-vmlinuz-${uki_part}.efi" "${efi_dir}/linux.efi" 
	# cp "${outdir}/${rootname}-vmlinuz-${uki_part}.efi" "${efi_dir}/linux-${uki-part}-${the_date}.efi" 

	cp "${outdir}/${rootname}.${uki_part}.img.options_refind.txt" "${efi_dir}/refind_linux.conf"

	ADD_VMLINUZ_FALLBACK=0
	if [ $ADD_VMLINUZ_FALLBACK -eq 1 ]; then
		cp "${efi_dir}"  "${efi_dir}/bzImage-${uki_part}-${the_date}"
	fi 
	
	dd if=/dev/zero of="${outdir}/${rootname}-boot-${uki_part}.img" bs=224M count=1 
	mkfs.vfat "${outdir}/${rootname}-boot-${uki_part}.img"

	rm -rf "${outdir}/EFI"
	cp -r "${outdir}/${rootname}-EFI-${uki_part}"  "${outdir}/EFI"
 	mcopy -s -i "${outdir}/${rootname}-boot-${uki_part}.img" "${outdir}/EFI" ::/
	#rm -rf "${outdir}/EFI"


}
mkdir -p  "${outdir}"



create_part
 

# Parse verity header information for necec
DATA_BLOCKS=$(cat "${outdir}/${header}" | grep "Data blocks:" | cut -f2 ) 
# DATA_BLOCK_SIZE=4096
HASH_BLOCKS=$(cat "${outdir}/${header}" | grep "Hash blocks:" | cut -f2 )
# HASH_BLOCK_SIZE=4096
# HASH_ALGORITHM="sha256"
SALT=$(cat "${outdir}/${header}" | grep "Salt:" | cut -f2 )
ROOT_HASH=$(cat "${outdir}/${header}" | grep "Root hash:" | cut -f2)

#FEC_BLOCKS=$(cat "${outdir}/${header}" | grep "FEC blocks:" | cut -f2)

# ROOT_HASH_DEVICE_SIZE
BLOCKS=$((DATA_BLOCKS*8))

FEC_DEVICE_START=$(($DATA_BLOCKS+$HASH_BLOCKS))

#FEC_BLOCKS_II=$(($FEC_BLOCKS*8))
TABLE="verity,,,ro,0 \
	${BLOCKS} verity 1 /dev/sda /dev/sda 4096 4096 \
	${DATA_BLOCKS} $((DATA_BLOCKS+1)) sha256 \
	${ROOT_HASH} ${SALT} \
	9 ignore_zero_blocks use_fec_from_device /dev/sda fec_roots 2 fec_start ${FEC_DEVICE_START} fec_blocks ${FEC_DEVICE_START}"

CMDLINE="dm-mod.create=\"${TABLE}\" rootfstype=erofs root=/dev/dm-0 init=/usr/bin/dinit"

echo "${CMDLINE}" >  "$outdir/${rootname}.img.cmdline.txt"

dev_refind="PARTUUID=${rootpartuuid}"
dev_refind_a="PARTUUID=${partauuid}"

partbuuidb="bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
dev_refind_b="PARTUUID=${partbuuidb}"


TABLE_METAL="verity,,,ro,0 \
	${BLOCKS} verity 1 ${dev_refind} ${dev_refind}  4096 4096 \
	${DATA_BLOCKS} $((DATA_BLOCKS+1)) sha256 \
	${ROOT_HASH} ${SALT} \
	9 ignore_zero_blocks use_fec_from_device${dev_refind} fec_roots 2 fec_start ${FEC_DEVICE_START} fec_blocks ${FEC_DEVICE_START}"

TABLE_METAL_A="verity,,,ro,0 \
${BLOCKS} verity 1 ${dev_refind_a} ${dev_refind_a} 4096 4096 \
${DATA_BLOCKS} $((DATA_BLOCKS+1)) sha256 \
${ROOT_HASH} ${SALT} \
9 ignore_zero_blocks use_fec_from_device ${dev_refind_a} fec_roots 2 fec_start ${FEC_DEVICE_START} fec_blocks ${FEC_DEVICE_START}"

TABLE_METAL_B="verity,,,ro,0 \
${BLOCKS} verity 1 ${dev_refind_b} ${dev_refind_b} 4096 4096 \
${DATA_BLOCKS} $((DATA_BLOCKS+1)) sha256 \
${ROOT_HASH} ${SALT} \
9 ignore_zero_blocks use_fec_from_device ${dev_refind_b} fec_roots 2 fec_start ${FEC_DEVICE_START} fec_blocks ${FEC_DEVICE_START}"


# EXTRA_CMDLINE="lsm=lockdown,capability,yama,selinux,bpf,landlock,ima,evm"
EXTRA_CMDLINE="debug console=tty1 sysctl.kernel.sysrq=1 raid=noautodetect ro rootwait lsm=lockdown,capability"
# EXTRA_CMDLINE="debug sysctl.kernel.sysrq=1 rootwait lsm=lockdown,capability"


OPTIONS_REFIND="\"boot ${part}\"  \"${EXTRA_CMDLINE} dm-mod.waitfor=${dev_refind} dm-mod.create=\"\"${TABLE_METAL}\"\" rootfstype=erofs root=/dev/dm-0 init=/usr/bin/dinit\""
echo "${OPTIONS_REFIND}"  >  "$outdir/${rootname}.img.options_refind.txt"


OPTIONS_REFIND_A="\"boot a\"  \"rootslot=a  raid=noautodetect rootwait ro ${EXTRA_CMDLINE} dm-mod.waitfor=${dev_refind_a} dm-mod.create=\"\"${TABLE_METAL_A}\"\" rootfstype=erofs root=/dev/dm-0 init=/usr/bin/dinit\""
echo "${OPTIONS_REFIND_A}"  >  "$outdir/${rootname}.a.img.options_refind.txt"


OPTIONS_REFIND_B="\"boot b\"  \"rootslot=b  raid=noautodetect rootwait ro ${EXTRA_CMDLINE} dm-mod.waitfor=${dev_refind_b} dm-mod.create=\"\"${TABLE_METAL_B}\"\" rootfstype=erofs root=/dev/dm-0 init=/usr/bin/dinit\""
echo "${OPTIONS_REFIND_B}"  >  "$outdir/${rootname}.b.img.options_refind.txt"


CMDLINE_UKI_A="rootslot=a ${EXTRA_CMDLINE} dm-mod.waitfor=${dev_refind_a} dm-mod.create=\"${TABLE_METAL_A}\" rootfstype=erofs root=/dev/dm-0 init=/usr/bin/dinit"
echo "${CMDLINE_UKI_A}" > "$outdir/${rootname}.img.cmdline_uki_a.txt"

CMDLINE_UKI_B="rootslot=b ${EXTRA_CMDLINE} dm-mod.waitfor=${dev_refind_b} dm-mod.create=\"${TABLE_METAL_B}\" rootfstype=erofs root=/dev/dm-0 init=/usr/bin/dinit"
echo "${CMDLINE_UKI_B}" > "$outdir/${rootname}.img.cmdline_uki_b.txt"


if [ -f "${efistub}" ]; then
	create_boot_part a
	create_boot_part b

fi




echo "Done! root is "  "$outdir/${rootname}.img"
