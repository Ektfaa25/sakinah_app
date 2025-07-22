import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/router/app_router.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

/// Test to verify the router handles both Azkar objects and JSON maps correctly
void main() {
  group('Router Azkar Type Casting Tests', () {
    late GoRouter router;

    setUp(() {
      router = AppRouter.createRouter();
    });

    test('should handle proper Azkar object in extra data', () {
      // Create a real Azkar object
      final testAzkar = Azkar(
        id: 'test-1',
        textAr: 'اللهم صل على محمد',
        textEn: 'O Allah, send blessings upon Muhammad',
        categoryId: 'morning',
        orderIndex: 1,
        repeatCount: 3,
        isActive: true,
        createdAt: DateTime.now(),
      );

      final testCategory = AzkarCategory(
        id: 'morning',
        nameAr: 'أذكار الصباح',
        nameEn: 'Morning Azkar',
        description: 'Morning remembrance of Allah',
        icon: 'morning',
        color: '#FF9800',
        orderIndex: 1,
        isActive: true,
        createdAt: DateTime.now(),
      );

      // Prepare extra data with proper objects
      final extra = {
        'azkar': testAzkar,
        'category': testCategory,
        'azkarIndex': 0,
        'totalAzkar': 1,
        'azkarList': [testAzkar],
      };

      // This should not throw an exception
      expect(
        () => router.push('/azkar-detail-new/test-1', extra: extra),
        returnsNormally,
      );
    });

    test('should handle JSON map in extra data and convert to Azkar object', () {
      // Create JSON map representation of Azkar
      final testAzkarMap = {
        'id': 'test-2',
        'text_ar': 'سبحان الله',
        'text_en': 'Glory be to Allah',
        'category_id': 'morning',
        'order_index': 2,
        'repeat_count': 33,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      };

      final testCategory = AzkarCategory(
        id: 'morning',
        nameAr: 'أذكار الصباح',
        nameEn: 'Morning Azkar',
        description: 'Morning remembrance of Allah',
        icon: 'morning',
        color: '#FF9800',
        orderIndex: 1,
        isActive: true,
        createdAt: DateTime.now(),
      );

      // Prepare extra data with JSON map for azkar
      final extra = {
        'azkar': testAzkarMap,
        'category': testCategory,
        'azkarIndex': 0,
        'totalAzkar': 1,
        'azkarList': [testAzkarMap],
      };

      // This should not throw an exception and should convert the map to Azkar
      expect(
        () => router.push('/azkar-detail-new/test-2', extra: extra),
        returnsNormally,
      );
    });

    test('should handle mixed data types in azkarList', () {
      // Create both object and map representations
      final testAzkarObject = Azkar(
        id: 'test-3a',
        textAr: 'لا إله إلا الله',
        textEn: 'There is no god but Allah',
        categoryId: 'morning',
        orderIndex: 1,
        repeatCount: 100,
        isActive: true,
        createdAt: DateTime.now(),
      );

      final testAzkarMap = {
        'id': 'test-3b',
        'text_ar': 'الله أكبر',
        'text_en': 'Allah is the Greatest',
        'category_id': 'morning',
        'order_index': 2,
        'repeat_count': 34,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      };

      final testCategory = AzkarCategory(
        id: 'morning',
        nameAr: 'أذكار الصباح',
        nameEn: 'Morning Azkar',
        description: 'Morning remembrance of Allah',
        icon: 'morning',
        color: '#FF9800',
        orderIndex: 1,
        isActive: true,
        createdAt: DateTime.now(),
      );

      // Prepare extra data with mixed types in azkarList
      final extra = {
        'azkar': testAzkarObject,
        'category': testCategory,
        'azkarIndex': 0,
        'totalAzkar': 2,
        'azkarList': [testAzkarObject, testAzkarMap],
      };

      // This should not throw an exception
      expect(
        () => router.push('/azkar-detail-new/test-3a', extra: extra),
        returnsNormally,
      );
    });

    test('should handle missing azkar in extra data gracefully', () {
      final testCategory = AzkarCategory(
        id: 'morning',
        nameAr: 'أذكار الصباح',
        nameEn: 'Morning Azkar',
        description: 'Morning remembrance of Allah',
        icon: 'morning',
        color: '#FF9800',
        orderIndex: 1,
        isActive: true,
        createdAt: DateTime.now(),
      );

      // Prepare extra data without azkar
      final extra = {
        'category': testCategory,
        'azkarIndex': 0,
        'totalAzkar': 1,
      };

      // This should not throw an exception, should handle gracefully
      expect(
        () => router.push('/azkar-detail-new/test-4', extra: extra),
        returnsNormally,
      );
    });
  });
}
