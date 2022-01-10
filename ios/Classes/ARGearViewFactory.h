#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "ARGearView.h"

//@interface ARGearViewFactory : NSObject <FlutterPlatformViewFactory>
//- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
//@end

NS_ASSUME_NONNULL_BEGIN

@interface ARGearViewFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end

NS_ASSUME_NONNULL_END
