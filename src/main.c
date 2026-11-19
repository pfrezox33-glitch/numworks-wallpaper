#include <eadk.h>
#include <stdint.h>

const char eadk_app_name[] __attribute__((section(".rodata.eadk_app_name"))) = "Wallpaper";
const uint32_t eadk_api_level __attribute__((section(".rodata.eadk_api_level"))) = 0;

int main(int argc, char *argv[]) {
  (void)argc;
  (void)argv;

  const uint32_t expected_size = 320u * 222u * 2u;
  if (eadk_external_data == 0 || eadk_external_data_size < expected_size) {
    eadk_display_draw_string("Image absente ou invalide", (eadk_point_t){8, 100},
                             true, eadk_color_black, eadk_color_white);
    eadk_timing_msleep(2500);
    return 0;
  }

  const eadk_rect_t image_rect = {0, 9, 320, 222};
  eadk_display_push_rect(image_rect, (const eadk_color_t *)eadk_external_data);

  while (1) {
    eadk_keyboard_state_t keys = eadk_keyboard_scan();
    if (eadk_keyboard_key_down(keys, eadk_key_back) ||
        eadk_keyboard_key_down(keys, eadk_key_home)) {
      break;
    }
    eadk_timing_msleep(30);
  }
  return 0;
}
