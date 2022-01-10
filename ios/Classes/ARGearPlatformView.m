#import "ARGearPlatformView.h"
#import "ARGearView.h"

@interface ARGearPlatformView ()

@property(nonatomic, strong) ARGearView *arGearView;

@end

@implementation ARGearPlatformView

- (instancetype)initWithFrame:(CGRect)frame
                viewIdentifier:(int64_t)viewId
                arguments:(id _Nullable)args
                registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    if (self = [super init]) {
        self.arGearView = [[ARGearView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args registrar:registrar];
        self.arGearView.frame = frame;
        self.arGearView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (nonnull UIView *)view {
    return self.arGearView;
}

@end
