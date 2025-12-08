#include "dl_factory.h"

extern void* bd_swap_check_label;

extern void* bd_swap_check_uuid;

extern void* bd_swap_close;

extern void* bd_swap_error_quark;

extern void* bd_swap_init;

extern void* bd_swap_is_tech_avail;

extern void* bd_swap_mkswap;

extern void* bd_swap_set_label;

extern void* bd_swap_set_uuid;

extern void* bd_swap_swapoff;

extern void* bd_swap_swapon;

extern void* bd_swap_swapstatus;



extern void* bd_loop_close;

extern void* bd_loop_error_quark;

extern void* bd_loop_get_loop_name;

extern void* bd_loop_info;

extern void* bd_loop_info_copy;

extern void* bd_loop_info_free;

extern void* bd_loop_init;

extern void* bd_loop_is_tech_avail;

extern void* bd_loop_set_autoclear;

extern void* bd_loop_set_capacity;

extern void* bd_loop_setup;

extern void* bd_loop_setup_from_fd;

extern void* bd_loop_teardown;



extern void* bd_crypto_bitlk_close;

extern void* bd_crypto_bitlk_info;

extern void* bd_crypto_bitlk_info_copy;

extern void* bd_crypto_bitlk_info_free;

extern void* bd_crypto_bitlk_open;

extern void* bd_crypto_close;

extern void* bd_crypto_device_is_luks;

extern void* bd_crypto_device_seems_encrypted;

extern void* bd_crypto_error_quark;

extern void* bd_crypto_escrow_device;

extern void* bd_crypto_fvault2_close;

extern void* bd_crypto_fvault2_open;

extern void* bd_crypto_generate_backup_passphrase;

extern void* bd_crypto_init;

extern void* bd_crypto_integrity_close;

extern void* bd_crypto_integrity_extra_copy;

extern void* bd_crypto_integrity_extra_free;

extern void* bd_crypto_integrity_extra_new;

extern void* bd_crypto_integrity_format;

extern void* bd_crypto_integrity_info;

extern void* bd_crypto_integrity_info_copy;

extern void* bd_crypto_integrity_info_free;

extern void* bd_crypto_integrity_open;

extern void* bd_crypto_is_tech_avail;

extern void* bd_crypto_keyring_add_key;

extern void* bd_crypto_keyslot_context_copy;

extern void* bd_crypto_keyslot_context_free;

extern void* bd_crypto_keyslot_context_new_keyfile;

extern void* bd_crypto_keyslot_context_new_keyring;

extern void* bd_crypto_keyslot_context_new_passphrase;

extern void* bd_crypto_keyslot_context_new_volume_key;

extern void* bd_crypto_luks_add_key;

extern void* bd_crypto_luks_change_key;

extern void* bd_crypto_luks_close;

extern void* bd_crypto_luks_convert;

extern void* bd_crypto_luks_extra_copy;

extern void* bd_crypto_luks_extra_free;

extern void* bd_crypto_luks_extra_new;

extern void* bd_crypto_luks_format;

extern void* bd_crypto_luks_header_backup;

extern void* bd_crypto_luks_header_restore;

extern void* bd_crypto_luks_info;

extern void* bd_crypto_luks_info_copy;

extern void* bd_crypto_luks_info_free;

extern void* bd_crypto_luks_kill_slot;

extern void* bd_crypto_luks_open;

extern void* bd_crypto_luks_pbkdf_copy;

extern void* bd_crypto_luks_pbkdf_free;

extern void* bd_crypto_luks_pbkdf_new;

extern void* bd_crypto_luks_remove_key;

extern void* bd_crypto_luks_resize;

extern void* bd_crypto_luks_resume;

extern void* bd_crypto_luks_set_label;

extern void* bd_crypto_luks_set_persistent_flags;

extern void* bd_crypto_luks_set_uuid;

extern void* bd_crypto_luks_status;

extern void* bd_crypto_luks_suspend;

extern void* bd_crypto_luks_token_info;

extern void* bd_crypto_luks_token_info_copy;

extern void* bd_crypto_luks_token_info_free;

extern void* bd_crypto_opal_format;

extern void* bd_crypto_opal_is_supported;

extern void* bd_crypto_opal_reset_device;

extern void* bd_crypto_opal_wipe_device;

extern void* bd_crypto_tc_close;

extern void* bd_crypto_tc_open;



extern void* bd_md_activate;

extern void* bd_md_add;

extern void* bd_md_canonicalize_uuid;

extern void* bd_md_close;

extern void* bd_md_create;

extern void* bd_md_deactivate;

extern void* bd_md_denominate;

extern void* bd_md_destroy;

extern void* bd_md_detail;

extern void* bd_md_detail_data_copy;

extern void* bd_md_detail_data_free;

extern void* bd_md_error_quark;

extern void* bd_md_examine;

extern void* bd_md_examine_data_copy;

extern void* bd_md_examine_data_free;

extern void* bd_md_get_bitmap_location;

extern void* bd_md_get_md_uuid;

extern void* bd_md_get_status;

extern void* bd_md_get_superblock_size;

extern void* bd_md_init;

extern void* bd_md_is_tech_avail;

extern void* bd_md_name_from_node;

extern void* bd_md_node_from_name;

extern void* bd_md_nominate;

extern void* bd_md_remove;

extern void* bd_md_request_sync_action;

extern void* bd_md_run;

extern void* bd_md_set_bitmap_location;



extern void* bd_part_close;

extern void* bd_part_create_part;

extern void* bd_part_create_table;

extern void* bd_part_delete_part;

extern void* bd_part_disk_spec_copy;

extern void* bd_part_disk_spec_free;

extern void* bd_part_error_quark;

extern void* bd_part_get_best_free_region;

extern void* bd_part_get_disk_free_regions;

extern void* bd_part_get_disk_parts;

extern void* bd_part_get_disk_spec;

extern void* bd_part_get_part_by_pos;

extern void* bd_part_get_part_spec;

extern void* bd_part_get_part_table_type_str;

extern void* bd_part_get_type_str;

extern void* bd_part_init;

extern void* bd_part_is_tech_avail;

extern void* bd_part_resize_part;

extern void* bd_part_set_part_attributes;

