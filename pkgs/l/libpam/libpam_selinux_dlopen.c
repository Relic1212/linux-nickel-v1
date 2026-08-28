
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#define HAVE_EXTRA

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

const char* lib__usr_lib_security_pam_access_so = "lib__usr_lib_security_pam_access_so";
const char* lib__usr_lib_security_pam_canonicalize_user_so = "lib__usr_lib_security_pam_canonicalize_user_so";
const char* lib__usr_lib_security_pam_debug_so = "lib__usr_lib_security_pam_debug_so";
const char* lib__usr_lib_security_pam_deny_so = "lib__usr_lib_security_pam_deny_so";
const char* lib__usr_lib_security_pam_echo_so = "lib__usr_lib_security_pam_echo_so";
const char* lib__usr_lib_security_pam_env_so = "lib__usr_lib_security_pam_env_so";
const char* lib__usr_lib_security_pam_exec_so = "lib__usr_lib_security_pam_exec_so";
const char* lib__usr_lib_security_pam_faildelay_so = "lib__usr_lib_security_pam_faildelay_so";
const char* lib__usr_lib_security_pam_faillock_so = "lib__usr_lib_security_pam_faillock_so";
const char* lib__usr_lib_security_pam_filter_so = "lib__usr_lib_security_pam_filter_so";
const char* lib__usr_lib_security_pam_ftp_so = "lib__usr_lib_security_pam_ftp_so";
const char* lib__usr_lib_security_pam_group_so = "lib__usr_lib_security_pam_group_so";
const char* lib__usr_lib_security_pam_issue_so = "lib__usr_lib_security_pam_issue_so";
const char* lib__usr_lib_security_pam_keyinit_so = "lib__usr_lib_security_pam_keyinit_so";
const char* lib__usr_lib_security_pam_limits_so = "lib__usr_lib_security_pam_limits_so";
const char* lib__usr_lib_security_pam_listfile_so = "lib__usr_lib_security_pam_listfile_so";
const char* lib__usr_lib_security_pam_localuser_so = "lib__usr_lib_security_pam_localuser_so";
const char* lib__usr_lib_security_pam_loginuid_so = "lib__usr_lib_security_pam_loginuid_so";
const char* lib__usr_lib_security_pam_mail_so = "lib__usr_lib_security_pam_mail_so";
const char* lib__usr_lib_security_pam_mkhomedir_so = "lib__usr_lib_security_pam_mkhomedir_so";
const char* lib__usr_lib_security_pam_motd_so = "lib__usr_lib_security_pam_motd_so";
const char* lib__usr_lib_security_pam_namespace_so = "lib__usr_lib_security_pam_namespace_so";
const char* lib__usr_lib_security_pam_nologin_so = "lib__usr_lib_security_pam_nologin_so";
const char* lib__usr_lib_security_pam_permit_so = "lib__usr_lib_security_pam_permit_so";
const char* lib__usr_lib_security_pam_pwhistory_so = "lib__usr_lib_security_pam_pwhistory_so";
const char* lib__usr_lib_security_pam_rootok_so = "lib__usr_lib_security_pam_rootok_so";
const char* lib__usr_lib_security_pam_securetty_so = "lib__usr_lib_security_pam_securetty_so";
const char* lib__usr_lib_security_pam_selinux_so = "lib__usr_lib_security_pam_selinux_so";
const char* lib__usr_lib_security_pam_sepermit_so = "lib__usr_lib_security_pam_sepermit_so";
const char* lib__usr_lib_security_pam_setquota_so = "lib__usr_lib_security_pam_setquota_so";
const char* lib__usr_lib_security_pam_shells_so = "lib__usr_lib_security_pam_shells_so";
const char* lib__usr_lib_security_pam_stress_so = "lib__usr_lib_security_pam_stress_so";
const char* lib__usr_lib_security_pam_succeed_if_so = "lib__usr_lib_security_pam_succeed_if_so";
const char* lib__usr_lib_security_pam_time_so = "lib__usr_lib_security_pam_time_so";
const char* lib__usr_lib_security_pam_timestamp_so = "lib__usr_lib_security_pam_timestamp_so";
const char* lib__usr_lib_security_pam_tty_audit_so = "lib__usr_lib_security_pam_tty_audit_so";
const char* lib__usr_lib_security_pam_umask_so = "lib__usr_lib_security_pam_umask_so";
const char* lib__usr_lib_security_pam_unix_so = "lib__usr_lib_security_pam_unix_so";
const char* lib__usr_lib_security_pam_usertype_so = "lib__usr_lib_security_pam_usertype_so";
const char* lib__usr_lib_security_pam_warn_so = "lib__usr_lib_security_pam_warn_so";
const char* lib__usr_lib_security_pam_wheel_so = "lib__usr_lib_security_pam_wheel_so";
const char* lib__usr_lib_security_pam_xauth_so = "lib__usr_lib_security_pam_xauth_so";
#ifdef HAVE_EXTRA
const char* lib__usr_lib_security_pam_elogind_so = "lib__usr_lib_security_pam_elogind_so";
const char* lib__usr_lib_security_pam_gnome_keyring_so = "lib__usr_lib_security_pam_gnome_keyring_so";
#endif // HAVE_EXTRA

