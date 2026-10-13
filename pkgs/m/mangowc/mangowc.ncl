{
  lib,
  drvs,
  mangowc | lib.MesonPackage = {
    singleSource = {

      # uri = "https://github.com/mangowm/mango/archive/refs/tags/0.14.4.tar.gz",
      # sha256sum = "e37e732ff3b0db309fc616cec5ed9699e972f2969f82c1bbc3c5a298168401f8",

      uri = "https://github.com/mangowm/mango/archive/refs/tags/0.18.0.tar.gz",
      sha256sum = "984386900d8a6896a67c56e3defcc8a979c8a9bd5b3b8ba9fb1ef537965b64a1",
    },

    # eofPatches = [
    #   {
    #     patch = (import "mangowc-chvt-3.patch" as 'Text),
    #   }
    # ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++",
      ],
      EXTRA_CPPFLAGS = [
        "-D__always_inline=inline",
        "-Dhandle_keyboard_key=mangowc__handle_keyboard_key",
        "-Dhandle_switch_toggle=mangowc__handle_switch_toggle",
        "-Dhandle_tablet_tool_axis=mangowc__handle_tablet_tool_axis",
        "-Dhandle_tablet_tool_proximity=mangowc__handle_tablet_tool_proximity",
        "-Dhandle_tablet_tool_tip=mangowc__handle_tablet_tool_tip",
        "-Dhandle_tablet_tool_button=mangowc__handle_tablet_tool_button",
        # "-Doutput_pending_resolution=mangowc__output_pending_resolution",
        # "-Doutput_pending_image_description=mangowc__output_pending_image_description",
      ],
    },
    extraMesonArgs = [
      "-Dxwayland=disabled",
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.pangoGobject,
    ],
    neverInclude = [
      drvs.pango,
      drvs.glib,
    ],
    propagatedBuildInputs = [
      drvs.scenefx,
      drvs.cjson,
      # drvs.pcre2,
      drvs.glibGobject,
      # drvs.cairo,
      drvs.harfbuzzFull,
      drvs.fribidi,
    ],
  },
}
