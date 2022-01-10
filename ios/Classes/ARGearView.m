#import "ARGearView.h"
#import <ARGear/ARGear.h>
#import "Permission.h"
#import "NetworkManager.h"
#import "SessionManager.h"

@implementation ARGearView

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    registrar:(NSObject<FlutterPluginRegistrar>*)registrar {

  if (self = [super init]) {

    NSString *name = [NSString stringWithFormat:@"argear_flutter_plugin_%lld", viewId];
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                    methodChannelWithName:name
                                    binaryMessenger:registrar.messenger];
    self.channel = channel;

    [registrar addMethodCallDelegate:self channel:channel];
    [registrar addApplicationDelegate:self];
  }

  return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"init"]) {

        NSString *apiUrl = call.arguments[@"apiUrl"];
        NSString *apiKey = call.arguments[@"apiKey"];
        NSString *secretKey = call.arguments[@"secretKey"];
        NSString *authKey = call.arguments[@"authKey"];

        [self initialize :apiUrl apiKey:apiKey apiSecretKey:secretKey apiAuthKey:authKey];

    } else if ([call.method isEqualToString:@"changeCameraFacing"]) {

        [self toggleButtonAction:^{
//            result(@"ok");
//            result([FlutterError errorWithCode:@"UNAVAILABLE"
//                                       message:@"test fail"
//                                       details:nil]);
//            result(FlutterMethodNotImplemented);
        }];

    } else if ([call.method isEqualToString:@"changeCameraRatio"]) {

        NSString *ratio = call.arguments[@"ratio"];

        if (ratio != nil) {
            ARGMediaRatio mediaRatio;
            if ([ratio intValue] == 0) {
                mediaRatio = ARGMediaRatio_1x1;
            } else if ([ratio intValue] == 1) {
                mediaRatio = ARGMediaRatio_4x3;
            } else {
                mediaRatio = ARGMediaRatio_16x9;
            }

            [self changeRatioAction:mediaRatio :^{
            }];
        }

    } else if ([call.method isEqualToString:@"setVideoBitrate"]) {

        NSString *bitrateStr = call.arguments[@"bitrate"];
        if (bitrateStr != nil) {
            if ([bitrateStr intValue] == 0) {
                _bitrate = ARGMediaVideoBitrate_4M;
            } else if ([bitrateStr intValue] == 1) {
                _bitrate = ARGMediaVideoBitrate_2M;
            } else {
                _bitrate = ARGMediaVideoBitrate_1M;
            }

            [_argMedia setVideoBitrate:_bitrate];
        }

    } else if ([call.method isEqualToString:@"setSticker"]) {

        NSString *itemModel = call.arguments[@"itemModel"];
        NSData *data =[itemModel dataUsingEncoding:NSUTF8StringEncoding];

        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];

        if (jsonError) {
            return;
        }

        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            ItemModel *model = [[ItemModel alloc] initWithDictionary:(NSDictionary *)jsonObject];

            [[SessionManager shared] setSticker:model success:^(BOOL exist) {
                    result(@"complete");
                } fail:^{
//                    result([FlutterError errorWithCode:@"UNAVAILABLE"
//                                               message:@"test fail"
//                                               details:nil]);
                }];
        }
    } else if ([call.method isEqualToString:@"clearSticker"]) {

        [[SessionManager shared] clearSticker];

    } else if ([call.method isEqualToString:@"setFilter"]) {

        NSString *itemModel = call.arguments[@"itemModel"];
        NSData *data =[itemModel dataUsingEncoding:NSUTF8StringEncoding];

        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];

        if (jsonError) {
            return;
        }

        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            ItemModel *model = [[ItemModel alloc] initWithDictionary:(NSDictionary *)jsonObject];

            [[SessionManager shared] setFilter:model success:^(void) {
                    result(@"complete");
                } fail:^{
//                    result([FlutterError errorWithCode:@"UNAVAILABLE"
//                                               message:@"test fail"
//                                               details:nil]);
                }];
        }

    } else if ([call.method isEqualToString:@"setFilterLevel"]) {

        NSString *level = call.arguments[@"level"];

        [[SessionManager shared] setFilterLevel:[level floatValue]];

    } else if ([call.method isEqualToString:@"clearFilter"]) {

        [[SessionManager shared] clearFilter];

    } else if ([call.method isEqualToString:@"setDefaultBeauty"]) {

        [[SessionManager shared] setDefaultBeauty];

    } else if ([call.method isEqualToString:@"getDefaultBeauty"]) {

        [[SessionManager shared] setDefaultBeauty];
        result([[SessionManager shared] loadBeautyValue]);

    } else if ([call.method isEqualToString:@"setBeauty"]) {

        NSString *type = call.arguments[@"type"];
        NSString *value = call.arguments[@"value"];

        [[SessionManager shared] setBeauty: (ARGContentItemBeauty)[type intValue] value:[value floatValue]];

    } else if ([call.method isEqualToString:@"setBeautyValues"]) {

        NSString *values = call.arguments[@"values"];

        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"[] "];
        NSArray *array = [[[values componentsSeparatedByCharactersInSet:characterSet]
                                componentsJoinedByString:@""]
                                componentsSeparatedByString:@","];

        [[SessionManager shared] setBeautyValues: array];

    } else if ([call.method isEqualToString:@"setBulge"]) {

        NSString *type = call.arguments[@"type"];
        [[SessionManager shared] setBulge: (int)[type intValue]];

    } else if ([call.method isEqualToString:@"clearBulge"]) {

        [[SessionManager shared] clearBulge];

    } else if ([call.method isEqualToString:@"takePicture"]) {

        [self takePictureAction];

    } else if ([call.method isEqualToString:@"startRecording"]) {

        [self startRecording];

    } else if ([call.method isEqualToString:@"stopRecording"]) {

        [self stopRecording];

    } else if ([call.method isEqualToString:@"toggleRecording"]) {

        NSString *toggle = call.arguments[@"toggle"];
        [self toggleRecording:[toggle intValue]];;

    } else if ([call.method isEqualToString:@"dispose"]) {

        [[SessionManager shared] clearSticker];
        [[SessionManager shared] clearFilter];
        [[SessionManager shared] clearBulge];
        [self stopARGSession];

        _camera = nil;
        [self removeFromSuperview];

    }
}

