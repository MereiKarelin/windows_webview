//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <webview_universal/webview_universal_plugin.h>
#include <webview_windows/webview_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  WebviewUniversalPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WebviewUniversalPlugin"));
  WebviewWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WebviewWindowsPlugin"));
}
