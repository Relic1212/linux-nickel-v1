
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#define DLSYM(sym, prefix) 	\
    if (strcmp(symbol, #sym) == 0) { \
        extern void* prefix##sym; \
		dbg_print("(dlsym) found symbol %s with handle=%p, address=%p\n", symbol, handle, &prefix##sym); \
        return &prefix##sym; \
    }

static char* dbg;
static char dbg_initualilised = 0;

static void dbg_initilialise(){
	dbg = getenv("DL_DEBUG");
	dbg_initualilised = 1;
}
static void dbg_print(const char *s, ...)
{
	if (dbg_initualilised==0){
		dbg_initilialise();
	}

    if (dbg != NULL)
    {
        va_list args;
        va_start(args, s);
        vfprintf(stderr, s, args);
    }
}

extern void *stub_dlopen(const char *, int);
extern void *stub_dlsym(void *__restrict, const char *__restrict);
extern int stub_dladdr(const void *handle, Dl_info *info);

const char* main_program_handle = "main_program";

const char* lib_libbd_swap_so_3 = "lib_libbd_swap_so_3";
const char* lib_libbd_loop_so_3 = "lib_libbd_loop_so_3";
const char* lib_libbd_crypto_so_3 = "lib_libbd_crypto_so_3";
const char* lib_libbd_mdraid_so_3 = "lib_libbd_mdraid_so_3";
const char* lib_libbd_part_so_3 = "lib_libbd_part_so_3";
const char* lib_libbd_fs_so_3 = "lib_libbd_fs_so_3";
const char* lib_libbd_nvme_so_3 = "lib_libbd_nvme_so_3";

void* dlopen(const char *path, int mode) {
	if (path == NULL) { return &main_program_handle; }
	if (strcmp( path, "libbd_swap.so.3" ) == 0) { dbg_print("(dlopen) found library libbd_swap.so.3 (handle=%p)\n", &lib_libbd_swap_so_3); return &lib_libbd_swap_so_3; }
	if (strcmp( path, "libbd_loop.so.3" ) == 0) { dbg_print("(dlopen) found library libbd_loop.so.3 (handle=%p)\n", &lib_libbd_loop_so_3); return &lib_libbd_loop_so_3; }
	if (strcmp( path, "libbd_crypto.so.3" ) == 0) { dbg_print("(dlopen) found library libbd_crypto.so.3 (handle=%p)\n", &lib_libbd_crypto_so_3); return &lib_libbd_crypto_so_3; }
	if (strcmp( path, "libbd_mdraid.so.3" ) == 0) { dbg_print("(dlopen) found library libbd_mdraid.so.3 (handle=%p)\n", &lib_libbd_mdraid_so_3); return &lib_libbd_mdraid_so_3; }
	if (strcmp( path, "libbd_part.so.3" ) == 0) { dbg_print("(dlopen) found library libbd_part.so.3 (handle=%p)\n", &lib_libbd_part_so_3); return &lib_libbd_part_so_3; }
	if (strcmp( path, "libbd_fs.so.3" ) == 0) { dbg_print("(dlopen) found library libbd_fs.so.3 (handle=%p)\n", &lib_libbd_fs_so_3); return &lib_libbd_fs_so_3; }
	if (strcmp( path, "libbd_nvme.so.3" ) == 0) { dbg_print("(dlopen) found library libbd_nvme.so.3 (handle=%p)\n", &lib_libbd_nvme_so_3); return &lib_libbd_nvme_so_3; }
	fprintf(stderr, "(dlopen) WARNING: failed for path %s\n", path);	return stub_dlopen(path, mode);
}

void* dlsym(void *__restrict handle, const char *__restrict symbol) {
	if (handle == &lib_libbd_swap_so_3 || handle == NULL || handle == &main_program_handle) { 
		DLSYM(bd_swap_init, )
		DLSYM(bd_swap_is_tech_avail, )
		DLSYM(bd_swap_mkswap, )
		DLSYM(bd_swap_swapon, )
		DLSYM(bd_swap_swapoff, )
		DLSYM(bd_swap_swapstatus, )
		DLSYM(bd_swap_check_label, )
		DLSYM(bd_swap_set_label, )
		DLSYM(bd_swap_check_uuid, )
		DLSYM(bd_swap_set_uuid, )
	}
	if (handle == &lib_libbd_loop_so_3 || handle == NULL || handle == &main_program_handle) { 
		DLSYM(bd_loop_init, )
		DLSYM(bd_loop_is_tech_avail, )
		DLSYM(bd_loop_info, )
		DLSYM(bd_loop_get_loop_name, )
		DLSYM(bd_loop_setup, )
		DLSYM(bd_loop_setup_from_fd, )
		DLSYM(bd_loop_teardown, )
		DLSYM(bd_loop_set_autoclear, )
		DLSYM(bd_loop_set_capacity, )
	}
	if (handle == &lib_libbd_crypto_so_3 || handle == NULL || handle == &main_program_handle) { 
		DLSYM(bd_crypto_init, )
		DLSYM(bd_crypto_is_tech_avail, )
		DLSYM(bd_crypto_integrity_close, )
		DLSYM(bd_crypto_keyring_add_key, )
		DLSYM(bd_crypto_device_seems_encrypted, )
		DLSYM(bd_crypto_tc_open, )
		DLSYM(bd_crypto_tc_close, )
		DLSYM(bd_crypto_escrow_device, )
		DLSYM(bd_crypto_bitlk_open, )
		DLSYM(bd_crypto_bitlk_close, )
		DLSYM(bd_crypto_fvault2_open, )
		DLSYM(bd_crypto_fvault2_close, )
		DLSYM(bd_crypto_opal_is_supported, )
		DLSYM(bd_crypto_opal_wipe_device, )
		DLSYM(bd_crypto_opal_format, )
		DLSYM(bd_crypto_opal_reset_device, )
		DLSYM(bd_crypto_generate_backup_passphrase, )
		DLSYM(bd_crypto_device_is_luks, )
		DLSYM(bd_crypto_luks_status, )
		DLSYM(bd_crypto_keyslot_context_new_passphrase, )
		DLSYM(bd_crypto_keyslot_context_new_keyfile, )
		DLSYM(bd_crypto_keyslot_context_new_keyring, )
		DLSYM(bd_crypto_keyslot_context_new_volume_key, )
		DLSYM(bd_crypto_luks_format, )
		DLSYM(bd_crypto_luks_open, )
		DLSYM(bd_crypto_luks_close, )
		DLSYM(bd_crypto_luks_add_key, )
		DLSYM(bd_crypto_luks_remove_key, )
		DLSYM(bd_crypto_luks_change_key, )
		DLSYM(bd_crypto_luks_resize, )
		DLSYM(bd_crypto_luks_suspend, )
		DLSYM(bd_crypto_luks_resume, )
		DLSYM(bd_crypto_luks_kill_slot, )
		DLSYM(bd_crypto_luks_header_backup, )
		DLSYM(bd_crypto_luks_header_restore, )
		DLSYM(bd_crypto_luks_set_label, )
		DLSYM(bd_crypto_luks_set_uuid, )
		DLSYM(bd_crypto_luks_convert, )
		DLSYM(bd_crypto_luks_set_persistent_flags, )
		DLSYM(bd_crypto_luks_info, )
		DLSYM(bd_crypto_bitlk_info, )
		DLSYM(bd_crypto_integrity_info, )
		DLSYM(bd_crypto_luks_token_info, )
		DLSYM(bd_crypto_integrity_format, )
		DLSYM(bd_crypto_integrity_open, )
	}
	if (handle == &lib_libbd_mdraid_so_3 || handle == NULL || handle == &main_program_handle) { 
		DLSYM(bd_md_init, )
		DLSYM(bd_md_is_tech_avail, )
		DLSYM(bd_md_get_superblock_size, )
		DLSYM(bd_md_create, )
		DLSYM(bd_md_destroy, )
		DLSYM(bd_md_deactivate, )
		DLSYM(bd_md_activate, )
		DLSYM(bd_md_run, )
		DLSYM(bd_md_nominate, )
		DLSYM(bd_md_denominate, )
		DLSYM(bd_md_add, )
		DLSYM(bd_md_remove, )
		DLSYM(bd_md_examine, )
		DLSYM(bd_md_detail, )
		DLSYM(bd_md_canonicalize_uuid, )
		DLSYM(bd_md_get_md_uuid, )
		DLSYM(bd_md_node_from_name, )
		DLSYM(bd_md_name_from_node, )
		DLSYM(bd_md_get_status, )
		DLSYM(bd_md_set_bitmap_location, )
		DLSYM(bd_md_get_bitmap_location, )
		DLSYM(bd_md_request_sync_action, )
	}
	if (handle == &lib_libbd_part_so_3 || handle == NULL || handle == &main_program_handle) { 
		DLSYM(bd_part_init, )
		DLSYM(bd_part_is_tech_avail, )
		DLSYM(bd_part_create_table, )
		DLSYM(bd_part_get_part_spec, )
		DLSYM(bd_part_get_part_by_pos, )
		DLSYM(bd_part_get_disk_spec, )
		DLSYM(bd_part_get_disk_parts, )
		DLSYM(bd_part_get_disk_free_regions, )
		DLSYM(bd_part_get_best_free_region, )
		DLSYM(bd_part_create_part, )
		DLSYM(bd_part_delete_part, )
		DLSYM(bd_part_resize_part, )
		DLSYM(bd_part_set_part_name, )
		DLSYM(bd_part_set_part_type, )
		DLSYM(bd_part_set_part_id, )
		DLSYM(bd_part_set_part_uuid, )
		DLSYM(bd_part_set_part_bootable, )
		DLSYM(bd_part_set_part_attributes, )
		DLSYM(bd_part_get_part_table_type_str, )
		DLSYM(bd_part_get_type_str, )
	}
	if (handle == &lib_libbd_fs_so_3 || handle == NULL || handle == &main_program_handle) { 
		DLSYM(bd_fs_init, )
		DLSYM(bd_fs_is_tech_avail, )
		DLSYM(bd_fs_supported_filesystems, )
		DLSYM(bd_fs_wipe, )
		DLSYM(bd_fs_clean, )
		DLSYM(bd_fs_get_fstype, )
		DLSYM(bd_fs_freeze, )
		DLSYM(bd_fs_unfreeze, )
		DLSYM(bd_fs_unmount, )
		DLSYM(bd_fs_mount, )
		DLSYM(bd_fs_get_mountpoint, )
		DLSYM(bd_fs_is_mountpoint, )
		DLSYM(bd_fs_resize, )
		DLSYM(bd_fs_repair, )
		DLSYM(bd_fs_check, )
		DLSYM(bd_fs_check_label, )
		DLSYM(bd_fs_set_label, )
		DLSYM(bd_fs_check_uuid, )
		DLSYM(bd_fs_set_uuid, )
		DLSYM(bd_fs_xfs_check_uuid, )
		DLSYM(bd_fs_get_size, )
		DLSYM(bd_fs_get_free_space, )
		DLSYM(bd_fs_get_min_size, )
		DLSYM(bd_fs_can_get_info, )
		DLSYM(bd_fs_can_mkfs, )
		DLSYM(bd_fs_can_resize, )
		DLSYM(bd_fs_can_check, )
		DLSYM(bd_fs_can_repair, )
		DLSYM(bd_fs_can_set_label, )
		DLSYM(bd_fs_can_set_uuid, )
		DLSYM(bd_fs_can_get_size, )
		DLSYM(bd_fs_can_get_free_space, )
		DLSYM(bd_fs_can_get_min_size, )
		DLSYM(bd_fs_mkfs, )
		DLSYM(bd_fs_ext2_mkfs, )
		DLSYM(bd_fs_ext3_mkfs, )
		DLSYM(bd_fs_ext4_mkfs, )
		DLSYM(bd_fs_ext2_check, )
		DLSYM(bd_fs_ext3_check, )
		DLSYM(bd_fs_ext4_check, )
		DLSYM(bd_fs_ext2_repair, )
		DLSYM(bd_fs_ext3_repair, )
		DLSYM(bd_fs_ext4_repair, )
		DLSYM(bd_fs_ext2_set_label, )
		DLSYM(bd_fs_ext3_set_label, )
		DLSYM(bd_fs_ext4_set_label, )
		DLSYM(bd_fs_ext2_check_label, )
		DLSYM(bd_fs_ext3_check_label, )
		DLSYM(bd_fs_ext4_check_label, )
		DLSYM(bd_fs_ext2_set_uuid, )
		DLSYM(bd_fs_ext3_set_uuid, )
		DLSYM(bd_fs_ext4_set_uuid, )
		DLSYM(bd_fs_ext2_check_uuid, )
		DLSYM(bd_fs_ext3_check_uuid, )
		DLSYM(bd_fs_ext4_check_uuid, )
		DLSYM(bd_fs_ext2_get_info, )
		DLSYM(bd_fs_ext3_get_info, )
		DLSYM(bd_fs_ext4_get_info, )
		DLSYM(bd_fs_ext2_resize, )
		DLSYM(bd_fs_ext3_resize, )
		DLSYM(bd_fs_ext4_resize, )
		DLSYM(bd_fs_ext2_get_min_size, )
		DLSYM(bd_fs_ext3_get_min_size, )
		DLSYM(bd_fs_ext4_get_min_size, )
		DLSYM(bd_fs_xfs_mkfs, )
		DLSYM(bd_fs_xfs_check, )
		DLSYM(bd_fs_xfs_repair, )
		DLSYM(bd_fs_xfs_set_label, )
		DLSYM(bd_fs_xfs_check_label, )
		DLSYM(bd_fs_xfs_set_uuid, )
		DLSYM(bd_fs_xfs_get_info, )
		DLSYM(bd_fs_xfs_resize, )
		DLSYM(bd_fs_vfat_mkfs, )
		DLSYM(bd_fs_vfat_check, )
		DLSYM(bd_fs_vfat_repair, )
		DLSYM(bd_fs_vfat_set_label, )
		DLSYM(bd_fs_vfat_check_label, )
		DLSYM(bd_fs_vfat_set_uuid, )
		DLSYM(bd_fs_vfat_check_uuid, )
		DLSYM(bd_fs_vfat_get_info, )
		DLSYM(bd_fs_vfat_resize, )
		DLSYM(bd_fs_ntfs_mkfs, )
		DLSYM(bd_fs_ntfs_check, )
		DLSYM(bd_fs_ntfs_repair, )
		DLSYM(bd_fs_ntfs_set_label, )
		DLSYM(bd_fs_ntfs_check_label, )
		DLSYM(bd_fs_ntfs_set_uuid, )
		DLSYM(bd_fs_ntfs_check_uuid, )
		DLSYM(bd_fs_ntfs_resize, )
		DLSYM(bd_fs_ntfs_get_info, )
		DLSYM(bd_fs_ntfs_get_min_size, )
		DLSYM(bd_fs_f2fs_mkfs, )
		DLSYM(bd_fs_f2fs_check, )
		DLSYM(bd_fs_f2fs_repair, )
		DLSYM(bd_fs_f2fs_get_info, )
		DLSYM(bd_fs_f2fs_resize, )
		DLSYM(bd_fs_f2fs_check_label, )
		DLSYM(bd_fs_nilfs2_mkfs, )
		DLSYM(bd_fs_nilfs2_set_label, )
		DLSYM(bd_fs_nilfs2_check_label, )
		DLSYM(bd_fs_nilfs2_set_uuid, )
		DLSYM(bd_fs_nilfs2_check_uuid, )
		DLSYM(bd_fs_nilfs2_get_info, )
		DLSYM(bd_fs_nilfs2_resize, )
		DLSYM(bd_fs_exfat_mkfs, )
		DLSYM(bd_fs_exfat_check, )
		DLSYM(bd_fs_exfat_repair, )
		DLSYM(bd_fs_exfat_set_label, )
		DLSYM(bd_fs_exfat_check_label, )
		DLSYM(bd_fs_exfat_set_uuid, )
		DLSYM(bd_fs_exfat_check_uuid, )
		DLSYM(bd_fs_exfat_get_info, )
		DLSYM(bd_fs_btrfs_mkfs, )
		DLSYM(bd_fs_btrfs_check, )
		DLSYM(bd_fs_btrfs_repair, )
		DLSYM(bd_fs_btrfs_set_label, )
		DLSYM(bd_fs_btrfs_check_label, )
		DLSYM(bd_fs_btrfs_set_uuid, )
		DLSYM(bd_fs_btrfs_check_uuid, )
		DLSYM(bd_fs_btrfs_get_info, )
		DLSYM(bd_fs_btrfs_resize, )
		DLSYM(bd_fs_udf_mkfs, )
		DLSYM(bd_fs_udf_set_label, )
		DLSYM(bd_fs_udf_check_label, )
		DLSYM(bd_fs_udf_set_uuid, )
		DLSYM(bd_fs_udf_check_uuid, )
		DLSYM(bd_fs_udf_get_info, )
		DLSYM(bd_fs_features, )
	}
	if (handle == &lib_libbd_nvme_so_3 || handle == NULL || handle == &main_program_handle) { 
		DLSYM(bd_nvme_init, )
		DLSYM(bd_nvme_is_tech_avail, )
		DLSYM(bd_nvme_self_test_result_to_string, )
		DLSYM(bd_nvme_get_controller_info, )
		DLSYM(bd_nvme_get_namespace_info, )
		DLSYM(bd_nvme_get_smart_log, )
		DLSYM(bd_nvme_get_error_log_entries, )
		DLSYM(bd_nvme_get_self_test_log, )
		DLSYM(bd_nvme_get_sanitize_log, )
		DLSYM(bd_nvme_device_self_test, )
		DLSYM(bd_nvme_format, )
		DLSYM(bd_nvme_sanitize, )
		DLSYM(bd_nvme_get_host_nqn, )
		DLSYM(bd_nvme_generate_host_nqn, )
		DLSYM(bd_nvme_get_host_id, )
		DLSYM(bd_nvme_set_host_nqn, )
		DLSYM(bd_nvme_set_host_id, )
		DLSYM(bd_nvme_connect, )
		DLSYM(bd_nvme_disconnect, )
		DLSYM(bd_nvme_disconnect_by_path, )
		DLSYM(bd_nvme_find_ctrls_for_ns, )
	}
	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s\n", symbol);	return stub_dlsym(handle, symbol);
}


int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
    return stub_dladdr(handle, info);
}

