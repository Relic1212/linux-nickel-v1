
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

const char* lib_libxkbcommon_so_0_libxkbcommon_so = "lib_libxkbcommon_so_0_libxkbcommon_so";

void* dlopen(const char *path, int mode) {
	if (path == NULL) { return &main_program_handle; }
	if (strcmp( path, "libxkbcommon.so.0" ) == 0) { dbg_print("(dlopen) found library libxkbcommon.so.0 (handle=%p)\n", &lib_libxkbcommon_so_0_libxkbcommon_so); return &lib_libxkbcommon_so_0_libxkbcommon_so; }
	if (strcmp( path, "libxkbcommon.so" ) == 0) { dbg_print("(dlopen) found library libxkbcommon.so (handle=%p)\n", &lib_libxkbcommon_so_0_libxkbcommon_so); return &lib_libxkbcommon_so_0_libxkbcommon_so; }
	fprintf(stderr, "(dlopen) WARNING: failed for path %s\n", path);	return stub_dlopen(path, mode);
}

void* dlsym(void *__restrict handle, const char *__restrict symbol) {
	if (handle == &lib_libxkbcommon_so_0_libxkbcommon_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(xkb_compose_state_feed, )
		DLSYM(xkb_compose_state_get_compose_table, )
		DLSYM(xkb_compose_state_get_one_sym, )
		DLSYM(xkb_compose_state_get_status, )
		DLSYM(xkb_compose_state_get_utf8, )
		DLSYM(xkb_compose_state_new, )
		DLSYM(xkb_compose_state_ref, )
		DLSYM(xkb_compose_state_reset, )
		DLSYM(xkb_compose_state_unref, )
		DLSYM(xkb_compose_table_entry_keysym, )
		DLSYM(xkb_compose_table_entry_sequence, )
		DLSYM(xkb_compose_table_entry_utf8, )
		DLSYM(xkb_compose_table_iterator_free, )
		DLSYM(xkb_compose_table_iterator_new, )
		DLSYM(xkb_compose_table_iterator_next, )
		DLSYM(xkb_compose_table_new_from_buffer, )
		DLSYM(xkb_compose_table_new_from_file, )
		DLSYM(xkb_compose_table_new_from_locale, )
		DLSYM(xkb_compose_table_ref, )
		DLSYM(xkb_compose_table_unref, )
		DLSYM(xkb_file_type_to_string, )
		DLSYM(xkb_components_from_rmlvo_builder, )
		DLSYM(xkb_components_from_rules_names, )
		DLSYM(xkb_components_names_from_rules, )
		DLSYM(xkb_context_get_log_level, )
		DLSYM(xkb_context_get_log_verbosity, )
		DLSYM(xkb_context_get_user_data, )
		DLSYM(xkb_context_include_path_append, )
		DLSYM(xkb_context_include_path_append_default, )
		DLSYM(xkb_context_include_path_clear, )
		DLSYM(xkb_context_include_path_get, )
		DLSYM(xkb_context_include_path_get_extra_path, )
		DLSYM(xkb_context_include_path_get_system_path, )
		DLSYM(xkb_context_include_path_get_unversioned_extensions_path, )
		DLSYM(xkb_context_include_path_get_versioned_extensions_path, )
		DLSYM(xkb_context_include_path_reset_defaults, )
		DLSYM(xkb_context_new, )
		DLSYM(xkb_context_num_include_paths, )
		DLSYM(xkb_context_ref, )
		DLSYM(xkb_context_set_log_fn, )
		DLSYM(xkb_context_set_log_level, )
		DLSYM(xkb_context_set_log_verbosity, )
		DLSYM(xkb_context_set_user_data, )
		DLSYM(xkb_context_unref, )
		DLSYM(xkb_atom_intern, )
		DLSYM(xkb_atom_lookup, )
		DLSYM(xkb_atom_table_size, )
		DLSYM(xkb_atom_text, )
		DLSYM(xkb_context_failed_include_path_get, )
		DLSYM(xkb_context_get_buffer, )
		DLSYM(xkb_context_getenv, )
		DLSYM(xkb_context_init_includes, )
		DLSYM(xkb_context_num_failed_include_paths, )
		DLSYM(xkb_context_sanitize_rule_names, )
		DLSYM(xkb_log, )
		DLSYM(xkb_keysym_from_name, )
		DLSYM(xkb_keysym_get_explicit_names, )
		DLSYM(xkb_keysym_get_name, )
		DLSYM(xkb_keysym_is_assigned, )
		DLSYM(xkb_keysym_is_deprecated, )
		DLSYM(xkb_keysym_is_keypad, )
		DLSYM(xkb_keysym_is_modifier, )
		DLSYM(xkb_keysym_iterator_get_keysym, )
		DLSYM(xkb_keysym_iterator_get_name, )
		DLSYM(xkb_keysym_iterator_is_explicitly_named, )
		DLSYM(xkb_keysym_iterator_new, )
		DLSYM(xkb_keysym_iterator_next, )
		DLSYM(xkb_keysym_iterator_unref, )
		DLSYM(xkb_keysym_is_lower, )
		DLSYM(xkb_keysym_is_upper_or_title, )
		DLSYM(xkb_keysym_to_lower, )
		DLSYM(xkb_keysym_to_upper, )
		DLSYM(xkb_keysym_to_utf32, )
		DLSYM(xkb_keysym_to_utf8, )
		DLSYM(xkb_utf32_to_keysym, )
		DLSYM(xkb_keymap_get_as_string, )
		DLSYM(xkb_keymap_get_as_string2, )
		DLSYM(xkb_keymap_key_by_name, )
		DLSYM(xkb_keymap_key_for_each, )
		DLSYM(xkb_keymap_key_get_level, )
		DLSYM(xkb_keymap_key_get_mods_for_level, )
		DLSYM(xkb_keymap_key_get_name, )
		DLSYM(xkb_keymap_key_get_syms_by_level, )
		DLSYM(xkb_keymap_key_repeats, )
		DLSYM(xkb_keymap_layout_get_index, )
		DLSYM(xkb_keymap_layout_get_name, )
		DLSYM(xkb_keymap_led_get_index, )
		DLSYM(xkb_keymap_led_get_name, )
		DLSYM(xkb_keymap_max_keycode, )
		DLSYM(xkb_keymap_min_keycode, )
		DLSYM(xkb_keymap_mod_get_index, )
		DLSYM(xkb_keymap_mod_get_mask, )
		DLSYM(xkb_keymap_mod_get_mask2, )
		DLSYM(xkb_keymap_mod_get_name, )
		DLSYM(xkb_keymap_new_from_buffer, )
		DLSYM(xkb_keymap_new_from_file, )
		DLSYM(xkb_keymap_new_from_names, )
		DLSYM(xkb_keymap_new_from_names2, )
		DLSYM(xkb_keymap_new_from_rmlvo, )
		DLSYM(xkb_keymap_new_from_string, )
		DLSYM(xkb_keymap_num_layouts, )
		DLSYM(xkb_keymap_num_layouts_for_key, )
		DLSYM(xkb_keymap_num_leds, )
		DLSYM(xkb_keymap_num_levels_for_key, )
		DLSYM(xkb_keymap_num_mods, )
		DLSYM(xkb_keymap_ref, )
		DLSYM(xkb_keymap_unref, )
		DLSYM(xkb_keymap_compare, )
		DLSYM(xkb_keymap_key_get_actions_by_level, )
		DLSYM(xkb_keymap_new, )
		DLSYM(xkb_rmlvo_builder_append_layout, )
		DLSYM(xkb_rmlvo_builder_append_option, )
		DLSYM(xkb_rmlvo_builder_new, )
		DLSYM(xkb_rmlvo_builder_ref, )
		DLSYM(xkb_rmlvo_builder_to_rules_names, )
		DLSYM(xkb_rmlvo_builder_unref, )
		DLSYM(xkb_state_get_keymap, )
		DLSYM(xkb_state_key_get_consumed_mods, )
		DLSYM(xkb_state_key_get_consumed_mods2, )
		DLSYM(xkb_state_key_get_layout, )
		DLSYM(xkb_state_key_get_level, )
		DLSYM(xkb_state_key_get_one_sym, )
		DLSYM(xkb_state_key_get_syms, )
		DLSYM(xkb_state_key_get_utf32, )
		DLSYM(xkb_state_key_get_utf8, )
		DLSYM(xkb_state_layout_index_is_active, )
		DLSYM(xkb_state_layout_name_is_active, )
		DLSYM(xkb_state_led_index_is_active, )
		DLSYM(xkb_state_led_name_is_active, )
		DLSYM(xkb_state_mod_index_is_active, )
		DLSYM(xkb_state_mod_index_is_consumed, )
		DLSYM(xkb_state_mod_index_is_consumed2, )
		DLSYM(xkb_state_mod_indices_are_active, )
		DLSYM(xkb_state_mod_mask_remove_consumed, )
		DLSYM(xkb_state_mod_name_is_active, )
		DLSYM(xkb_state_mod_names_are_active, )
		DLSYM(xkb_state_new, )
		DLSYM(xkb_state_ref, )
		DLSYM(xkb_state_serialize_layout, )
		DLSYM(xkb_state_serialize_mods, )
		DLSYM(xkb_state_unref, )
		DLSYM(xkb_state_update_key, )
		DLSYM(xkb_state_update_latched_locked, )
		DLSYM(xkb_state_update_mask, )
	}
	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s\n", symbol);	return stub_dlsym(handle, symbol);
}


int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
    return stub_dladdr(handle, info);
}

