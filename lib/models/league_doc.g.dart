// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_doc.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLeagueDocCollection on Isar {
  IsarCollection<LeagueDoc> get leagueDocs => this.collection();
}

const LeagueDocSchema = CollectionSchema(
  name: r'LeagueDoc',
  id: 7689559559705696616,
  properties: {
    r'format': PropertySchema(
      id: 0,
      name: r'format',
      type: IsarType.string,
    ),
    r'leagueId': PropertySchema(
      id: 1,
      name: r'leagueId',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'rawJson': PropertySchema(
      id: 3,
      name: r'rawJson',
      type: IsarType.string,
    ),
    r'sportType': PropertySchema(
      id: 4,
      name: r'sportType',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 5,
      name: r'status',
      type: IsarType.string,
    )
  },
  estimateSize: _leagueDocEstimateSize,
  serialize: _leagueDocSerialize,
  deserialize: _leagueDocDeserialize,
  deserializeProp: _leagueDocDeserializeProp,
  idName: r'id',
  indexes: {
    r'leagueId': IndexSchema(
      id: 2443608348762382302,
      name: r'leagueId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'leagueId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _leagueDocGetId,
  getLinks: _leagueDocGetLinks,
  attach: _leagueDocAttach,
  version: '3.1.0+1',
);

int _leagueDocEstimateSize(
  LeagueDoc object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.format.length * 3;
  bytesCount += 3 + object.leagueId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.rawJson.length * 3;
  bytesCount += 3 + object.sportType.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _leagueDocSerialize(
  LeagueDoc object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.format);
  writer.writeString(offsets[1], object.leagueId);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.rawJson);
  writer.writeString(offsets[4], object.sportType);
  writer.writeString(offsets[5], object.status);
}

LeagueDoc _leagueDocDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LeagueDoc();
  object.format = reader.readString(offsets[0]);
  object.id = id;
  object.leagueId = reader.readString(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.rawJson = reader.readString(offsets[3]);
  object.sportType = reader.readString(offsets[4]);
  object.status = reader.readString(offsets[5]);
  return object;
}

P _leagueDocDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _leagueDocGetId(LeagueDoc object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _leagueDocGetLinks(LeagueDoc object) {
  return [];
}

void _leagueDocAttach(IsarCollection<dynamic> col, Id id, LeagueDoc object) {
  object.id = id;
}

extension LeagueDocByIndex on IsarCollection<LeagueDoc> {
  Future<LeagueDoc?> getByLeagueId(String leagueId) {
    return getByIndex(r'leagueId', [leagueId]);
  }

  LeagueDoc? getByLeagueIdSync(String leagueId) {
    return getByIndexSync(r'leagueId', [leagueId]);
  }

  Future<bool> deleteByLeagueId(String leagueId) {
    return deleteByIndex(r'leagueId', [leagueId]);
  }

  bool deleteByLeagueIdSync(String leagueId) {
    return deleteByIndexSync(r'leagueId', [leagueId]);
  }

  Future<List<LeagueDoc?>> getAllByLeagueId(List<String> leagueIdValues) {
    final values = leagueIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'leagueId', values);
  }

  List<LeagueDoc?> getAllByLeagueIdSync(List<String> leagueIdValues) {
    final values = leagueIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'leagueId', values);
  }

  Future<int> deleteAllByLeagueId(List<String> leagueIdValues) {
    final values = leagueIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'leagueId', values);
  }

  int deleteAllByLeagueIdSync(List<String> leagueIdValues) {
    final values = leagueIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'leagueId', values);
  }

  Future<Id> putByLeagueId(LeagueDoc object) {
    return putByIndex(r'leagueId', object);
  }

  Id putByLeagueIdSync(LeagueDoc object, {bool saveLinks = true}) {
    return putByIndexSync(r'leagueId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLeagueId(List<LeagueDoc> objects) {
    return putAllByIndex(r'leagueId', objects);
  }

  List<Id> putAllByLeagueIdSync(List<LeagueDoc> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'leagueId', objects, saveLinks: saveLinks);
  }
}