- (void)initialize:(NSString *)apiHost apiKey:(NSString *)apiKey apiSecretKey:(NSString *)apiSecretKey apiAuthKey:(NSString *)apiAuthKey {

    _bitrate = ARGMediaVideoBitrate_4M;

    [self setupConfig :apiHost apiKey:apiKey apiSecretKey:apiSecretKey apiAuthKey:apiAuthKey];
    [self setupCamera];
    [self setupScene];

    [self initHelpers];

    [self runARGSession];
}

- (void)initHelpers {

    [[SessionManager shared] setSession:_argSession];
    [[NetworkManager shared] setSession:_argSession];
}

- (void)setupConfig:(NSString *)apiHost apiKey:(NSString *)apiKey apiSecretKey:(NSString *)apiSecretKey apiAuthKey:(NSString *)apiAuthKey {

    ARGConfig *argConfig = [[ARGConfig alloc] initWithApiURL:apiHost apiKey:apiKey secretKey:apiSecretKey authKey:apiAuthKey];

    NSError * error;
    _argSession = [[ARGSession alloc] initWithARGConfig:argConfig error:&error];
    _argSession.delegate = self;
}

- (void)setupScene {

    CGAffineTransform displayTransform = [_argSession.frame displayTransform];
    _sceneView = [[ARGScene alloc] initSceneviewAt:self withViewTransform:displayTransform];
}

- (void)setupCamera {
    _camera = [[ARGCamera alloc] init];

//    [[self camera] setDelegate:self];
//    [[self camera] startCamera];

//    [self setCameraInfo];

    __weak ARGearView *weakSelf = self;
    [self permissionCheck:^{

        [[weakSelf camera] setDelegate:self];
        [[weakSelf camera] startCamera];

        [self setCameraInfo];
    }];
}

- (void)setCameraInfo {

    if(!_argMedia){
        _argMedia = [[ARGMedia alloc] init];
    }

    [_argMedia setVideoDevice:[_camera device]];
    [_argMedia setVideoDeviceOrientation:[_camera videoOrientation]];
    [_argMedia setVideoConnection:[_camera videoConnection]];
    [_argMedia setMediaRatio:[_camera currentRatio]];

    [_argMedia setVideoBitrate:_bitrate];
}

// MARK: - ARGCamera Delegate
- (void)didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
               fromConnection:(AVCaptureConnection *)connection {

    [_argSession updateSampleBuffer:sampleBuffer fromConnection:connection];
}

// MARK: - ARGearSDK ARGSession delegate
- (void)didUpdateFrame:(ARGFrame *)frame {
    ARGFaces *faces = frame.faces;
    NSArray *faceList = faces.faceList;
    for (ARGFace *face in faceList) {
        if(face.isValid) {
        }
    }

    if ([frame renderedPixelBuffer]) {
        [_sceneView displayPixelBuffer:[frame renderedPixelBuffer]];
    }
}