void* dlopen(const char *path, int mode) {
	if (path == NULL) { return &main_program_handle; }
	if (strcmp( path, "/usr/lib/security/pam_access.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_access.so (handle=%p)\n", &lib__usr_lib_security_pam_access_so); return &lib__usr_lib_security_pam_access_so; }
	if (strcmp( path, "/usr/lib/security/pam_canonicalize_user.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_canonicalize_user.so (handle=%p)\n", &lib__usr_lib_security_pam_canonicalize_user_so); return &lib__usr_lib_security_pam_canonicalize_user_so; }
	if (strcmp( path, "/usr/lib/security/pam_debug.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_debug.so (handle=%p)\n", &lib__usr_lib_security_pam_debug_so); return &lib__usr_lib_security_pam_debug_so; }
	if (strcmp( path, "/usr/lib/security/pam_deny.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_deny.so (handle=%p)\n", &lib__usr_lib_security_pam_deny_so); return &lib__usr_lib_security_pam_deny_so; }
	if (strcmp( path, "/usr/lib/security/pam_echo.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_echo.so (handle=%p)\n", &lib__usr_lib_security_pam_echo_so); return &lib__usr_lib_security_pam_echo_so; }
	if (strcmp( path, "/usr/lib/security/pam_env.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_env.so (handle=%p)\n", &lib__usr_lib_security_pam_env_so); return &lib__usr_lib_security_pam_env_so; }
	if (strcmp( path, "/usr/lib/security/pam_exec.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_exec.so (handle=%p)\n", &lib__usr_lib_security_pam_exec_so); return &lib__usr_lib_security_pam_exec_so; }
	if (strcmp( path, "/usr/lib/security/pam_faildelay.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_faildelay.so (handle=%p)\n", &lib__usr_lib_security_pam_faildelay_so); return &lib__usr_lib_security_pam_faildelay_so; }
	if (strcmp( path, "/usr/lib/security/pam_faillock.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_faillock.so (handle=%p)\n", &lib__usr_lib_security_pam_faillock_so); return &lib__usr_lib_security_pam_faillock_so; }
	if (strcmp( path, "/usr/lib/security/pam_filter.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_filter.so (handle=%p)\n", &lib__usr_lib_security_pam_filter_so); return &lib__usr_lib_security_pam_filter_so; }
	if (strcmp( path, "/usr/lib/security/pam_ftp.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_ftp.so (handle=%p)\n", &lib__usr_lib_security_pam_ftp_so); return &lib__usr_lib_security_pam_ftp_so; }
	if (strcmp( path, "/usr/lib/security/pam_group.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_group.so (handle=%p)\n", &lib__usr_lib_security_pam_group_so); return &lib__usr_lib_security_pam_group_so; }
	if (strcmp( path, "/usr/lib/security/pam_issue.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_issue.so (handle=%p)\n", &lib__usr_lib_security_pam_issue_so); return &lib__usr_lib_security_pam_issue_so; }
	if (strcmp( path, "/usr/lib/security/pam_keyinit.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_keyinit.so (handle=%p)\n", &lib__usr_lib_security_pam_keyinit_so); return &lib__usr_lib_security_pam_keyinit_so; }
	if (strcmp( path, "/usr/lib/security/pam_limits.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_limits.so (handle=%p)\n", &lib__usr_lib_security_pam_limits_so); return &lib__usr_lib_security_pam_limits_so; }
	if (strcmp( path, "/usr/lib/security/pam_listfile.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_listfile.so (handle=%p)\n", &lib__usr_lib_security_pam_listfile_so); return &lib__usr_lib_security_pam_listfile_so; }
	if (strcmp( path, "/usr/lib/security/pam_localuser.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_localuser.so (handle=%p)\n", &lib__usr_lib_security_pam_localuser_so); return &lib__usr_lib_security_pam_localuser_so; }
	if (strcmp( path, "/usr/lib/security/pam_loginuid.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_loginuid.so (handle=%p)\n", &lib__usr_lib_security_pam_loginuid_so); return &lib__usr_lib_security_pam_loginuid_so; }
	if (strcmp( path, "/usr/lib/security/pam_mail.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_mail.so (handle=%p)\n", &lib__usr_lib_security_pam_mail_so); return &lib__usr_lib_security_pam_mail_so; }
	if (strcmp( path, "/usr/lib/security/pam_mkhomedir.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_mkhomedir.so (handle=%p)\n", &lib__usr_lib_security_pam_mkhomedir_so); return &lib__usr_lib_security_pam_mkhomedir_so; }
	if (strcmp( path, "/usr/lib/security/pam_motd.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_motd.so (handle=%p)\n", &lib__usr_lib_security_pam_motd_so); return &lib__usr_lib_security_pam_motd_so; }
	if (strcmp( path, "/usr/lib/security/pam_namespace.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_namespace.so (handle=%p)\n", &lib__usr_lib_security_pam_namespace_so); return &lib__usr_lib_security_pam_namespace_so; }
	if (strcmp( path, "/usr/lib/security/pam_nologin.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_nologin.so (handle=%p)\n", &lib__usr_lib_security_pam_nologin_so); return &lib__usr_lib_security_pam_nologin_so; }
	if (strcmp( path, "/usr/lib/security/pam_permit.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_permit.so (handle=%p)\n", &lib__usr_lib_security_pam_permit_so); return &lib__usr_lib_security_pam_permit_so; }
	if (strcmp( path, "/usr/lib/security/pam_pwhistory.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_pwhistory.so (handle=%p)\n", &lib__usr_lib_security_pam_pwhistory_so); return &lib__usr_lib_security_pam_pwhistory_so; }
	if (strcmp( path, "/usr/lib/security/pam_rootok.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_rootok.so (handle=%p)\n", &lib__usr_lib_security_pam_rootok_so); return &lib__usr_lib_security_pam_rootok_so; }
	if (strcmp( path, "/usr/lib/security/pam_securetty.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_securetty.so (handle=%p)\n", &lib__usr_lib_security_pam_securetty_so); return &lib__usr_lib_security_pam_securetty_so; }
	if (strcmp( path, "/usr/lib/security/pam_selinux.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_selinux.so (handle=%p)\n", &lib__usr_lib_security_pam_selinux_so); return &lib__usr_lib_security_pam_selinux_so; }
	if (strcmp( path, "/usr/lib/security/pam_sepermit.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_sepermit.so (handle=%p)\n", &lib__usr_lib_security_pam_sepermit_so); return &lib__usr_lib_security_pam_sepermit_so; }
	if (strcmp( path, "/usr/lib/security/pam_setquota.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_setquota.so (handle=%p)\n", &lib__usr_lib_security_pam_setquota_so); return &lib__usr_lib_security_pam_setquota_so; }
	if (strcmp( path, "/usr/lib/security/pam_shells.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_shells.so (handle=%p)\n", &lib__usr_lib_security_pam_shells_so); return &lib__usr_lib_security_pam_shells_so; }
	if (strcmp( path, "/usr/lib/security/pam_stress.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_stress.so (handle=%p)\n", &lib__usr_lib_security_pam_stress_so); return &lib__usr_lib_security_pam_stress_so; }
	if (strcmp( path, "/usr/lib/security/pam_succeed_if.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_succeed_if.so (handle=%p)\n", &lib__usr_lib_security_pam_succeed_if_so); return &lib__usr_lib_security_pam_succeed_if_so; }
	if (strcmp( path, "/usr/lib/security/pam_time.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_time.so (handle=%p)\n", &lib__usr_lib_security_pam_time_so); return &lib__usr_lib_security_pam_time_so; }
	if (strcmp( path, "/usr/lib/security/pam_timestamp.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_timestamp.so (handle=%p)\n", &lib__usr_lib_security_pam_timestamp_so); return &lib__usr_lib_security_pam_timestamp_so; }
	if (strcmp( path, "/usr/lib/security/pam_tty_audit.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_tty_audit.so (handle=%p)\n", &lib__usr_lib_security_pam_tty_audit_so); return &lib__usr_lib_security_pam_tty_audit_so; }
	if (strcmp( path, "/usr/lib/security/pam_umask.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_umask.so (handle=%p)\n", &lib__usr_lib_security_pam_umask_so); return &lib__usr_lib_security_pam_umask_so; }
	if (strcmp( path, "/usr/lib/security/pam_unix.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_unix.so (handle=%p)\n", &lib__usr_lib_security_pam_unix_so); return &lib__usr_lib_security_pam_unix_so; }
	if (strcmp( path, "/usr/lib/security/pam_usertype.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_usertype.so (handle=%p)\n", &lib__usr_lib_security_pam_usertype_so); return &lib__usr_lib_security_pam_usertype_so; }
	if (strcmp( path, "/usr/lib/security/pam_warn.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_warn.so (handle=%p)\n", &lib__usr_lib_security_pam_warn_so); return &lib__usr_lib_security_pam_warn_so; }
	if (strcmp( path, "/usr/lib/security/pam_wheel.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_wheel.so (handle=%p)\n", &lib__usr_lib_security_pam_wheel_so); return &lib__usr_lib_security_pam_wheel_so; }
	if (strcmp( path, "/usr/lib/security/pam_xauth.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_xauth.so (handle=%p)\n", &lib__usr_lib_security_pam_xauth_so); return &lib__usr_lib_security_pam_xauth_so; }

#ifdef HAVE_EXTRA
    if (strcmp( path, "/usr/lib/security/pam_elogind.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_elogind.so (handle=%p)\n", &lib__usr_lib_security_pam_elogind_so); return &lib__usr_lib_security_pam_elogind_so; }
	if (strcmp( path, "/usr/lib/security/pam_gnome_keyring.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/security/pam_gnome_keyring.so (handle=%p)\n", &lib__usr_lib_security_pam_gnome_keyring_so); return &lib__usr_lib_security_pam_gnome_keyring_so; }
#endif // HAVE_EXTRA
    fprintf(stderr, "(dlopen) WARNING: failed for path %s\n", path);	return stub_dlopen(path, mode);
}

