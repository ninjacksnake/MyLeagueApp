// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_doc.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlayerDocCollection on Isar {
  IsarCollection<PlayerDoc> get playerDocs => this.collection();
}

const PlayerDocSchema = CollectionSchema(
  name: r'PlayerDoc',
  id: -1944265883744164397,
  properties: {
    r'age': PropertySchema(
      id: 0,
      name: r'age',
      type: IsarType.long,
    ),
    r'email': PropertySchema(
      id: 1,
      name: r'email',
      type: IsarType.string,
    ),
    r'jerseyNumber': PropertySchema(
      id: 2,
      name: r'jerseyNumber',
      type: IsarType.long,
    ),
    r'monthlyFee': PropertySchema(
      id: 3,
      name: r'monthlyFee',
      type: IsarType.double,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(
      id: 5,
      name: r'phone',
      type: IsarType.string,
    ),
    r'playerId': PropertySchema(
      id: 6,
      name: r'playerId',
      type: IsarType.string,
    ),
    r'position': PropertySchema(
      id: 7,
      name: r'position',
      type: IsarType.string,
    ),
    r'rawPaymentsJson': PropertySchema(
      id: 8,
      name: r'rawPaymentsJson',
      type: IsarType.string,
    )
  },
  estimateSize: _playerDocEstimateSize,
  serialize: _playerDocSerialize,
  deserialize: _playerDocDeserialize,
  deserializeProp: _playerDocDeserializeProp,
  idName: r'id',
  indexes: {
    r'playerId': IndexSchema(
      id: 8338580293383144444,
      name: r'playerId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'playerId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _playerDocGetId,
  getLinks: _playerDocGetLinks,
  attach: _playerDocAttach,
  version: '3.1.0+1',
);

int _playerDocEstimateSize(
  PlayerDoc object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.phone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.playerId.length * 3;
  {
    final value = object.position;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.rawPaymentsJson.length * 3;
  return bytesCount;
}

void _playerDocSerialize(
  PlayerDoc object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.age);
  writer.writeString(offsets[1], object.email);
  writer.writeLong(offsets[2], object.jerseyNumber);
  writer.writeDouble(offsets[3], object.monthlyFee);
  writer.writeString(offsets[4], object.name);
  writer.writeString(offsets[5], object.phone);
  writer.writeString(offsets[6], object.playerId);
  writer.writeString(offsets[7], object.position);
  writer.writeString(offsets[8], object.rawPaymentsJson);
}

PlayerDoc _playerDocDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlayerDoc();
  object.age = reader.readLongOrNull(offsets[0]);
  object.email = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.jerseyNumber = reader.readLongOrNull(offsets[2]);
  object.monthlyFee = reader.readDoubleOrNull(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.phone = reader.readStringOrNull(offsets[5]);
  object.playerId = reader.readString(offsets[6]);
  object.position = reader.readStringOrNull(offsets[7]);
  object.rawPaymentsJson = reader.readString(offsets[8]);
  return object;
}

P _playerDocDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playerDocGetId(PlayerDoc object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playerDocGetLinks(PlayerDoc object) {
  return [];
}

void _playerDocAttach(IsarCollection<dynamic> col, Id id, PlayerDoc object) {
  object.id = id;
}

extension PlayerDocByIndex on IsarCollection<PlayerDoc> {
  Future<PlayerDoc?> getByPlayerId(String playerId) {
    return getByIndex(r'playerId', [playerId]);
  }

  PlayerDoc? getByPlayerIdSync(String playerId) {
    return getByIndexSync(r'playerId', [playerId]);
  }

  Future<bool> deleteByPlayerId(String playerId) {
    return deleteByIndex(r'playerId', [playerId]);
  }

  bool deleteByPlayerIdSync(String playerId) {
    return deleteByIndexSync(r'playerId', [playerId]);
  }

  Future<List<PlayerDoc?>> getAllByPlayerId(List<String> playerIdValues) {
    final values = playerIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'playerId', values);
  }

  List<PlayerDoc?> getAllByPlayerIdSync(List<String> playerIdValues) {
    final values = playerIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'playerId', values);
  }

  Future<int> deleteAllByPlayerId(List<String> playerIdValues) {
    final values = playerIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'playerId', values);
  }

  int deleteAllByPlayerIdSync(List<String> playerIdValues) {
    final values = playerIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'playerId', values);
  }

  Future<Id> putByPlayerId(PlayerDoc object) {
    return putByIndex(r'playerId', object);
  }

  Id putByPlayerIdSync(PlayerDoc object, {bool saveLinks = true}) {
    return putByIndexSync(r'playerId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPlayerId(List<PlayerDoc> objects) {
    return putAllByIndex(r'playerId', objects);
  }

  List<Id> putAllByPlayerIdSync(List<PlayerDoc> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'playerId', objects, saveLinks: saveLinks);
  }
}