extern void* bd_part_set_part_bootable;

extern void* bd_part_set_part_id;

extern void* bd_part_set_part_name;

extern void* bd_part_set_part_type;

extern void* bd_part_set_part_uuid;

extern void* bd_part_spec_copy;

extern void* bd_part_spec_free;



extern void* bd_fs_close;

extern void* bd_fs_error_quark;

extern void* bd_fs_init;

extern void* bd_fs_is_tech_avail;

extern void* bd_fs_ext2_check;

extern void* bd_fs_ext2_check_label;

extern void* bd_fs_ext2_check_uuid;

extern void* bd_fs_ext2_get_info;

extern void* bd_fs_ext2_get_min_size;

extern void* bd_fs_ext2_info_copy;

extern void* bd_fs_ext2_info_free;

extern void* bd_fs_ext2_mkfs;

extern void* bd_fs_ext2_mkfs_options;

extern void* bd_fs_ext2_repair;

extern void* bd_fs_ext2_resize;

extern void* bd_fs_ext2_set_label;

extern void* bd_fs_ext2_set_uuid;

extern void* bd_fs_ext3_check;

extern void* bd_fs_ext3_check_label;

extern void* bd_fs_ext3_check_uuid;

extern void* bd_fs_ext3_get_info;

extern void* bd_fs_ext3_get_min_size;

extern void* bd_fs_ext3_info_copy;

extern void* bd_fs_ext3_info_free;

extern void* bd_fs_ext3_mkfs;

extern void* bd_fs_ext3_mkfs_options;

extern void* bd_fs_ext3_repair;

extern void* bd_fs_ext3_resize;

extern void* bd_fs_ext3_set_label;

extern void* bd_fs_ext3_set_uuid;

extern void* bd_fs_ext4_check;

extern void* bd_fs_ext4_check_label;

extern void* bd_fs_ext4_check_uuid;

extern void* bd_fs_ext4_get_info;

extern void* bd_fs_ext4_get_min_size;

extern void* bd_fs_ext4_info_copy;

extern void* bd_fs_ext4_info_free;

extern void* bd_fs_ext4_mkfs;

extern void* bd_fs_ext4_mkfs_options;

extern void* bd_fs_ext4_repair;

extern void* bd_fs_ext4_resize;

extern void* bd_fs_ext4_set_label;

extern void* bd_fs_ext4_set_uuid;

extern void* bd_fs_ext_is_tech_avail;

extern void* bd_fs_can_check;

extern void* bd_fs_can_get_free_space;

extern void* bd_fs_can_get_info;

extern void* bd_fs_can_get_min_size;

extern void* bd_fs_can_get_size;

extern void* bd_fs_can_mkfs;

extern void* bd_fs_can_repair;

extern void* bd_fs_can_resize;

extern void* bd_fs_can_set_label;

extern void* bd_fs_can_set_uuid;

extern void* bd_fs_check;

extern void* bd_fs_check_label;

extern void* bd_fs_check_uuid;

extern void* bd_fs_clean;

extern void* bd_fs_features;

extern void* bd_fs_freeze;

extern void* bd_fs_get_free_space;

extern void* bd_fs_get_fstype;

extern void* bd_fs_get_min_size;

extern void* bd_fs_get_size;

extern void* bd_fs_mkfs;

extern void* bd_fs_repair;

extern void* bd_fs_resize;

extern void* bd_fs_set_label;

extern void* bd_fs_set_uuid;

extern void* bd_fs_supported_filesystems;

extern void* bd_fs_unfreeze;

extern void* bd_fs_wipe;

extern void* bd_fs_get_mountpoint;

extern void* bd_fs_is_mountpoint;

extern void* bd_fs_mount;

extern void* bd_fs_unmount;

extern void* bd_fs_ntfs_check;

extern void* bd_fs_ntfs_check_label;

extern void* bd_fs_ntfs_check_uuid;

extern void* bd_fs_ntfs_get_info;

extern void* bd_fs_ntfs_get_min_size;

extern void* bd_fs_ntfs_info_copy;

extern void* bd_fs_ntfs_info_free;

extern void* bd_fs_ntfs_is_tech_avail;

extern void* bd_fs_ntfs_mkfs;

extern void* bd_fs_ntfs_mkfs_options;

extern void* bd_fs_ntfs_repair;

extern void* bd_fs_ntfs_resize;

extern void* bd_fs_ntfs_set_label;

extern void* bd_fs_ntfs_set_uuid;

extern void* bd_fs_vfat_check;

extern void* bd_fs_vfat_check_label;

extern void* bd_fs_vfat_check_uuid;

extern void* bd_fs_vfat_get_info;

extern void* bd_fs_vfat_info_copy;

extern void* bd_fs_vfat_info_free;

extern void* bd_fs_vfat_is_tech_avail;

extern void* bd_fs_vfat_mkfs;

extern void* bd_fs_vfat_mkfs_options;

extern void* bd_fs_vfat_repair;

extern void* bd_fs_vfat_resize;

extern void* bd_fs_vfat_set_label;

extern void* bd_fs_vfat_set_uuid;

extern void* bd_fs_xfs_check;

extern void* bd_fs_xfs_check_label;

extern void* bd_fs_xfs_check_uuid;

extern void* bd_fs_xfs_get_info;

extern void* bd_fs_xfs_info_copy;

extern void* bd_fs_xfs_info_free;

extern void* bd_fs_xfs_is_tech_avail;

extern void* bd_fs_xfs_mkfs;

extern void* bd_fs_xfs_mkfs_options;

extern void* bd_fs_xfs_repair;

extern void* bd_fs_xfs_resize;

extern void* bd_fs_xfs_set_label;

extern void* bd_fs_xfs_set_uuid;

extern void* bd_fs_f2fs_check;

extern void* bd_fs_f2fs_check_label;

extern void* bd_fs_f2fs_get_info;

extern void* bd_fs_f2fs_info_copy;

extern void* bd_fs_f2fs_info_free;

extern void* bd_fs_f2fs_is_tech_avail;

extern void* bd_fs_f2fs_mkfs;

extern void* bd_fs_f2fs_mkfs_options;

extern void* bd_fs_f2fs_repair;

