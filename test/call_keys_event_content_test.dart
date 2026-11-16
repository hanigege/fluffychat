// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/matrix_live_kit_calls/call_keys_event_content.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses current and legacy MatrixRTC media keys', () {
    final content = {
      'room_id': '!room:example.org',
      'member': {
        'id': '@alice:example.org:DEVICE',
        'claimed_device_id': 'DEVICE',
      },
      'member_id': '@alice:example.org:DEVICE',
      'media_key': {'index': 2, 'key': 'AQIDBA=='},
    };

    final current = CallKeysEventContent.fromJson(content);
    expect(current.keys.index, 2);
    expect(current.keys.key, 'AQIDBA==');
    expect(current.session.callId, '');

    final legacy = CallKeysEventContent.fromJson({
      ...content,
      'keys': {'index': 1, 'key': 'BQYHCA=='},
      'media_key': null,
      'session': {'application': 'm.call', 'call_id': '', 'scope': 'm.room'},
    });
    expect(legacy.keys.index, 1);
    expect(legacy.keys.key, 'BQYHCA==');

    expect(current.toJson()['media_key'], current.toJson()['keys']);
    expect(current.toJson()['member_id'], '@alice:example.org:DEVICE');
  });
}
