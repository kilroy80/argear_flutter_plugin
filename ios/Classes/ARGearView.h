#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "ARGCamera.h"
#import "ARGScene.h"

#import <ARGear/ARGear.h>

NS_ASSUME_NONNULL_BEGIN

//@interface ARGearView : NSObject <FlutterPlatformView, ARGCameraDelegate, ARGSessionDelegate>
@interface ARGearView : UIView <FlutterPlugin, ARGCameraDelegate, ARGSessionDelegate>

@property (nonatomic, strong) ARGSession *argSession;
@property (nonatomic, strong) ARGMedia *argMedia;

@property (nonatomic, strong) ARGCamera *camera;
@property (nonatomic, strong) ARGScene *sceneView;

@property (nonatomic, assign) ARGMediaVideoBitrate bitrate;

@property(nonatomic, strong) FlutterMethodChannel *channel;

//- (instancetype)initWithFrame:(CGRect)frame
//               viewIdentifier:(int64_t)viewId
//                    arguments:(id _Nullable)args
//              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

//- (UIView*)view;
@end

NS_ASSUME_NONNULL_END
