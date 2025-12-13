extern void adw_get_resource(void);
extern void adw_stylesheet_get_resource(void);

__attribute__((constructor)) static void ptyxis_adw_init(){
	adw_get_resource();
	adw_stylesheet_get_resource();
}