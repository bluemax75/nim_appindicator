{.deadCodeElim: on.}
{.push gcsafe.}
# This shows how to wrap part of a library that depends on another one
#
# In this case we are wrapping AppIndicator which needs gtk2/glib2
# gtk/glib were wrapped already, so we get the datatypes importing the corresponding packages
#
# The enumerations used in the datatypes/methods must be declared
#
# In thos case each datatype is declared as a descendant of PGObject without additional members 
#
# The methods are declared below indicating the following pragmas:
# - "cdecl": use C declaration
# - "dynlib": the C function is located in this dynanic library
# - "importc": indicates the function name used in the wrapped library


# Import base library wrappers used by libappindicator (imports data types needed)
import
  gtk2, glib2

# This library will be used when calling the c functions (using dynlib pragma)
const
  lib = "libappindicator.so"

# Enums from the header file
type
  TAppIndicatorCategory* = enum
    APP_INDICATOR_CATEGORY_APPLICATION_STATUS,
    APP_INDICATOR_CATEGORY_COMMUNICATIONS,
    APP_INDICATOR_CATEGORY_SYSTEM_SERVICES,
    APP_INDICATOR_CATEGORY_HARDWARE,
    APP_INDICATOR_CATEGORY_OTHER
  TAppIndicatorStatus* = enum
    APP_INDICATOR_STATUS_PASSIVE,
    APP_INDICATOR_STATUS_ACTIVE,
    APP_INDICATOR_STATUS_ATTENTION
# Data types
type
  PAppIndicator* = ptr TAppIndicator
  TAppIndicator* = object of PGObject
# Seems that Class data types are not needed
#  PAppIndicatorClass = ptr TAppIndicatorClass
#  TAppIndicatorClass = object of PGObject

# Constructor
proc app_indicator_new*(id: cstring, icon_name: cstring, category: TAppIndicatorCategory): PAppIndicator {.cdecl, dynlib: lib, importc: "app_indicator_new".}
proc app_indicator_new_with_path*(id: cstring, icon_name: cstring, category: TAppIndicatorCategory, icon_theme_path: cstring): PAppIndicator {.cdecl, dynlib: lib, importc: "app_indicator_new_with_path".}

# "Methods" of the AppIndicator object
proc set_status*(app_indicator: PAppIndicator, status: TAppIndicatorStatus) {.cdecl, dynlib: lib, importc:"app_indicator_set_status".}
proc set_menu*(app_indicator: PAppIndicator, menu: PMenu) {.cdecl, dynlib: lib, importc: "app_indicator_set_menu".}
proc set_attention_icon*(app_indicator: PAppIndicator, icon_name: cstring) {.cdecl, dynlib: lib, importc: "app_indicator_set_attention_icon".}
proc set_attention_icon_full*(app_indicator: PAppIndicator, icon_name: cstring, icon_desc: cstring) {.cdecl, dynlib: lib, importc: "app_indicator_set_attention_icon_full".}
proc set_icon*(app_indicator: PAppIndicator, icon_name: cstring) {.cdecl, dynlib: lib, importc:"app_indicator_set_icon".}
proc set_icon_full*(app_indicator: PAppIndicator, icon_name: cstring, icon_desc: cstring) {.cdecl, dynlib: lib, importc:"app_indicator_set_icon_full".}
proc set_label*(app_indicator: PAppIndicator, label: cstring, guide: cstring) {.cdecl, dynlib: lib, importc:"app_indicator_set_label".}
proc set_icon_theme_path*(app_indicator: PAppIndicator, icon_theme_path: cstring) {.cdecl, dynlib: lib, importc:"app_indicator_set_icon_theme_path".}
proc set_ordering_index*(app_indicator: PAppIndicator, ordering_index: guint32) {.cdecl, dynlib: lib, importc:"app_indicator_set_ordering_index".}
proc set_secondary_activate_target*(app_indicator: PAppIndicator, menuitem: PWidget) {.cdecl, dynlib: lib, importc:"app_indicator_set_secondary_activate_target".}
proc set_title*(app_indicator: PAppIndicator, title: cstring) {.cdecl, dynlib: lib, importc:"app_indicator_set_title".}
proc app_indicator_get_id*(app_indicator: PAppIndicator): cstring {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_category*(app_indicator: PAppIndicator): TAppIndicatorCategory {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_status*(app_indicator: PAppIndicator): TAppIndicatorStatus {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_icon*(app_indicator: PAppIndicator): cstring {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_icon_desc*(app_indicator: PAppIndicator): cstring {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_icon_theme_path*(app_indicator: PAppIndicator): cstring {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_attention_icon*(app_indicator: PAppIndicator): cstring {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_attention_icon_desc*(app_indicator: PAppIndicator): cstring {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_title*(app_indicator: PAppIndicator): cstring {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_menu*(app_indicator: PAppIndicator): PMenu {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_label*(app_indicator: PAppIndicator): cstring {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_label_guide*(app_indicator: PAppIndicator): cstring {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_ordering_index*(app_indicator: PAppIndicator): guint32 {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_get_secondary_activate_target*(app_indicator: PAppIndicator): PWidget {.cdecl, dynlib: lib, importc:"app_indicator_get".}
proc app_indicator_build_menu_from_desktop*(app_indicator: PAppIndicator) {.cdecl, dynlib: lib, importc:"app_indicator_get".}


when isMainModule:
  # Test creating an indicator icon
  nim_init()
  var appind = app_indicator_new("appindtest", STOCK_DIALOG_INFO, APP_INDICATOR_CATEGORY_SYSTEM_SERVICES)
  # To show the icon we must set its status to active
  appind.set_status(APP_INDICATOR_STATUS_ACTIVE)
  # For some reason The icon does not show if we do not set a menu (even an empty menu like this one)
  appind.set_menu(menu_new())
  main()