extern void* bd_fs_f2fs_resize;

extern void* bd_fs_nilfs2_check_label;

extern void* bd_fs_nilfs2_check_uuid;

extern void* bd_fs_nilfs2_get_info;

extern void* bd_fs_nilfs2_info_copy;

extern void* bd_fs_nilfs2_info_free;

extern void* bd_fs_nilfs2_is_tech_avail;

extern void* bd_fs_nilfs2_mkfs;

extern void* bd_fs_nilfs2_mkfs_options;

extern void* bd_fs_nilfs2_resize;

extern void* bd_fs_nilfs2_set_label;

extern void* bd_fs_nilfs2_set_uuid;

extern void* bd_fs_exfat_check;

extern void* bd_fs_exfat_check_label;

extern void* bd_fs_exfat_check_uuid;

extern void* bd_fs_exfat_get_info;

extern void* bd_fs_exfat_info_copy;

extern void* bd_fs_exfat_info_free;

extern void* bd_fs_exfat_is_tech_avail;

extern void* bd_fs_exfat_mkfs;

extern void* bd_fs_exfat_mkfs_options;

extern void* bd_fs_exfat_repair;

extern void* bd_fs_exfat_set_label;

extern void* bd_fs_exfat_set_uuid;

extern void* bd_fs_btrfs_check;

extern void* bd_fs_btrfs_check_label;

extern void* bd_fs_btrfs_check_uuid;

extern void* bd_fs_btrfs_get_info;

extern void* bd_fs_btrfs_info_copy;

extern void* bd_fs_btrfs_info_free;

extern void* bd_fs_btrfs_is_tech_avail;

extern void* bd_fs_btrfs_mkfs;

extern void* bd_fs_btrfs_mkfs_options;

extern void* bd_fs_btrfs_repair;

extern void* bd_fs_btrfs_resize;

extern void* bd_fs_btrfs_set_label;

extern void* bd_fs_btrfs_set_uuid;

extern void* bd_fs_udf_check_label;

extern void* bd_fs_udf_check_uuid;

extern void* bd_fs_udf_get_info;

extern void* bd_fs_udf_info_copy;

extern void* bd_fs_udf_info_free;

extern void* bd_fs_udf_is_tech_avail;

extern void* bd_fs_udf_mkfs;

extern void* bd_fs_udf_mkfs_options;

extern void* bd_fs_udf_set_label;

extern void* bd_fs_udf_set_uuid;



extern void* bd_nvme_close;

extern void* bd_nvme_init;

extern void* bd_nvme_is_tech_avail;

extern void* bd_nvme_controller_info_copy;

extern void* bd_nvme_controller_info_free;

extern void* bd_nvme_error_log_entry_copy;

extern void* bd_nvme_error_log_entry_free;

extern void* bd_nvme_get_controller_info;

extern void* bd_nvme_get_error_log_entries;

extern void* bd_nvme_get_namespace_info;

extern void* bd_nvme_get_sanitize_log;

extern void* bd_nvme_get_self_test_log;

extern void* bd_nvme_get_smart_log;

extern void* bd_nvme_lba_format_copy;

extern void* bd_nvme_lba_format_free;

extern void* bd_nvme_namespace_info_copy;

extern void* bd_nvme_namespace_info_free;

extern void* bd_nvme_sanitize_log_copy;

extern void* bd_nvme_sanitize_log_free;

extern void* bd_nvme_self_test_log_copy;

extern void* bd_nvme_self_test_log_entry_copy;

extern void* bd_nvme_self_test_log_entry_free;

extern void* bd_nvme_self_test_log_free;

extern void* bd_nvme_self_test_result_to_string;

extern void* bd_nvme_smart_log_copy;

extern void* bd_nvme_smart_log_free;

extern void* bd_nvme_error_quark;

extern void* bd_nvme_device_self_test;

extern void* bd_nvme_format;

extern void* bd_nvme_sanitize;

extern void* bd_nvme_connect;

extern void* bd_nvme_disconnect;

extern void* bd_nvme_disconnect_by_path;

extern void* bd_nvme_find_ctrls_for_ns;

extern void* bd_nvme_generate_host_nqn;

extern void* bd_nvme_get_host_id;

extern void* bd_nvme_get_host_nqn;

extern void* bd_nvme_set_host_id;

extern void* bd_nvme_set_host_nqn;




