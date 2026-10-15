import 'package:flutter_test/flutter_test.dart';
import 'package:elshams/core/utils/price_calculator.dart';

void main() {
  group('PriceCalculator', () {
    group('calculateFinalPrice', () {
      test('حساب السعر الأساسي: 100 × 2.95 + 25 = 320', () {
        final result = PriceCalculator.calculateFinalPrice(
          livePrice: 100,
          multiplier: 2.95,
          increase: 25,
        );
        expect(result, equals(320.0));
      });

      test('فراخ كاملة: 100 × 1.60 + 25 = 185', () {
        final result = PriceCalculator.calculateFinalPrice(
          livePrice: 100,
          multiplier: 1.60,
          increase: 25,
        );
        expect(result, equals(185.0));
      });

      test('ورك عادة: 100 × 1.25 + 20 = 145', () {
        final result = PriceCalculator.calculateFinalPrice(
          livePrice: 100,
          multiplier: 1.25,
          increase: 20,
        );
        expect(result, equals(145.0));
      });

      test('سعر حي مختلف مع تقريب لأعلى: 110 × 2.95 + 25 = 349.5 -> 350', () {
        final result = PriceCalculator.calculateFinalPrice(
          livePrice: 110,
          multiplier: 2.95,
          increase: 25,
        );
        expect(result, equals(350.0));
      });

      test('زيادة صفر: 100 × 1.5 + 0 = 150', () {
        final result = PriceCalculator.calculateFinalPrice(
          livePrice: 100,
          multiplier: 1.5,
          increase: 0,
        );
        expect(result, equals(150.0));
      });

      test('تقريب للرقم الأعلى: 130.2 -> 131 و 130.5 -> 131', () {
        // اختبار مثال المستخدم المباشر
        expect(PriceCalculator.calculateFinalPrice(livePrice: 100, multiplier: 1.302, increase: 0), equals(131.0));
        expect(PriceCalculator.calculateFinalPrice(livePrice: 100, multiplier: 1.305, increase: 0), equals(131.0));
        expect(PriceCalculator.calculateFinalPrice(livePrice: 100, multiplier: 1.300, increase: 0), equals(130.0));
      });

      test('سعر حي منخفض: 50 × 1.60 + 25 = 105', () {
        final result = PriceCalculator.calculateFinalPrice(
          livePrice: 50,
          multiplier: 1.60,
          increase: 25,
        );
        expect(result, equals(105.0));
      });

      test('تحقق isValidLivePrice', () {
        expect(PriceCalculator.isValidLivePrice(100), isTrue);
        expect(PriceCalculator.isValidLivePrice(0), isFalse);
        expect(PriceCalculator.isValidLivePrice(-5), isFalse);
        expect(PriceCalculator.isValidLivePrice(99999), isFalse);
      });

      test('تحقق isValidMultiplier', () {
        expect(PriceCalculator.isValidMultiplier(1.60), isTrue);
        expect(PriceCalculator.isValidMultiplier(0), isFalse);
        expect(PriceCalculator.isValidMultiplier(-1), isFalse);
      });

      test('تحقق isValidIncrease', () {
        expect(PriceCalculator.isValidIncrease(25), isTrue);
        expect(PriceCalculator.isValidIncrease(0), isTrue);
        expect(PriceCalculator.isValidIncrease(-5), isFalse);
      });
    });

    group('All default products at live price 100', () {
      const livePrice = 100.0;
      final products = [
        ('فراخ كاملة', 1.60, 25.0, 185.0),
        ('صدور بالعظم', 1.55, 25.0, 180.0),
        ('ورك عادة', 1.25, 20.0, 145.0),
        ('ورك مقصف', 1.45, 25.0, 170.0),
        ('دبوس', 1.30, 20.0, 150.0),
        ('شيش بالجلد', 1.65, 30.0, 195.0),
        ('شيش كامل بدون جلد', 1.80, 30.0, 210.0),
        ('فيليه', 2.95, 25.0, 320.0),
        ('شاورما مسحب', 2.10, 25.0, 235.0),
        ('صدور فيليه بالجلد', 2.70, 25.0, 295.0),
      ];

      for (final (name, multiplier, increase, expected) in products) {
        test('$name: $livePrice × $multiplier + $increase = $expected', () {
          final result = PriceCalculator.calculateFinalPrice(
            livePrice: livePrice,
            multiplier: multiplier,
            increase: increase,
          );
          expect(result, equals(expected));
        });
      }
    });
  });
}