void* dlsym(void *__restrict handle, const char *__restrict symbol) {
	if (handle == &lib__usr_lib_security_pam_access_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_access__)
		DLSYM(pam_sm_authenticate, pam_access__)
		DLSYM(pam_sm_chauthtok, pam_access__)
		DLSYM(pam_sm_close_session, pam_access__)
		DLSYM(pam_sm_open_session, pam_access__)
		DLSYM(pam_sm_setcred, pam_access__)
	}
	if (handle == &lib__usr_lib_security_pam_canonicalize_user_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_authenticate, pam_canonicalize_user__)
		DLSYM(pam_sm_setcred, pam_canonicalize_user__)
	}
	if (handle == &lib__usr_lib_security_pam_debug_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_debug__)
		DLSYM(pam_sm_authenticate, pam_debug__)
		DLSYM(pam_sm_chauthtok, pam_debug__)
		DLSYM(pam_sm_close_session, pam_debug__)
		DLSYM(pam_sm_open_session, pam_debug__)
		DLSYM(pam_sm_setcred, pam_debug__)
	}
	if (handle == &lib__usr_lib_security_pam_deny_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_deny__)
		DLSYM(pam_sm_authenticate, pam_deny__)
		DLSYM(pam_sm_chauthtok, pam_deny__)
		DLSYM(pam_sm_close_session, pam_deny__)
		DLSYM(pam_sm_open_session, pam_deny__)
		DLSYM(pam_sm_setcred, pam_deny__)
	}
	if (handle == &lib__usr_lib_security_pam_echo_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_echo__)
		DLSYM(pam_sm_authenticate, pam_echo__)
		DLSYM(pam_sm_chauthtok, pam_echo__)
		DLSYM(pam_sm_close_session, pam_echo__)
		DLSYM(pam_sm_open_session, pam_echo__)
		DLSYM(pam_sm_setcred, pam_echo__)
	}
	if (handle == &lib__usr_lib_security_pam_env_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_env__)
		DLSYM(pam_sm_authenticate, pam_env__)
		DLSYM(pam_sm_chauthtok, pam_env__)
		DLSYM(pam_sm_close_session, pam_env__)
		DLSYM(pam_sm_open_session, pam_env__)
		DLSYM(pam_sm_setcred, pam_env__)
	}
	if (handle == &lib__usr_lib_security_pam_exec_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_exec__)
		DLSYM(pam_sm_authenticate, pam_exec__)
		DLSYM(pam_sm_chauthtok, pam_exec__)
		DLSYM(pam_sm_close_session, pam_exec__)
		DLSYM(pam_sm_open_session, pam_exec__)
		DLSYM(pam_sm_setcred, pam_exec__)
	}
	if (handle == &lib__usr_lib_security_pam_faildelay_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_authenticate, pam_faildelay__)
		DLSYM(pam_sm_setcred, pam_faildelay__)
	}
	if (handle == &lib__usr_lib_security_pam_faillock_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_faillock__)
		DLSYM(pam_sm_authenticate, pam_faillock__)
		DLSYM(pam_sm_setcred, pam_faillock__)
	}
	if (handle == &lib__usr_lib_security_pam_filter_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_filter__)
		DLSYM(pam_sm_authenticate, pam_filter__)
		DLSYM(pam_sm_chauthtok, pam_filter__)
		DLSYM(pam_sm_close_session, pam_filter__)
		DLSYM(pam_sm_open_session, pam_filter__)
		DLSYM(pam_sm_setcred, pam_filter__)
	}
	if (handle == &lib__usr_lib_security_pam_ftp_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_authenticate, pam_ftp__)
		DLSYM(pam_sm_setcred, pam_ftp__)
	}
	if (handle == &lib__usr_lib_security_pam_group_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_authenticate, pam_group__)
		DLSYM(pam_sm_setcred, pam_group__)
	}
	if (handle == &lib__usr_lib_security_pam_issue_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_authenticate, pam_issue__)
		DLSYM(pam_sm_setcred, pam_issue__)
	}
	if (handle == &lib__usr_lib_security_pam_keyinit_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_authenticate, pam_keyinit__)
		DLSYM(pam_sm_close_session, pam_keyinit__)
		DLSYM(pam_sm_open_session, pam_keyinit__)
		DLSYM(pam_sm_setcred, pam_keyinit__)
	}
	if (handle == &lib__usr_lib_security_pam_limits_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_close_session, pam_limits__)
		DLSYM(pam_sm_open_session, pam_limits__)
	}
	if (handle == &lib__usr_lib_security_pam_listfile_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_listfile__)
		DLSYM(pam_sm_authenticate, pam_listfile__)
		DLSYM(pam_sm_chauthtok, pam_listfile__)
		DLSYM(pam_sm_close_session, pam_listfile__)
		DLSYM(pam_sm_open_session, pam_listfile__)
		DLSYM(pam_sm_setcred, pam_listfile__)
	}
	if (handle == &lib__usr_lib_security_pam_localuser_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_localuser__)
		DLSYM(pam_sm_authenticate, pam_localuser__)
		DLSYM(pam_sm_chauthtok, pam_localuser__)
		DLSYM(pam_sm_close_session, pam_localuser__)
		DLSYM(pam_sm_open_session, pam_localuser__)
		DLSYM(pam_sm_setcred, pam_localuser__)
	}
	if (handle == &lib__usr_lib_security_pam_loginuid_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_loginuid__)
		DLSYM(pam_sm_close_session, pam_loginuid__)
		DLSYM(pam_sm_open_session, pam_loginuid__)
	}
	if (handle == &lib__usr_lib_security_pam_mail_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_authenticate, pam_mail__)
		DLSYM(pam_sm_close_session, pam_mail__)
		DLSYM(pam_sm_open_session, pam_mail__)
		DLSYM(pam_sm_setcred, pam_mail__)
	}
	if (handle == &lib__usr_lib_security_pam_mkhomedir_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_close_session, pam_mkhomedir__)
		DLSYM(pam_sm_open_session, pam_mkhomedir__)
	}
	if (handle == &lib__usr_lib_security_pam_motd_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_close_session, pam_motd__)
		DLSYM(pam_sm_open_session, pam_motd__)
	}
	if (handle == &lib__usr_lib_security_pam_namespace_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_close_session, pam_namespace__)
		DLSYM(pam_sm_open_session, pam_namespace__)
	}
	if (handle == &lib__usr_lib_security_pam_nologin_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_nologin__)
		DLSYM(pam_sm_authenticate, pam_nologin__)
		DLSYM(pam_sm_setcred, pam_nologin__)
	}
	if (handle == &lib__usr_lib_security_pam_permit_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_permit__)
		DLSYM(pam_sm_authenticate, pam_permit__)
		DLSYM(pam_sm_chauthtok, pam_permit__)
		DLSYM(pam_sm_close_session, pam_permit__)
		DLSYM(pam_sm_open_session, pam_permit__)
		DLSYM(pam_sm_setcred, pam_permit__)
	}
	if (handle == &lib__usr_lib_security_pam_pwhistory_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_chauthtok, pam_pwhistory__)
	}
	if (handle == &lib__usr_lib_security_pam_rootok_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_rootok__)
		DLSYM(pam_sm_authenticate, pam_rootok__)
		DLSYM(pam_sm_chauthtok, pam_rootok__)
		DLSYM(pam_sm_setcred, pam_rootok__)
	}
	if (handle == &lib__usr_lib_security_pam_securetty_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_securetty__)
		DLSYM(pam_sm_authenticate, pam_securetty__)
		DLSYM(pam_sm_setcred, pam_securetty__)
	}
	if (handle == &lib__usr_lib_security_pam_selinux_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_authenticate, pam_selinux__)
		DLSYM(pam_sm_close_session, pam_selinux__)
		DLSYM(pam_sm_open_session, pam_selinux__)
		DLSYM(pam_sm_setcred, pam_selinux__)
	}
	if (handle == &lib__usr_lib_security_pam_sepermit_so || handle == NULL || handle == &main_program_handle) { 
	}
	if (handle == &lib__usr_lib_security_pam_setquota_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_close_session, pam_setquota__)
		DLSYM(pam_sm_open_session, pam_setquota__)
	}
	if (handle == &lib__usr_lib_security_pam_shells_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_shells__)
		DLSYM(pam_sm_authenticate, pam_shells__)
		DLSYM(pam_sm_setcred, pam_shells__)
	}
	if (handle == &lib__usr_lib_security_pam_stress_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_stress__)
		DLSYM(pam_sm_authenticate, pam_stress__)
		DLSYM(pam_sm_chauthtok, pam_stress__)
		DLSYM(pam_sm_close_session, pam_stress__)
		DLSYM(pam_sm_open_session, pam_stress__)
		DLSYM(pam_sm_setcred, pam_stress__)
	}
	if (handle == &lib__usr_lib_security_pam_succeed_if_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_succeed_if__)
		DLSYM(pam_sm_authenticate, pam_succeed_if__)
		DLSYM(pam_sm_chauthtok, pam_succeed_if__)
		DLSYM(pam_sm_close_session, pam_succeed_if__)
		DLSYM(pam_sm_open_session, pam_succeed_if__)
		DLSYM(pam_sm_setcred, pam_succeed_if__)
	}
	if (handle == &lib__usr_lib_security_pam_time_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_time__)
	}
	if (handle == &lib__usr_lib_security_pam_timestamp_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_authenticate, pam_timestamp__)
		DLSYM(pam_sm_close_session, pam_timestamp__)
		DLSYM(pam_sm_open_session, pam_timestamp__)
		DLSYM(pam_sm_setcred, pam_timestamp__)
	}
	if (handle == &lib__usr_lib_security_pam_tty_audit_so || handle == NULL || handle == &main_program_handle) { 
	}
	if (handle == &lib__usr_lib_security_pam_umask_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_close_session, pam_umask__)
		DLSYM(pam_sm_open_session, pam_umask__)
	}
	if (handle == &lib__usr_lib_security_pam_unix_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_unix__)
		DLSYM(pam_sm_authenticate, pam_unix__)
		DLSYM(pam_sm_setcred, pam_unix__)
		DLSYM(pam_sm_chauthtok, pam_unix__)
		DLSYM(pam_sm_close_session, pam_unix__)
		DLSYM(pam_sm_open_session, pam_unix__)
	}
	if (handle == &lib__usr_lib_security_pam_usertype_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_usertype__)
		DLSYM(pam_sm_authenticate, pam_usertype__)
		DLSYM(pam_sm_chauthtok, pam_usertype__)
		DLSYM(pam_sm_close_session, pam_usertype__)
		DLSYM(pam_sm_open_session, pam_usertype__)
		DLSYM(pam_sm_setcred, pam_usertype__)
	}
	if (handle == &lib__usr_lib_security_pam_warn_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_warn__)
		DLSYM(pam_sm_authenticate, pam_warn__)
		DLSYM(pam_sm_chauthtok, pam_warn__)
		DLSYM(pam_sm_close_session, pam_warn__)
		DLSYM(pam_sm_open_session, pam_warn__)
		DLSYM(pam_sm_setcred, pam_warn__)
	}
	if (handle == &lib__usr_lib_security_pam_wheel_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_acct_mgmt, pam_wheel__)
		DLSYM(pam_sm_authenticate, pam_wheel__)
		DLSYM(pam_sm_setcred, pam_wheel__)
	}
	if (handle == &lib__usr_lib_security_pam_xauth_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_close_session, pam_xauth__)
		DLSYM(pam_sm_open_session, pam_xauth__)
	}
    
#ifdef HAVE_EXTRA
	if (handle == &lib__usr_lib_security_pam_elogind_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_close_session, pam_elogind_)
		DLSYM(pam_sm_open_session, pam_elogind_)
	}
	if (handle == &lib__usr_lib_security_pam_gnome_keyring_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pam_sm_authenticate, pam_gnome_keyring_)
		DLSYM(pam_sm_chauthtok, pam_gnome_keyring_)
		DLSYM(pam_sm_close_session, pam_gnome_keyring_)
		DLSYM(pam_sm_open_session, pam_gnome_keyring_)
		DLSYM(pam_sm_setcred, pam_gnome_keyring_)
	}
#endif // HAVE_EXTRA

	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s (handle=%p)\n", symbol, handle);	return stub_dlsym(handle, symbol);
}


int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
    return stub_dladdr(handle, info);
}

