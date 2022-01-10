#import "ARGearViewFactory.h"
#import "ARGearPlatformView.h"

// @implementation ARGearViewFactory {
//   NSObject<FlutterBinaryMessenger>* _messenger;
// }
//
// - (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
//   self = [super init];
//   if (self) {
//     _messenger = messenger;
//   }
//   return self;
// }
//
// - (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
//                                    viewIdentifier:(int64_t)viewId
//                                         arguments:(id _Nullable)args {
//   return [[ARGearView alloc] initWithFrame:frame
//                              viewIdentifier:viewId
//                              arguments:args
//                              binaryMessenger:_messenger];
// }

@interface ARGearViewFactory ()

@property(nonatomic, strong) NSObject<FlutterPluginRegistrar>* registrar;

@end

@implementation ARGearViewFactory

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
    }
    return self;
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                            viewIdentifier:(int64_t)viewId
                                                 arguments:(id _Nullable)args {
    return [[ARGearPlatformView alloc] initWithFrame:frame
                                      viewIdentifier:viewId
                                           arguments:args
                                           registrar:self.registrar];
}

@end
