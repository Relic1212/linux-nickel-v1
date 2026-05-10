extern void adw_stylesheet_get_resource(void);
extern void adw_get_resource(void);
__attribute__((constructor)) void register_adw_internal()
{
	adw_stylesheet_get_resource();
	adw_get_resource();
}