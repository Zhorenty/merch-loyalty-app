import 'package:flutter_test/flutter_test.dart';
import 'package:merch/src/feature/version/widget/force_update_gate.dart';

void main() {
  test('ForceUpdateGate compares semver', () {
    expect(ForceUpdateGate.needsUpdate('1.0.0', '1.0.0'), isFalse);
    expect(ForceUpdateGate.needsUpdate('1.0.0', '1.0.1'), isTrue);
    expect(ForceUpdateGate.needsUpdate('1.2.0', '1.0.9'), isFalse);
  });
}
