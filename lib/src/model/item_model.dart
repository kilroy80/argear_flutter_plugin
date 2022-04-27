class ItemModel {
  String _uuid = '';
  String _title = '';
  String _description = '';
  String _thumbnail = '';
  String _zipFile = '';
  num _numStickers = 0;
  num _numEffects = 0;
  num _numBgms = 0;
  num _numFilters = 0;
  num _numMasks = 0;
  bool _hasTrigger = false;
  String _status = '';
  num _updatedAt = 0;
  String _type = '';

  ItemModel(result) {
    if (result != null) {
      parse(result);
    }
  }

  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    parse(parsedJson);
  }

  Map<String, dynamic> toJson() => {
    'uuid': _uuid,
    'title': _title,
    'description': _description,
    'thumbnail': _thumbnail,
    'zip_file': _zipFile,
    'num_stickers': _numStickers,
    'num_effects': _numEffects,
    'num_bgms': _numBgms,
    'num_filters': _numFilters,
    'num_masks': _numMasks,
    'has_trigger': _hasTrigger,
    'status' : _status,
    'updated_at': _updatedAt,
    'type': _type
  };

  void parse(parsedJson) {
    _uuid = parsedJson['uuid'] ?? '';
    _title = parsedJson['title'] ?? '';
    _description = parsedJson['description'] ?? '';
    _thumbnail = parsedJson['thumbnail'] ?? '';
    _zipFile = parsedJson['zip_file'] ?? '';
    _numStickers = parsedJson['num_stickers'] ?? 0;
    _numEffects = parsedJson['num_effects'] ?? 0;
    _numBgms = parsedJson['num_bgms'] ?? 0;
    _numFilters = parsedJson['num_filters'] ?? 0;
    _numMasks = parsedJson['num_masks'] ?? 0;
    _hasTrigger = parsedJson['has_trigger'] ?? false;
    _status = parsedJson['status'] ?? '';
    _updatedAt = parsedJson['updated_at'] ?? 0;
    _type = parsedJson['type'] ?? '';
  }

  String get uuid => _uuid;

  String get title => _title;

  String get description => _description;

  String get thumbnail => _thumbnail;

  String get zipFile => _zipFile;

  num get numStickers => _numStickers;

  num get numEffects => _numEffects;

  num get numBgms => _numBgms;

  num get numFilters => _numFilters;

  num get numMasks => _numMasks;

  bool get hasTrigger => _hasTrigger;

  String get status => _status;

  num get updatedAt => _updatedAt;

  String get type => _type;
}
