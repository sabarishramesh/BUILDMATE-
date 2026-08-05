import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_build/models/project_model.dart';
import 'package:nexus_build/services/project_service.dart';

void main() {
  test('Exact Calculator Test Case', () {
    final p = ProjectModel(
      id: 'test-1',
      name: 'Test Project',
      builtUpAreaSqft: 2400,
      numberOfFloors: 3,
      floorHeightM: 3.0,
      slabThicknessMm: 150,
      wallThicknessMm: 230,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ProjectService.calculate(p);

    print('========================================');
    print('Slab Volume        : ${p.slabVolumeM3.toStringAsFixed(2)} m³');
    print('Wall Volume        : ${p.wallVolumeM3.toStringAsFixed(2)} m³');
    print('Foundation Volume  : ${p.foundationVolumeM3.toStringAsFixed(2)} m³');
    print('Total Concrete     : ${p.totalConcreteVolumeM3.toStringAsFixed(2)} m³');
    print('Cement Bags        : ${p.cementBags.toInt()} bags');
    print('Steel TMT          : ${p.steelMT.toStringAsFixed(2)} MT');
    print('Sand               : ${p.sandM3.toStringAsFixed(2)} m³');
    print('Aggregate          : ${p.aggregateM3.toStringAsFixed(2)} m³');
    print('Brick Count        : ${p.brickCount} nos');
    print('Structural Cost    : ₹${p.structuralCost.toInt()}');
    print('Total Project Cost : ₹${p.totalEstimatedCost.toInt()}');
    print('========================================');

    expect(p.totalConcreteVolumeM3, greaterThanOrEqualTo(90));
    expect(p.totalConcreteVolumeM3, lessThanOrEqualTo(130));

    expect(p.cementBags, greaterThanOrEqualTo(1000));
    expect(p.cementBags, lessThanOrEqualTo(1400));

    expect(p.steelMT, greaterThanOrEqualTo(7));
    expect(p.steelMT, lessThanOrEqualTo(10));

    expect(p.brickCount, greaterThanOrEqualTo(35000));
    expect(p.brickCount, lessThanOrEqualTo(45000));

    expect(p.structuralCost, greaterThanOrEqualTo(1800000));
    expect(p.structuralCost, lessThanOrEqualTo(2500000));
  });
}
