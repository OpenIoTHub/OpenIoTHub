import 'package:flutter_test/flutter_test.dart';
import 'package:openiothub/ads/utils/locale_name.dart';

void main() {
  group('isCnMainland', () {
    test('empty -> false', () {
      expect(isCnMainland(''), isFalse);
    });

    test('non-Chinese -> false', () {
      expect(isCnMainland('en'), isFalse);
      expect(isCnMainland('en_US'), isFalse);
    });

    test('Taiwan / HK / MO -> false', () {
      expect(isCnMainland('zh_TW'), isFalse);
      expect(isCnMainland('zh-HK'), isFalse);
      expect(isCnMainland('zh_MO'), isFalse);
    });

    test('Hant script -> false', () {
      expect(isCnMainland('zh_Hant'), isFalse);
      expect(isCnMainland('zh_Hant_TW'), isFalse);
    });

    test('CN / Hans -> true', () {
      expect(isCnMainland('zh_CN'), isTrue);
      expect(isCnMainland('zh-cn'), isTrue);
      expect(isCnMainland('zh_Hans'), isTrue);
    });

    test('bare zh (compat) -> true', () {
      expect(isCnMainland('zh'), isTrue);
    });

    test('zh with non-mainland region code -> false', () {
      expect(isCnMainland('zh_SG'), isFalse);
      expect(isCnMainland('zh-US'), isFalse);
      expect(isCnMainland('zh_GB'), isFalse);
    });

    test('zh_CN with script Hans explicit -> true', () {
      expect(isCnMainland('zh_CN_Hans'), isTrue);
      expect(isCnMainland('zh_Hans_CN'), isTrue);
    });

    test('extra underscores between tags still resolve cn', () {
      expect(isCnMainland('zh__cn'), isTrue);
      expect(isCnMainland('zh___hans'), isTrue);
    });
  });
}
