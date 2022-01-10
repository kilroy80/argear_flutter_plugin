#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemModel : NSObject
// api
@property NSString *uuid;
@property NSString *title;
@property NSString *i_description;
@property NSString *thumbnail;
@property NSString *zip_file;
@property NSInteger num_stickers;
@property NSInteger num_effects;
@property NSInteger num_bgms;
@property NSInteger num_filters;
@property NSInteger num_masks;
@property BOOL has_trigger;
@property NSString *status;
@property NSInteger updated_at;
@property NSString *big_thumbnail;
@property NSString *myitem_status;
@property NSString *type;
// local
@property BOOL isDownloaded;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