- (void)runARGSession {

    ARGInferenceFeature inferenceFeature = ARGInferenceFeatureFaceMeshTracking;
    [_argSession runWithInferenceConfig:inferenceFeature];

//    ARGInferenceDebugOption debugOption = [_preferences showLandmark] ? ARGInferenceOptionDebugFaceLandmark2D : ARGInferenceOptionDebugNON;
}

- (void)stopARGSession {
    [_argSession pause];
}

- (void)clean {
    [_sceneView cleanGLPreview];
}

- (void)permissionCheck:(PermissionGrantedBlock)granted {

    Permission *permission = [[Permission alloc] init];
    [permission permissionAllAllowAction:^{
        PermissionLevel permissionLevel = [permission getPermissionLevel];
        if (permissionLevel == PermissionLevelGranted) {
            granted();
        }
    }];
}

- (void)toggleButtonAction:(void (^)(void))callback {
    [self pauseUI];
    [self clean];

     __weak ARGearView *weakSelf = self;
    [_camera toggleCamera:^{
        [weakSelf startUI];
        [weakSelf refreshRatio];
//        [self.channel invokeMethod:@"changeCameraFacingCallback" arguments:@"OK"];
        callback();
    }];
}

- (void)changeRatioAction:(ARGMediaRatio)ratio :(void (^)(void))callback {
    [self pauseUI];
    [self clean];

     __weak ARGearView *weakSelf = self;
    [_camera changeCameraRatio:ratio :^{
        [weakSelf startUI];
        [weakSelf refreshRatio];
//        [self.channel invokeMethod:@"changeCameraRatioCallback" arguments:@"OK"];
        callback();
    }];
}

- (void)refreshRatio {
    CGAffineTransform displayTramsform = [_argSession.frame displayTransform];
    [_sceneView setViewTransform:displayTramsform];
//    [_ratioView setRatio:_camera.currentRatio];
    [_sceneView sceneViewRatio:_camera.currentRatio];
    [_argMedia setMediaRatio:[_camera currentRatio]];
}

- (void)startUI {
    [self setCameraInfo];
//    [self touchLock:NO];
    [_argSession run];
}

- (void)pauseUI {
//    [self touchLock:YES];
    [_argSession pause];
}

- (void)takePictureAction {

    [_argMedia takePic:^(UIImage * _Nonnull image) {
        NSLog(@"finish");
        [self takePictureFinished:image];
    }];
}

- (void)toggleRecording:(int)toggle {

    if (toggle == 0) {
        [self startRecording];
    } else if (toggle == 1) {
        [self stopRecording];
    }
}

- (void)startRecording {
    [_argMedia recordVideoStart:^(CGFloat recTime) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
}

- (void)stopRecording {
    [_argMedia recordVideoStop:^(NSDictionary * _Nonnull videoInfo) {
    } save:^(NSDictionary * _Nonnull videoInfo) {
        [self recordVideoFinished:videoInfo];
    }];
}

- (void)takePictureFinished:(UIImage *)image {
//    [_argMedia saveImage:image saved:^{
//        // Toast
//        NSLog(@"save image toast");
//    } goToPreview:^{
////        [self goPreview:image];
//    }];

//    __weak ARGearView *weakSelf = self;
    [_argMedia saveImageToAlbum:image success:^{
        [self.channel invokeMethod:@"takePictureCallback" arguments:@"success"];
    } error:^{

    }];
}

- (void)recordVideoFinished:(NSDictionary *)videoInfo {
//    [_argMedia saveVideo:videoInfo saved:^{
//        // Toast
//        NSLog(@"save video toast");
//
//    } goToPreview:^{
////        [self goPreviewVideo:videoInfo];
//    }];

    NSURL *videoPath = [videoInfo objectForKey:@"filePath"];
    if (!videoPath) {
        return;
    }

    [_argMedia saveVideoToAlbum:videoPath success:^{
        [self.channel invokeMethod:@"recordingCallback" arguments:@"success"];
    } error:^{

    }];
}

- (void)applicationDidBecomeActive:(UIApplication*)application {
}

- (void)applicationWillTerminate:(UIApplication*)application {
}

- (void)applicationWillResignActive:(UIApplication*)application {
}

- (void)applicationWillEnterForeground:(UIApplication*)application {
    [self runARGSession];
}

- (void)applicationDidEnterBackground:(UIApplication*)application {
    [self stopARGSession];
}

@end
