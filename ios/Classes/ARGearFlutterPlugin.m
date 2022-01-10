#import "ARGearFlutterPlugin.h"
#import "ARGearViewFactory.h"
#if __has_include(<argear_flutter_plugin/argear_flutter_plugin-Swift.h>)
#import <argear_flutter_plugin/argear_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "argear_flutter_plugin-Swift.h"
#endif

@implementation ARGearFlutterPlugin
// + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//   [SwiftARGearFlutterPlugin registerWithRegistrar:registrar];
// }
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//   ARGearViewFactory* factory =
//       [[ARGearViewFactory alloc] initWithMessenger:registrar.messenger];
//   [registrar registerViewFactory:factory withId:@"argear_flutter_plugin"];

    ARGearViewFactory *factory = [[ARGearViewFactory alloc] initWithRegistrar:registrar];
    [registrar registerViewFactory:factory withId:@"argear_flutter_plugin"];
}
@end