extension LeagueDocQueryWhereSort
    on QueryBuilder<LeagueDoc, LeagueDoc, QWhere> {
  QueryBuilder<LeagueDoc, LeagueDoc, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LeagueDocQueryWhere
    on QueryBuilder<LeagueDoc, LeagueDoc, QWhereClause> {
  QueryBuilder<LeagueDoc, LeagueDoc, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterWhereClause> idBetween(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterWhereClause> leagueIdEqualTo(
      String leagueId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'leagueId',
        value: [leagueId],
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterWhereClause> leagueIdNotEqualTo(
      String leagueId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'leagueId',
              lower: [],
              upper: [leagueId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'leagueId',
              lower: [leagueId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'leagueId',
              lower: [leagueId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'leagueId',
              lower: [],
              upper: [leagueId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LeagueDocQueryFilter
    on QueryBuilder<LeagueDoc, LeagueDoc, QFilterCondition> {
  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> formatEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> formatGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> formatLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> formatBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'format',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> formatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> formatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> formatContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'format',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> formatMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'format',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> formatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'format',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> formatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'format',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> leagueIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leagueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> leagueIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leagueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> leagueIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leagueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> leagueIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leagueId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> leagueIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'leagueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> leagueIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'leagueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> leagueIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'leagueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> leagueIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'leagueId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> leagueIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leagueId',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition>
      leagueIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'leagueId',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> nameContains(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> rawJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> rawJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> rawJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> rawJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> rawJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> rawJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> rawJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> rawJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> rawJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawJson',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition>
      rawJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawJson',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> sportTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition>
      sportTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> sportTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> sportTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sportType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> sportTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> sportTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> sportTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> sportTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sportType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> sportTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sportType',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition>
      sportTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sportType',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> statusContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }
}

extension LeagueDocQueryObject
    on QueryBuilder<LeagueDoc, LeagueDoc, QFilterCondition> {}

extension LeagueDocQueryLinks
    on QueryBuilder<LeagueDoc, LeagueDoc, QFilterCondition> {}

extension LeagueDocQuerySortBy on QueryBuilder<LeagueDoc, LeagueDoc, QSortBy> {
  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortByFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'format', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortByFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'format', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortByLeagueId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leagueId', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortByLeagueIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leagueId', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortByRawJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawJson', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortByRawJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawJson', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortBySportType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sportType', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortBySportTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sportType', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension LeagueDocQuerySortThenBy
    on QueryBuilder<LeagueDoc, LeagueDoc, QSortThenBy> {
  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'format', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'format', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByLeagueId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leagueId', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByLeagueIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leagueId', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByRawJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawJson', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByRawJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawJson', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenBySportType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sportType', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenBySportTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sportType', Sort.desc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension LeagueDocQueryWhereDistinct
    on QueryBuilder<LeagueDoc, LeagueDoc, QDistinct> {
  QueryBuilder<LeagueDoc, LeagueDoc, QDistinct> distinctByFormat(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'format', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QDistinct> distinctByLeagueId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leagueId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QDistinct> distinctByRawJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QDistinct> distinctBySportType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sportType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeagueDoc, LeagueDoc, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension LeagueDocQueryProperty
    on QueryBuilder<LeagueDoc, LeagueDoc, QQueryProperty> {
  QueryBuilder<LeagueDoc, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LeagueDoc, String, QQueryOperations> formatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'format');
    });
  }

  QueryBuilder<LeagueDoc, String, QQueryOperations> leagueIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leagueId');
    });
  }

  QueryBuilder<LeagueDoc, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LeagueDoc, String, QQueryOperations> rawJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawJson');
    });
  }

  QueryBuilder<LeagueDoc, String, QQueryOperations> sportTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sportType');
    });
  }

  QueryBuilder<LeagueDoc, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
