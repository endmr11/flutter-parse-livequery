import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ParseProvider {
  ParseProvider();
  static const String _baseUrl = 'https://parseapi.back4app.com/classes/';
  static Future<void> initParse() async {
    const keyApplicationId = 'xVeYmbicBhvCT4xYjyMQRh2AqWIhgp6o9d0m9Zcc';
    const keyClientKey = '6L2SYAoOekf40OTIp4SIDQ2ZgVQ9n6ey2gCfEx0j';
    const keyParseServerUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(
      keyApplicationId,
      keyParseServerUrl,
      clientKey: keyClientKey,
      autoSendSessionId: true,
      liveQueryUrl: 'https://flutterparseserver.b4a.io',
    );

    /*var todoContent = ParseObject('TodoContent')..set('content', 'This is content');
    await todoContent.save();

    var todoFlutter = ParseObject('TodoFlutter')
      ..set('message', 'Test2')
      ..set('watched', '3')
      ..set('deletionTime', DateTime.now())
      ..setAddAll('list', ["this", "is", "array", "yes"])
      ..set('isDone', true)
      ..set('todoContent', ParseObject('TodoContent')..objectId = todoContent.objectId)
      ..set('complexObject', {"name": "Eren", "age": 20, "isEmployee": true})
      ..set('lastLocation', ParseGeoPoint(latitude: -20.2523818, longitude: -40.2665611));
    todoFlutter.addRelation('photos', [ParseObject('Gallery')..set('objectId', 'h4DyBMkbUt')]);
    await todoFlutter.save();*/
  }
}
