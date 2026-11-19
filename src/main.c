#include <eadk.h>
#include <stdint.h>

const char eadk_app_name[] __attribute__((section(".rodata.eadk_app_name"))) = "Wallpaper";
const uint32_t eadk_api_level __attribute__((section(".rodata.eadk_api_level"))) = 0;
extern const uint8_t eadk_external_data[];

int main(int argc, char * argv[]) {
  (void)argc; (void)argv;
  eadk_rect_t screen = {0, 0, EADK_SCREEN_WIDTH, EADK_SCREEN_HEIGHT};
  eadk_display_push_rect(screen, (const eadk_color_t *)eadk_external_data);
  while (1) {
    eadk_keyboard_state_t state = eadk_keyboard_scan();
    if (eadk_keyboard_key_down(state, eadk_key_back)) break;
    eadk_timing_msleep(30);
  }
  return 0;
}
