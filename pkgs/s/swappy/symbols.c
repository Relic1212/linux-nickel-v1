#include <dl_factory.h>
extern void *arrow_clicked_handler;

extern void *blur_clicked_handler;

extern void *brush_clicked_handler;

extern void *clear_clicked_handler;

extern void *color_blue_clicked_handler;

extern void *color_custom_clicked_handler;

extern void *color_custom_color_set_handler;

extern void *color_green_clicked_handler;

extern void *color_red_clicked_handler;

extern void *copy_clicked_handler;

extern void *draw_area_button_press_handler;

extern void *draw_area_button_release_handler;

extern void *draw_area_configure_handler;

extern void *draw_area_handler;

extern void *draw_area_motion_notify_handler;

extern void *ellipse_clicked_handler;

extern void *fill_shape_toggled_handler;

extern void *gtk_image_get_type;

extern void *pane_toggled_handler;

extern void *rectangle_clicked_handler;

extern void *redo_clicked_handler;

extern void *save_clicked_handler;

extern void *stroke_size_decrease_handler;

extern void *stroke_size_increase_handler;

extern void *stroke_size_reset_handler;

extern void *text_clicked_handler;

extern void *text_size_decrease_handler;

extern void *text_size_increase_handler;

extern void *text_size_reset_handler;

extern void *undo_clicked_handler;

extern void *window_delete_handler;

extern void *window_keypress_handler;

extern void *window_keyrelease_handler;

__attribute__((constructor)) void register_swayppy_internal()
{
	register_lib("swayppy_internal", 33);

	register_symbol("arrow_clicked_handler", &arrow_clicked_handler);
	register_symbol("blur_clicked_handler", &blur_clicked_handler);
	register_symbol("brush_clicked_handler", &brush_clicked_handler);
	register_symbol("clear_clicked_handler", &clear_clicked_handler);
	register_symbol("color_blue_clicked_handler", &color_blue_clicked_handler);
	register_symbol("color_custom_clicked_handler", &color_custom_clicked_handler);
	register_symbol("color_custom_color_set_handler", &color_custom_color_set_handler);
	register_symbol("color_green_clicked_handler", &color_green_clicked_handler);
	register_symbol("color_red_clicked_handler", &color_red_clicked_handler);
	register_symbol("copy_clicked_handler", &copy_clicked_handler);
	register_symbol("draw_area_button_press_handler", &draw_area_button_press_handler);
	register_symbol("draw_area_button_release_handler", &draw_area_button_release_handler);
	register_symbol("draw_area_configure_handler", &draw_area_configure_handler);
	register_symbol("draw_area_handler", &draw_area_handler);
	register_symbol("draw_area_motion_notify_handler", &draw_area_motion_notify_handler);
	register_symbol("ellipse_clicked_handler", &ellipse_clicked_handler);
	register_symbol("fill_shape_toggled_handler", &fill_shape_toggled_handler);
	register_symbol("gtk_image_get_type", &gtk_image_get_type);
	register_symbol("pane_toggled_handler", &pane_toggled_handler);
	register_symbol("rectangle_clicked_handler", &rectangle_clicked_handler);
	register_symbol("redo_clicked_handler", &redo_clicked_handler);
	register_symbol("save_clicked_handler", &save_clicked_handler);
	register_symbol("stroke_size_decrease_handler", &stroke_size_decrease_handler);
	register_symbol("stroke_size_increase_handler", &stroke_size_increase_handler);
	register_symbol("stroke_size_reset_handler", &stroke_size_reset_handler);
	register_symbol("text_clicked_handler", &text_clicked_handler);
	register_symbol("text_size_decrease_handler", &text_size_decrease_handler);
	register_symbol("text_size_increase_handler", &text_size_increase_handler);
	register_symbol("text_size_reset_handler", &text_size_reset_handler);
	register_symbol("undo_clicked_handler", &undo_clicked_handler);
	register_symbol("window_delete_handler", &window_delete_handler);
	register_symbol("window_keypress_handler", &window_keypress_handler);
	register_symbol("window_keyrelease_handler", &window_keyrelease_handler);
};