__attribute__((constructor)) static void register_libbd_swap_so_3(){
	register_lib("libbd_swap.so.3", 12);

	register_symbol("bd_swap_check_label", &bd_swap_check_label);
	register_symbol("bd_swap_check_uuid", &bd_swap_check_uuid);
	register_symbol("bd_swap_close", &bd_swap_close);
	register_symbol("bd_swap_error_quark", &bd_swap_error_quark);
	register_symbol("bd_swap_init", &bd_swap_init);
	register_symbol("bd_swap_is_tech_avail", &bd_swap_is_tech_avail);
	register_symbol("bd_swap_mkswap", &bd_swap_mkswap);
	register_symbol("bd_swap_set_label", &bd_swap_set_label);
	register_symbol("bd_swap_set_uuid", &bd_swap_set_uuid);
	register_symbol("bd_swap_swapoff", &bd_swap_swapoff);
	register_symbol("bd_swap_swapon", &bd_swap_swapon);
	register_symbol("bd_swap_swapstatus", &bd_swap_swapstatus);


	register_lib("libbd_loop.so.3", 13);

	register_symbol("bd_loop_close", &bd_loop_close);
	register_symbol("bd_loop_error_quark", &bd_loop_error_quark);
	register_symbol("bd_loop_get_loop_name", &bd_loop_get_loop_name);
	register_symbol("bd_loop_info", &bd_loop_info);
	register_symbol("bd_loop_info_copy", &bd_loop_info_copy);
	register_symbol("bd_loop_info_free", &bd_loop_info_free);
	register_symbol("bd_loop_init", &bd_loop_init);
	register_symbol("bd_loop_is_tech_avail", &bd_loop_is_tech_avail);
	register_symbol("bd_loop_set_autoclear", &bd_loop_set_autoclear);
	register_symbol("bd_loop_set_capacity", &bd_loop_set_capacity);
	register_symbol("bd_loop_setup", &bd_loop_setup);
	register_symbol("bd_loop_setup_from_fd", &bd_loop_setup_from_fd);
	register_symbol("bd_loop_teardown", &bd_loop_teardown);


	register_lib("libbd_crypto.so.3", 66);

	register_symbol("bd_crypto_bitlk_close", &bd_crypto_bitlk_close);
	register_symbol("bd_crypto_bitlk_info", &bd_crypto_bitlk_info);
	register_symbol("bd_crypto_bitlk_info_copy", &bd_crypto_bitlk_info_copy);
	register_symbol("bd_crypto_bitlk_info_free", &bd_crypto_bitlk_info_free);
	register_symbol("bd_crypto_bitlk_open", &bd_crypto_bitlk_open);
	register_symbol("bd_crypto_close", &bd_crypto_close);
	register_symbol("bd_crypto_device_is_luks", &bd_crypto_device_is_luks);
	register_symbol("bd_crypto_device_seems_encrypted", &bd_crypto_device_seems_encrypted);
	register_symbol("bd_crypto_error_quark", &bd_crypto_error_quark);
	register_symbol("bd_crypto_escrow_device", &bd_crypto_escrow_device);
	register_symbol("bd_crypto_fvault2_close", &bd_crypto_fvault2_close);
	register_symbol("bd_crypto_fvault2_open", &bd_crypto_fvault2_open);
	register_symbol("bd_crypto_generate_backup_passphrase", &bd_crypto_generate_backup_passphrase);
	register_symbol("bd_crypto_init", &bd_crypto_init);
	register_symbol("bd_crypto_integrity_close", &bd_crypto_integrity_close);
	register_symbol("bd_crypto_integrity_extra_copy", &bd_crypto_integrity_extra_copy);
	register_symbol("bd_crypto_integrity_extra_free", &bd_crypto_integrity_extra_free);
	register_symbol("bd_crypto_integrity_extra_new", &bd_crypto_integrity_extra_new);
	register_symbol("bd_crypto_integrity_format", &bd_crypto_integrity_format);
	register_symbol("bd_crypto_integrity_info", &bd_crypto_integrity_info);
	register_symbol("bd_crypto_integrity_info_copy", &bd_crypto_integrity_info_copy);
	register_symbol("bd_crypto_integrity_info_free", &bd_crypto_integrity_info_free);
	register_symbol("bd_crypto_integrity_open", &bd_crypto_integrity_open);
	register_symbol("bd_crypto_is_tech_avail", &bd_crypto_is_tech_avail);
	register_symbol("bd_crypto_keyring_add_key", &bd_crypto_keyring_add_key);
	register_symbol("bd_crypto_keyslot_context_copy", &bd_crypto_keyslot_context_copy);
	register_symbol("bd_crypto_keyslot_context_free", &bd_crypto_keyslot_context_free);
	register_symbol("bd_crypto_keyslot_context_new_keyfile", &bd_crypto_keyslot_context_new_keyfile);
	register_symbol("bd_crypto_keyslot_context_new_keyring", &bd_crypto_keyslot_context_new_keyring);
	register_symbol("bd_crypto_keyslot_context_new_passphrase", &bd_crypto_keyslot_context_new_passphrase);
	register_symbol("bd_crypto_keyslot_context_new_volume_key", &bd_crypto_keyslot_context_new_volume_key);
	register_symbol("bd_crypto_luks_add_key", &bd_crypto_luks_add_key);
	register_symbol("bd_crypto_luks_change_key", &bd_crypto_luks_change_key);
	register_symbol("bd_crypto_luks_close", &bd_crypto_luks_close);
	register_symbol("bd_crypto_luks_convert", &bd_crypto_luks_convert);
	register_symbol("bd_crypto_luks_extra_copy", &bd_crypto_luks_extra_copy);
	register_symbol("bd_crypto_luks_extra_free", &bd_crypto_luks_extra_free);
	register_symbol("bd_crypto_luks_extra_new", &bd_crypto_luks_extra_new);
	register_symbol("bd_crypto_luks_format", &bd_crypto_luks_format);
	register_symbol("bd_crypto_luks_header_backup", &bd_crypto_luks_header_backup);
	register_symbol("bd_crypto_luks_header_restore", &bd_crypto_luks_header_restore);
	register_symbol("bd_crypto_luks_info", &bd_crypto_luks_info);
	register_symbol("bd_crypto_luks_info_copy", &bd_crypto_luks_info_copy);
	register_symbol("bd_crypto_luks_info_free", &bd_crypto_luks_info_free);
	register_symbol("bd_crypto_luks_kill_slot", &bd_crypto_luks_kill_slot);
	register_symbol("bd_crypto_luks_open", &bd_crypto_luks_open);
	register_symbol("bd_crypto_luks_pbkdf_copy", &bd_crypto_luks_pbkdf_copy);
	register_symbol("bd_crypto_luks_pbkdf_free", &bd_crypto_luks_pbkdf_free);
	register_symbol("bd_crypto_luks_pbkdf_new", &bd_crypto_luks_pbkdf_new);
	register_symbol("bd_crypto_luks_remove_key", &bd_crypto_luks_remove_key);
	register_symbol("bd_crypto_luks_resize", &bd_crypto_luks_resize);
	register_symbol("bd_crypto_luks_resume", &bd_crypto_luks_resume);
	register_symbol("bd_crypto_luks_set_label", &bd_crypto_luks_set_label);
	register_symbol("bd_crypto_luks_set_persistent_flags", &bd_crypto_luks_set_persistent_flags);
	register_symbol("bd_crypto_luks_set_uuid", &bd_crypto_luks_set_uuid);
	register_symbol("bd_crypto_luks_status", &bd_crypto_luks_status);
	register_symbol("bd_crypto_luks_suspend", &bd_crypto_luks_suspend);
	register_symbol("bd_crypto_luks_token_info", &bd_crypto_luks_token_info);
	register_symbol("bd_crypto_luks_token_info_copy", &bd_crypto_luks_token_info_copy);
	register_symbol("bd_crypto_luks_token_info_free", &bd_crypto_luks_token_info_free);
	register_symbol("bd_crypto_opal_format", &bd_crypto_opal_format);
	register_symbol("bd_crypto_opal_is_supported", &bd_crypto_opal_is_supported);
	register_symbol("bd_crypto_opal_reset_device", &bd_crypto_opal_reset_device);
	register_symbol("bd_crypto_opal_wipe_device", &bd_crypto_opal_wipe_device);
	register_symbol("bd_crypto_tc_close", &bd_crypto_tc_close);
	register_symbol("bd_crypto_tc_open", &bd_crypto_tc_open);

	register_lib("libbd_mdraid.so.3", 28);

	register_symbol("bd_md_activate", &bd_md_activate);
	register_symbol("bd_md_add", &bd_md_add);
	register_symbol("bd_md_canonicalize_uuid", &bd_md_canonicalize_uuid);
	register_symbol("bd_md_close", &bd_md_close);
	register_symbol("bd_md_create", &bd_md_create);
	register_symbol("bd_md_deactivate", &bd_md_deactivate);
	register_symbol("bd_md_denominate", &bd_md_denominate);
	register_symbol("bd_md_destroy", &bd_md_destroy);
	register_symbol("bd_md_detail", &bd_md_detail);
	register_symbol("bd_md_detail_data_copy", &bd_md_detail_data_copy);
	register_symbol("bd_md_detail_data_free", &bd_md_detail_data_free);
	register_symbol("bd_md_error_quark", &bd_md_error_quark);
	register_symbol("bd_md_examine", &bd_md_examine);
	register_symbol("bd_md_examine_data_copy", &bd_md_examine_data_copy);
	register_symbol("bd_md_examine_data_free", &bd_md_examine_data_free);
	register_symbol("bd_md_get_bitmap_location", &bd_md_get_bitmap_location);
	register_symbol("bd_md_get_md_uuid", &bd_md_get_md_uuid);
	register_symbol("bd_md_get_status", &bd_md_get_status);
	register_symbol("bd_md_get_superblock_size", &bd_md_get_superblock_size);
	register_symbol("bd_md_init", &bd_md_init);
	register_symbol("bd_md_is_tech_avail", &bd_md_is_tech_avail);
	register_symbol("bd_md_name_from_node", &bd_md_name_from_node);
	register_symbol("bd_md_node_from_name", &bd_md_node_from_name);
	register_symbol("bd_md_nominate", &bd_md_nominate);
	register_symbol("bd_md_remove", &bd_md_remove);
	register_symbol("bd_md_request_sync_action", &bd_md_request_sync_action);
	register_symbol("bd_md_run", &bd_md_run);
	register_symbol("bd_md_set_bitmap_location", &bd_md_set_bitmap_location);

	register_lib("libbd_part.so.3", 26);

	register_symbol("bd_part_close", &bd_part_close);
	register_symbol("bd_part_create_part", &bd_part_create_part);
	register_symbol("bd_part_create_table", &bd_part_create_table);
	register_symbol("bd_part_delete_part", &bd_part_delete_part);
	register_symbol("bd_part_disk_spec_copy", &bd_part_disk_spec_copy);
	register_symbol("bd_part_disk_spec_free", &bd_part_disk_spec_free);
	register_symbol("bd_part_error_quark", &bd_part_error_quark);
	register_symbol("bd_part_get_best_free_region", &bd_part_get_best_free_region);
	register_symbol("bd_part_get_disk_free_regions", &bd_part_get_disk_free_regions);
	register_symbol("bd_part_get_disk_parts", &bd_part_get_disk_parts);
	register_symbol("bd_part_get_disk_spec", &bd_part_get_disk_spec);
	register_symbol("bd_part_get_part_by_pos", &bd_part_get_part_by_pos);
	register_symbol("bd_part_get_part_spec", &bd_part_get_part_spec);
	register_symbol("bd_part_get_part_table_type_str", &bd_part_get_part_table_type_str);
	register_symbol("bd_part_get_type_str", &bd_part_get_type_str);
	register_symbol("bd_part_init", &bd_part_init);
	register_symbol("bd_part_is_tech_avail", &bd_part_is_tech_avail);
	register_symbol("bd_part_resize_part", &bd_part_resize_part);
	register_symbol("bd_part_set_part_attributes", &bd_part_set_part_attributes);
	register_symbol("bd_part_set_part_bootable", &bd_part_set_part_bootable);
	register_symbol("bd_part_set_part_id", &bd_part_set_part_id);
	register_symbol("bd_part_set_part_name", &bd_part_set_part_name);
	register_symbol("bd_part_set_part_type", &bd_part_set_part_type);
	register_symbol("bd_part_set_part_uuid", &bd_part_set_part_uuid);
	register_symbol("bd_part_spec_copy", &bd_part_spec_copy);
	register_symbol("bd_part_spec_free", &bd_part_spec_free);


	register_lib("libbd_fs.so.3", 172);

	register_symbol("bd_fs_close", &bd_fs_close);
	register_symbol("bd_fs_error_quark", &bd_fs_error_quark);
	register_symbol("bd_fs_init", &bd_fs_init);
	register_symbol("bd_fs_is_tech_avail", &bd_fs_is_tech_avail);
	register_symbol("bd_fs_ext2_check", &bd_fs_ext2_check);
	register_symbol("bd_fs_ext2_check_label", &bd_fs_ext2_check_label);
	register_symbol("bd_fs_ext2_check_uuid", &bd_fs_ext2_check_uuid);
	register_symbol("bd_fs_ext2_get_info", &bd_fs_ext2_get_info);
	register_symbol("bd_fs_ext2_get_min_size", &bd_fs_ext2_get_min_size);
	register_symbol("bd_fs_ext2_info_copy", &bd_fs_ext2_info_copy);
	register_symbol("bd_fs_ext2_info_free", &bd_fs_ext2_info_free);
	register_symbol("bd_fs_ext2_mkfs", &bd_fs_ext2_mkfs);
	register_symbol("bd_fs_ext2_mkfs_options", &bd_fs_ext2_mkfs_options);
	register_symbol("bd_fs_ext2_repair", &bd_fs_ext2_repair);
	register_symbol("bd_fs_ext2_resize", &bd_fs_ext2_resize);
	register_symbol("bd_fs_ext2_set_label", &bd_fs_ext2_set_label);
	register_symbol("bd_fs_ext2_set_uuid", &bd_fs_ext2_set_uuid);
	register_symbol("bd_fs_ext3_check", &bd_fs_ext3_check);
	register_symbol("bd_fs_ext3_check_label", &bd_fs_ext3_check_label);
	register_symbol("bd_fs_ext3_check_uuid", &bd_fs_ext3_check_uuid);
	register_symbol("bd_fs_ext3_get_info", &bd_fs_ext3_get_info);
	register_symbol("bd_fs_ext3_get_min_size", &bd_fs_ext3_get_min_size);
	register_symbol("bd_fs_ext3_info_copy", &bd_fs_ext3_info_copy);
	register_symbol("bd_fs_ext3_info_free", &bd_fs_ext3_info_free);
	register_symbol("bd_fs_ext3_mkfs", &bd_fs_ext3_mkfs);
	register_symbol("bd_fs_ext3_mkfs_options", &bd_fs_ext3_mkfs_options);
	register_symbol("bd_fs_ext3_repair", &bd_fs_ext3_repair);
	register_symbol("bd_fs_ext3_resize", &bd_fs_ext3_resize);
	register_symbol("bd_fs_ext3_set_label", &bd_fs_ext3_set_label);
	register_symbol("bd_fs_ext3_set_uuid", &bd_fs_ext3_set_uuid);
	register_symbol("bd_fs_ext4_check", &bd_fs_ext4_check);
	register_symbol("bd_fs_ext4_check_label", &bd_fs_ext4_check_label);
	register_symbol("bd_fs_ext4_check_uuid", &bd_fs_ext4_check_uuid);
	register_symbol("bd_fs_ext4_get_info", &bd_fs_ext4_get_info);
	register_symbol("bd_fs_ext4_get_min_size", &bd_fs_ext4_get_min_size);
	register_symbol("bd_fs_ext4_info_copy", &bd_fs_ext4_info_copy);
	register_symbol("bd_fs_ext4_info_free", &bd_fs_ext4_info_free);
	register_symbol("bd_fs_ext4_mkfs", &bd_fs_ext4_mkfs);
	register_symbol("bd_fs_ext4_mkfs_options", &bd_fs_ext4_mkfs_options);
	register_symbol("bd_fs_ext4_repair", &bd_fs_ext4_repair);
	register_symbol("bd_fs_ext4_resize", &bd_fs_ext4_resize);
	register_symbol("bd_fs_ext4_set_label", &bd_fs_ext4_set_label);
	register_symbol("bd_fs_ext4_set_uuid", &bd_fs_ext4_set_uuid);
	register_symbol("bd_fs_ext_is_tech_avail", &bd_fs_ext_is_tech_avail);
	register_symbol("bd_fs_can_check", &bd_fs_can_check);
	register_symbol("bd_fs_can_get_free_space", &bd_fs_can_get_free_space);
	register_symbol("bd_fs_can_get_info", &bd_fs_can_get_info);
	register_symbol("bd_fs_can_get_min_size", &bd_fs_can_get_min_size);
	register_symbol("bd_fs_can_get_size", &bd_fs_can_get_size);
	register_symbol("bd_fs_can_mkfs", &bd_fs_can_mkfs);
	register_symbol("bd_fs_can_repair", &bd_fs_can_repair);
	register_symbol("bd_fs_can_resize", &bd_fs_can_resize);
	register_symbol("bd_fs_can_set_label", &bd_fs_can_set_label);
	register_symbol("bd_fs_can_set_uuid", &bd_fs_can_set_uuid);
	register_symbol("bd_fs_check", &bd_fs_check);
	register_symbol("bd_fs_check_label", &bd_fs_check_label);
	register_symbol("bd_fs_check_uuid", &bd_fs_check_uuid);
	register_symbol("bd_fs_clean", &bd_fs_clean);
	register_symbol("bd_fs_features", &bd_fs_features);
	register_symbol("bd_fs_freeze", &bd_fs_freeze);
	register_symbol("bd_fs_get_free_space", &bd_fs_get_free_space);
	register_symbol("bd_fs_get_fstype", &bd_fs_get_fstype);
	register_symbol("bd_fs_get_min_size", &bd_fs_get_min_size);
	register_symbol("bd_fs_get_size", &bd_fs_get_size);
	register_symbol("bd_fs_mkfs", &bd_fs_mkfs);
	register_symbol("bd_fs_repair", &bd_fs_repair);
	register_symbol("bd_fs_resize", &bd_fs_resize);
	register_symbol("bd_fs_set_label", &bd_fs_set_label);
	register_symbol("bd_fs_set_uuid", &bd_fs_set_uuid);
	register_symbol("bd_fs_supported_filesystems", &bd_fs_supported_filesystems);
	register_symbol("bd_fs_unfreeze", &bd_fs_unfreeze);
	register_symbol("bd_fs_wipe", &bd_fs_wipe);
	register_symbol("bd_fs_get_mountpoint", &bd_fs_get_mountpoint);
	register_symbol("bd_fs_is_mountpoint", &bd_fs_is_mountpoint);
	register_symbol("bd_fs_mount", &bd_fs_mount);
	register_symbol("bd_fs_unmount", &bd_fs_unmount);
	register_symbol("bd_fs_ntfs_check", &bd_fs_ntfs_check);
	register_symbol("bd_fs_ntfs_check_label", &bd_fs_ntfs_check_label);
	register_symbol("bd_fs_ntfs_check_uuid", &bd_fs_ntfs_check_uuid);
	register_symbol("bd_fs_ntfs_get_info", &bd_fs_ntfs_get_info);
	register_symbol("bd_fs_ntfs_get_min_size", &bd_fs_ntfs_get_min_size);
	register_symbol("bd_fs_ntfs_info_copy", &bd_fs_ntfs_info_copy);
	register_symbol("bd_fs_ntfs_info_free", &bd_fs_ntfs_info_free);
	register_symbol("bd_fs_ntfs_is_tech_avail", &bd_fs_ntfs_is_tech_avail);
	register_symbol("bd_fs_ntfs_mkfs", &bd_fs_ntfs_mkfs);
	register_symbol("bd_fs_ntfs_mkfs_options", &bd_fs_ntfs_mkfs_options);
	register_symbol("bd_fs_ntfs_repair", &bd_fs_ntfs_repair);
	register_symbol("bd_fs_ntfs_resize", &bd_fs_ntfs_resize);
	register_symbol("bd_fs_ntfs_set_label", &bd_fs_ntfs_set_label);
	register_symbol("bd_fs_ntfs_set_uuid", &bd_fs_ntfs_set_uuid);
	register_symbol("bd_fs_vfat_check", &bd_fs_vfat_check);
	register_symbol("bd_fs_vfat_check_label", &bd_fs_vfat_check_label);
	register_symbol("bd_fs_vfat_check_uuid", &bd_fs_vfat_check_uuid);
	register_symbol("bd_fs_vfat_get_info", &bd_fs_vfat_get_info);
	register_symbol("bd_fs_vfat_info_copy", &bd_fs_vfat_info_copy);
	register_symbol("bd_fs_vfat_info_free", &bd_fs_vfat_info_free);
	register_symbol("bd_fs_vfat_is_tech_avail", &bd_fs_vfat_is_tech_avail);
	register_symbol("bd_fs_vfat_mkfs", &bd_fs_vfat_mkfs);
	register_symbol("bd_fs_vfat_mkfs_options", &bd_fs_vfat_mkfs_options);
	register_symbol("bd_fs_vfat_repair", &bd_fs_vfat_repair);
	register_symbol("bd_fs_vfat_resize", &bd_fs_vfat_resize);
	register_symbol("bd_fs_vfat_set_label", &bd_fs_vfat_set_label);
	register_symbol("bd_fs_vfat_set_uuid", &bd_fs_vfat_set_uuid);
	register_symbol("bd_fs_xfs_check", &bd_fs_xfs_check);
	register_symbol("bd_fs_xfs_check_label", &bd_fs_xfs_check_label);
	register_symbol("bd_fs_xfs_check_uuid", &bd_fs_xfs_check_uuid);
	register_symbol("bd_fs_xfs_get_info", &bd_fs_xfs_get_info);
	register_symbol("bd_fs_xfs_info_copy", &bd_fs_xfs_info_copy);
	register_symbol("bd_fs_xfs_info_free", &bd_fs_xfs_info_free);
	register_symbol("bd_fs_xfs_is_tech_avail", &bd_fs_xfs_is_tech_avail);
	register_symbol("bd_fs_xfs_mkfs", &bd_fs_xfs_mkfs);
	register_symbol("bd_fs_xfs_mkfs_options", &bd_fs_xfs_mkfs_options);
	register_symbol("bd_fs_xfs_repair", &bd_fs_xfs_repair);
	register_symbol("bd_fs_xfs_resize", &bd_fs_xfs_resize);
	register_symbol("bd_fs_xfs_set_label", &bd_fs_xfs_set_label);
	register_symbol("bd_fs_xfs_set_uuid", &bd_fs_xfs_set_uuid);
	register_symbol("bd_fs_f2fs_check", &bd_fs_f2fs_check);
	register_symbol("bd_fs_f2fs_check_label", &bd_fs_f2fs_check_label);
	register_symbol("bd_fs_f2fs_get_info", &bd_fs_f2fs_get_info);
	register_symbol("bd_fs_f2fs_info_copy", &bd_fs_f2fs_info_copy);
	register_symbol("bd_fs_f2fs_info_free", &bd_fs_f2fs_info_free);
	register_symbol("bd_fs_f2fs_is_tech_avail", &bd_fs_f2fs_is_tech_avail);
	register_symbol("bd_fs_f2fs_mkfs", &bd_fs_f2fs_mkfs);
	register_symbol("bd_fs_f2fs_mkfs_options", &bd_fs_f2fs_mkfs_options);
	register_symbol("bd_fs_f2fs_repair", &bd_fs_f2fs_repair);
	register_symbol("bd_fs_f2fs_resize", &bd_fs_f2fs_resize);
	register_symbol("bd_fs_nilfs2_check_label", &bd_fs_nilfs2_check_label);
	register_symbol("bd_fs_nilfs2_check_uuid", &bd_fs_nilfs2_check_uuid);
	register_symbol("bd_fs_nilfs2_get_info", &bd_fs_nilfs2_get_info);
	register_symbol("bd_fs_nilfs2_info_copy", &bd_fs_nilfs2_info_copy);
	register_symbol("bd_fs_nilfs2_info_free", &bd_fs_nilfs2_info_free);
	register_symbol("bd_fs_nilfs2_is_tech_avail", &bd_fs_nilfs2_is_tech_avail);
	register_symbol("bd_fs_nilfs2_mkfs", &bd_fs_nilfs2_mkfs);
	register_symbol("bd_fs_nilfs2_mkfs_options", &bd_fs_nilfs2_mkfs_options);
	register_symbol("bd_fs_nilfs2_resize", &bd_fs_nilfs2_resize);
	register_symbol("bd_fs_nilfs2_set_label", &bd_fs_nilfs2_set_label);
	register_symbol("bd_fs_nilfs2_set_uuid", &bd_fs_nilfs2_set_uuid);
	register_symbol("bd_fs_exfat_check", &bd_fs_exfat_check);
	register_symbol("bd_fs_exfat_check_label", &bd_fs_exfat_check_label);
	register_symbol("bd_fs_exfat_check_uuid", &bd_fs_exfat_check_uuid);
	register_symbol("bd_fs_exfat_get_info", &bd_fs_exfat_get_info);
	register_symbol("bd_fs_exfat_info_copy", &bd_fs_exfat_info_copy);
	register_symbol("bd_fs_exfat_info_free", &bd_fs_exfat_info_free);
	register_symbol("bd_fs_exfat_is_tech_avail", &bd_fs_exfat_is_tech_avail);
	register_symbol("bd_fs_exfat_mkfs", &bd_fs_exfat_mkfs);
	register_symbol("bd_fs_exfat_mkfs_options", &bd_fs_exfat_mkfs_options);
	register_symbol("bd_fs_exfat_repair", &bd_fs_exfat_repair);
	register_symbol("bd_fs_exfat_set_label", &bd_fs_exfat_set_label);
	register_symbol("bd_fs_exfat_set_uuid", &bd_fs_exfat_set_uuid);
	register_symbol("bd_fs_btrfs_check", &bd_fs_btrfs_check);
	register_symbol("bd_fs_btrfs_check_label", &bd_fs_btrfs_check_label);
	register_symbol("bd_fs_btrfs_check_uuid", &bd_fs_btrfs_check_uuid);
	register_symbol("bd_fs_btrfs_get_info", &bd_fs_btrfs_get_info);
	register_symbol("bd_fs_btrfs_info_copy", &bd_fs_btrfs_info_copy);
	register_symbol("bd_fs_btrfs_info_free", &bd_fs_btrfs_info_free);
	register_symbol("bd_fs_btrfs_is_tech_avail", &bd_fs_btrfs_is_tech_avail);
	register_symbol("bd_fs_btrfs_mkfs", &bd_fs_btrfs_mkfs);
	register_symbol("bd_fs_btrfs_mkfs_options", &bd_fs_btrfs_mkfs_options);
	register_symbol("bd_fs_btrfs_repair", &bd_fs_btrfs_repair);
	register_symbol("bd_fs_btrfs_resize", &bd_fs_btrfs_resize);
	register_symbol("bd_fs_btrfs_set_label", &bd_fs_btrfs_set_label);
	register_symbol("bd_fs_btrfs_set_uuid", &bd_fs_btrfs_set_uuid);
	register_symbol("bd_fs_udf_check_label", &bd_fs_udf_check_label);
	register_symbol("bd_fs_udf_check_uuid", &bd_fs_udf_check_uuid);
	register_symbol("bd_fs_udf_get_info", &bd_fs_udf_get_info);
	register_symbol("bd_fs_udf_info_copy", &bd_fs_udf_info_copy);
	register_symbol("bd_fs_udf_info_free", &bd_fs_udf_info_free);
	register_symbol("bd_fs_udf_is_tech_avail", &bd_fs_udf_is_tech_avail);
	register_symbol("bd_fs_udf_mkfs", &bd_fs_udf_mkfs);
	register_symbol("bd_fs_udf_mkfs_options", &bd_fs_udf_mkfs_options);
	register_symbol("bd_fs_udf_set_label", &bd_fs_udf_set_label);
	register_symbol("bd_fs_udf_set_uuid", &bd_fs_udf_set_uuid);


	register_symbol("bd_nvme_close", &bd_nvme_close);
	register_symbol("bd_nvme_init", &bd_nvme_init);
	register_symbol("bd_nvme_is_tech_avail", &bd_nvme_is_tech_avail);
	register_symbol("bd_nvme_controller_info_copy", &bd_nvme_controller_info_copy);
	register_symbol("bd_nvme_controller_info_free", &bd_nvme_controller_info_free);
	register_symbol("bd_nvme_error_log_entry_copy", &bd_nvme_error_log_entry_copy);
	register_symbol("bd_nvme_error_log_entry_free", &bd_nvme_error_log_entry_free);
	register_symbol("bd_nvme_get_controller_info", &bd_nvme_get_controller_info);
	register_symbol("bd_nvme_get_error_log_entries", &bd_nvme_get_error_log_entries);
	register_symbol("bd_nvme_get_namespace_info", &bd_nvme_get_namespace_info);
	register_symbol("bd_nvme_get_sanitize_log", &bd_nvme_get_sanitize_log);
	register_symbol("bd_nvme_get_self_test_log", &bd_nvme_get_self_test_log);
	register_symbol("bd_nvme_get_smart_log", &bd_nvme_get_smart_log);
	register_symbol("bd_nvme_lba_format_copy", &bd_nvme_lba_format_copy);
	register_symbol("bd_nvme_lba_format_free", &bd_nvme_lba_format_free);
	register_symbol("bd_nvme_namespace_info_copy", &bd_nvme_namespace_info_copy);
	register_symbol("bd_nvme_namespace_info_free", &bd_nvme_namespace_info_free);
	register_symbol("bd_nvme_sanitize_log_copy", &bd_nvme_sanitize_log_copy);
	register_symbol("bd_nvme_sanitize_log_free", &bd_nvme_sanitize_log_free);
	register_symbol("bd_nvme_self_test_log_copy", &bd_nvme_self_test_log_copy);
	register_symbol("bd_nvme_self_test_log_entry_copy", &bd_nvme_self_test_log_entry_copy);
	register_symbol("bd_nvme_self_test_log_entry_free", &bd_nvme_self_test_log_entry_free);
	register_symbol("bd_nvme_self_test_log_free", &bd_nvme_self_test_log_free);
	register_symbol("bd_nvme_self_test_result_to_string", &bd_nvme_self_test_result_to_string);
	register_symbol("bd_nvme_smart_log_copy", &bd_nvme_smart_log_copy);
	register_symbol("bd_nvme_smart_log_free", &bd_nvme_smart_log_free);
	register_symbol("bd_nvme_error_quark", &bd_nvme_error_quark);
	register_symbol("bd_nvme_device_self_test", &bd_nvme_device_self_test);
	register_symbol("bd_nvme_format", &bd_nvme_format);
	register_symbol("bd_nvme_sanitize", &bd_nvme_sanitize);
	register_symbol("bd_nvme_connect", &bd_nvme_connect);
	register_symbol("bd_nvme_disconnect", &bd_nvme_disconnect);
	register_symbol("bd_nvme_disconnect_by_path", &bd_nvme_disconnect_by_path);
	register_symbol("bd_nvme_find_ctrls_for_ns", &bd_nvme_find_ctrls_for_ns);
	register_symbol("bd_nvme_generate_host_nqn", &bd_nvme_generate_host_nqn);
	register_symbol("bd_nvme_get_host_id", &bd_nvme_get_host_id);
	register_symbol("bd_nvme_get_host_nqn", &bd_nvme_get_host_nqn);
	register_symbol("bd_nvme_set_host_id", &bd_nvme_set_host_id);
	register_symbol("bd_nvme_set_host_nqn", &bd_nvme_set_host_nqn);

};

// symbol count: 356
