#import "ItemModel.h"

@implementation ItemModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _uuid = dict[@"uuid"];
        _title = dict[@"title"];
        _i_description = dict[@"i_description"];
        _thumbnail = dict[@"thumbnail"];
        _zip_file = dict[@"zip_file"];
        _num_stickers = [dict[@"num_stickers"] unsignedIntegerValue];
        _num_effects = [dict[@"num_effects"] unsignedIntegerValue];
        _num_bgms = [dict[@"num_bgms"] unsignedIntegerValue];
        _num_filters = [dict[@"num_filters"] unsignedIntegerValue];
        _num_masks = [dict[@"num_masks"] unsignedIntegerValue];
        _has_trigger = dict[@"has_trigger"];
        _status = dict[@"status"];
        _updated_at = [dict[@"updated_at"] unsignedIntegerValue];
    }
    return self;
}

@end