extension PlayerDocQueryWhereSort
    on QueryBuilder<PlayerDoc, PlayerDoc, QWhere> {
  QueryBuilder<PlayerDoc, PlayerDoc, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlayerDocQueryWhere
    on QueryBuilder<PlayerDoc, PlayerDoc, QWhereClause> {
  QueryBuilder<PlayerDoc, PlayerDoc, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterWhereClause> playerIdEqualTo(
      String playerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'playerId',
        value: [playerId],
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterWhereClause> playerIdNotEqualTo(
      String playerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playerId',
              lower: [],
              upper: [playerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playerId',
              lower: [playerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playerId',
              lower: [playerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playerId',
              lower: [],
              upper: [playerId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PlayerDocQueryFilter
    on QueryBuilder<PlayerDoc, PlayerDoc, QFilterCondition> {
  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> ageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'age',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> ageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'age',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> ageEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> ageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> ageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> ageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'age',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      jerseyNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jerseyNumber',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      jerseyNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jerseyNumber',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> jerseyNumberEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jerseyNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      jerseyNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jerseyNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      jerseyNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jerseyNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> jerseyNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jerseyNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> monthlyFeeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'monthlyFee',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      monthlyFeeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'monthlyFee',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> monthlyFeeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyFee',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      monthlyFeeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyFee',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> monthlyFeeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyFee',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> monthlyFeeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyFee',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> playerIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> playerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> playerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> playerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> playerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> playerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> playerIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> playerIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> playerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      playerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playerId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> positionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'position',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      positionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'position',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> positionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'position',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> positionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'position',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> positionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'position',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> positionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'position',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> positionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'position',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> positionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'position',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> positionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'position',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> positionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'position',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition> positionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'position',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      positionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'position',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      rawPaymentsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawPaymentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      rawPaymentsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawPaymentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      rawPaymentsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawPaymentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      rawPaymentsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawPaymentsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      rawPaymentsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawPaymentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      rawPaymentsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawPaymentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      rawPaymentsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawPaymentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      rawPaymentsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawPaymentsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      rawPaymentsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawPaymentsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterFilterCondition>
      rawPaymentsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawPaymentsJson',
        value: '',
      ));
    });
  }
}

extension PlayerDocQueryObject
    on QueryBuilder<PlayerDoc, PlayerDoc, QFilterCondition> {}

extension PlayerDocQueryLinks
    on QueryBuilder<PlayerDoc, PlayerDoc, QFilterCondition> {}

extension PlayerDocQuerySortBy on QueryBuilder<PlayerDoc, PlayerDoc, QSortBy> {
  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByAgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByJerseyNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jerseyNumber', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByJerseyNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jerseyNumber', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByMonthlyFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyFee', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByMonthlyFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyFee', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByPlayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByPlayerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByRawPaymentsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawPaymentsJson', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> sortByRawPaymentsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawPaymentsJson', Sort.desc);
    });
  }
}

extension PlayerDocQuerySortThenBy
    on QueryBuilder<PlayerDoc, PlayerDoc, QSortThenBy> {
  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByAgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByJerseyNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jerseyNumber', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByJerseyNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jerseyNumber', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByMonthlyFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyFee', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByMonthlyFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyFee', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByPlayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByPlayerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByRawPaymentsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawPaymentsJson', Sort.asc);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QAfterSortBy> thenByRawPaymentsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawPaymentsJson', Sort.desc);
    });
  }
}

extension PlayerDocQueryWhereDistinct
    on QueryBuilder<PlayerDoc, PlayerDoc, QDistinct> {
  QueryBuilder<PlayerDoc, PlayerDoc, QDistinct> distinctByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'age');
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QDistinct> distinctByJerseyNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jerseyNumber');
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QDistinct> distinctByMonthlyFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyFee');
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QDistinct> distinctByPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QDistinct> distinctByPlayerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QDistinct> distinctByPosition(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'position', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerDoc, PlayerDoc, QDistinct> distinctByRawPaymentsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawPaymentsJson',
          caseSensitive: caseSensitive);
    });
  }
}

extension PlayerDocQueryProperty
    on QueryBuilder<PlayerDoc, PlayerDoc, QQueryProperty> {
  QueryBuilder<PlayerDoc, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlayerDoc, int?, QQueryOperations> ageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'age');
    });
  }

  QueryBuilder<PlayerDoc, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<PlayerDoc, int?, QQueryOperations> jerseyNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jerseyNumber');
    });
  }

  QueryBuilder<PlayerDoc, double?, QQueryOperations> monthlyFeeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyFee');
    });
  }

  QueryBuilder<PlayerDoc, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PlayerDoc, String?, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<PlayerDoc, String, QQueryOperations> playerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerId');
    });
  }

  QueryBuilder<PlayerDoc, String?, QQueryOperations> positionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'position');
    });
  }

  QueryBuilder<PlayerDoc, String, QQueryOperations> rawPaymentsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawPaymentsJson');
    });
  }
}
