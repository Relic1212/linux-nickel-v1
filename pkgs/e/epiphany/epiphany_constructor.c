// #include <glib-2.0/gobject/gbindinggroup.h>
#include <glib-object.h>

extern void adw_stylesheet_get_resource(void);
extern void adw_get_resource(void);
// extern void library_init(void);
// extern void g_type_ensure(void);

__attribute__((weak)) void prefs_general_page_get_type(void){};

__attribute__((constructor)) void register_epiphany_internal()
{

	// library_init();
	adw_stylesheet_get_resource();
	adw_get_resource();
	prefs_general_page_get_type();
	g_type_ensure(G_TYPE_SIGNAL_GROUP);
	g_type_ensure(G_TYPE_BINDING_GROUP);

}