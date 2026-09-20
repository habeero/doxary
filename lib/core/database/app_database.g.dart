// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OrganizationsTable extends Organizations
    with TableInfo<$OrganizationsTable, Organization> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganizationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organizations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Organization> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Organization map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Organization(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OrganizationsTable createAlias(String alias) {
    return $OrganizationsTable(attachedDatabase, alias);
  }
}

class Organization extends DataClass implements Insertable<Organization> {
  final String id;
  final String name;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Organization({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrganizationsCompanion toCompanion(bool nullToAbsent) {
    return OrganizationsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Organization.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Organization(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Organization copyWith({
    String? id,
    String? name,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Organization(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Organization copyWithCompanion(OrganizationsCompanion data) {
    return Organization(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Organization(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Organization &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrganizationsCompanion extends UpdateCompanion<Organization> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OrganizationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrganizationsCompanion.insert({
    required String id,
    required String name,
    required String category,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Organization> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrganizationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OrganizationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganizationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CasesTable extends Cases with TableInfo<$CasesTable, Case> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizations (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizationId,
    title,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cases';
  @override
  VerificationContext validateIntegrity(
    Insertable<Case> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Case map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Case(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CasesTable createAlias(String alias) {
    return $CasesTable(attachedDatabase, alias);
  }
}

class Case extends DataClass implements Insertable<Case> {
  final String id;
  final String organizationId;
  final String title;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Case({
    required this.id,
    required this.organizationId,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['organization_id'] = Variable<String>(organizationId);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CasesCompanion toCompanion(bool nullToAbsent) {
    return CasesCompanion(
      id: Value(id),
      organizationId: Value(organizationId),
      title: Value(title),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Case.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Case(
      id: serializer.fromJson<String>(json['id']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'organizationId': serializer.toJson<String>(organizationId),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Case copyWith({
    String? id,
    String? organizationId,
    String? title,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Case(
    id: id ?? this.id,
    organizationId: organizationId ?? this.organizationId,
    title: title ?? this.title,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Case copyWithCompanion(CasesCompanion data) {
    return Case(
      id: data.id.present ? data.id.value : this.id,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Case(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, organizationId, title, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Case &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.title == this.title &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CasesCompanion extends UpdateCompanion<Case> {
  final Value<String> id;
  final Value<String> organizationId;
  final Value<String> title;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CasesCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CasesCompanion.insert({
    required String id,
    required String organizationId,
    required String title,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       organizationId = Value(organizationId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Case> custom({
    Expression<String>? id,
    Expression<String>? organizationId,
    Expression<String>? title,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CasesCompanion copyWith({
    Value<String>? id,
    Value<String>? organizationId,
    Value<String>? title,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CasesCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      title: title ?? this.title,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CasesCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientDocumentIdMeta = const VerificationMeta(
    'clientDocumentId',
  );
  @override
  late final GeneratedColumn<String> clientDocumentId = GeneratedColumn<String>(
    'client_document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizations (id)',
    ),
  );
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<String> caseId = GeneratedColumn<String>(
    'case_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cases (id)',
    ),
  );
  static const VerificationMeta _classificationStateMeta =
      const VerificationMeta('classificationState');
  @override
  late final GeneratedColumn<String> classificationState =
      GeneratedColumn<String>(
        'classification_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentDateMeta = const VerificationMeta(
    'documentDate',
  );
  @override
  late final GeneratedColumn<DateTime> documentDate = GeneratedColumn<DateTime>(
    'document_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceLanguageMeta = const VerificationMeta(
    'sourceLanguage',
  );
  @override
  late final GeneratedColumn<String> sourceLanguage = GeneratedColumn<String>(
    'source_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientDocumentId,
    organizationId,
    caseId,
    classificationState,
    status,
    documentDate,
    sourceLanguage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Document> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_document_id')) {
      context.handle(
        _clientDocumentIdMeta,
        clientDocumentId.isAcceptableOrUnknown(
          data['client_document_id']!,
          _clientDocumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientDocumentIdMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    }
    if (data.containsKey('classification_state')) {
      context.handle(
        _classificationStateMeta,
        classificationState.isAcceptableOrUnknown(
          data['classification_state']!,
          _classificationStateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_classificationStateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('document_date')) {
      context.handle(
        _documentDateMeta,
        documentDate.isAcceptableOrUnknown(
          data['document_date']!,
          _documentDateMeta,
        ),
      );
    }
    if (data.containsKey('source_language')) {
      context.handle(
        _sourceLanguageMeta,
        sourceLanguage.isAcceptableOrUnknown(
          data['source_language']!,
          _sourceLanguageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientDocumentId};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      clientDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_document_id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      ),
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}case_id'],
      ),
      classificationState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification_state'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      documentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}document_date'],
      ),
      sourceLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_language'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final String clientDocumentId;
  final String? organizationId;
  final String? caseId;
  final String classificationState;
  final String status;
  final DateTime? documentDate;
  final String? sourceLanguage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Document({
    required this.clientDocumentId,
    this.organizationId,
    this.caseId,
    required this.classificationState,
    required this.status,
    this.documentDate,
    this.sourceLanguage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_document_id'] = Variable<String>(clientDocumentId);
    if (!nullToAbsent || organizationId != null) {
      map['organization_id'] = Variable<String>(organizationId);
    }
    if (!nullToAbsent || caseId != null) {
      map['case_id'] = Variable<String>(caseId);
    }
    map['classification_state'] = Variable<String>(classificationState);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || documentDate != null) {
      map['document_date'] = Variable<DateTime>(documentDate);
    }
    if (!nullToAbsent || sourceLanguage != null) {
      map['source_language'] = Variable<String>(sourceLanguage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      clientDocumentId: Value(clientDocumentId),
      organizationId: organizationId == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationId),
      caseId: caseId == null && nullToAbsent
          ? const Value.absent()
          : Value(caseId),
      classificationState: Value(classificationState),
      status: Value(status),
      documentDate: documentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(documentDate),
      sourceLanguage: sourceLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLanguage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Document.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      clientDocumentId: serializer.fromJson<String>(json['clientDocumentId']),
      organizationId: serializer.fromJson<String?>(json['organizationId']),
      caseId: serializer.fromJson<String?>(json['caseId']),
      classificationState: serializer.fromJson<String>(
        json['classificationState'],
      ),
      status: serializer.fromJson<String>(json['status']),
      documentDate: serializer.fromJson<DateTime?>(json['documentDate']),
      sourceLanguage: serializer.fromJson<String?>(json['sourceLanguage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientDocumentId': serializer.toJson<String>(clientDocumentId),
      'organizationId': serializer.toJson<String?>(organizationId),
      'caseId': serializer.toJson<String?>(caseId),
      'classificationState': serializer.toJson<String>(classificationState),
      'status': serializer.toJson<String>(status),
      'documentDate': serializer.toJson<DateTime?>(documentDate),
      'sourceLanguage': serializer.toJson<String?>(sourceLanguage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Document copyWith({
    String? clientDocumentId,
    Value<String?> organizationId = const Value.absent(),
    Value<String?> caseId = const Value.absent(),
    String? classificationState,
    String? status,
    Value<DateTime?> documentDate = const Value.absent(),
    Value<String?> sourceLanguage = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Document(
    clientDocumentId: clientDocumentId ?? this.clientDocumentId,
    organizationId: organizationId.present
        ? organizationId.value
        : this.organizationId,
    caseId: caseId.present ? caseId.value : this.caseId,
    classificationState: classificationState ?? this.classificationState,
    status: status ?? this.status,
    documentDate: documentDate.present ? documentDate.value : this.documentDate,
    sourceLanguage: sourceLanguage.present
        ? sourceLanguage.value
        : this.sourceLanguage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      clientDocumentId: data.clientDocumentId.present
          ? data.clientDocumentId.value
          : this.clientDocumentId,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      classificationState: data.classificationState.present
          ? data.classificationState.value
          : this.classificationState,
      status: data.status.present ? data.status.value : this.status,
      documentDate: data.documentDate.present
          ? data.documentDate.value
          : this.documentDate,
      sourceLanguage: data.sourceLanguage.present
          ? data.sourceLanguage.value
          : this.sourceLanguage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('organizationId: $organizationId, ')
          ..write('caseId: $caseId, ')
          ..write('classificationState: $classificationState, ')
          ..write('status: $status, ')
          ..write('documentDate: $documentDate, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientDocumentId,
    organizationId,
    caseId,
    classificationState,
    status,
    documentDate,
    sourceLanguage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.clientDocumentId == this.clientDocumentId &&
          other.organizationId == this.organizationId &&
          other.caseId == this.caseId &&
          other.classificationState == this.classificationState &&
          other.status == this.status &&
          other.documentDate == this.documentDate &&
          other.sourceLanguage == this.sourceLanguage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<String> clientDocumentId;
  final Value<String?> organizationId;
  final Value<String?> caseId;
  final Value<String> classificationState;
  final Value<String> status;
  final Value<DateTime?> documentDate;
  final Value<String?> sourceLanguage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DocumentsCompanion({
    this.clientDocumentId = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.caseId = const Value.absent(),
    this.classificationState = const Value.absent(),
    this.status = const Value.absent(),
    this.documentDate = const Value.absent(),
    this.sourceLanguage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsCompanion.insert({
    required String clientDocumentId,
    this.organizationId = const Value.absent(),
    this.caseId = const Value.absent(),
    required String classificationState,
    required String status,
    this.documentDate = const Value.absent(),
    this.sourceLanguage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : clientDocumentId = Value(clientDocumentId),
       classificationState = Value(classificationState),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Document> custom({
    Expression<String>? clientDocumentId,
    Expression<String>? organizationId,
    Expression<String>? caseId,
    Expression<String>? classificationState,
    Expression<String>? status,
    Expression<DateTime>? documentDate,
    Expression<String>? sourceLanguage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientDocumentId != null) 'client_document_id': clientDocumentId,
      if (organizationId != null) 'organization_id': organizationId,
      if (caseId != null) 'case_id': caseId,
      if (classificationState != null)
        'classification_state': classificationState,
      if (status != null) 'status': status,
      if (documentDate != null) 'document_date': documentDate,
      if (sourceLanguage != null) 'source_language': sourceLanguage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsCompanion copyWith({
    Value<String>? clientDocumentId,
    Value<String?>? organizationId,
    Value<String?>? caseId,
    Value<String>? classificationState,
    Value<String>? status,
    Value<DateTime?>? documentDate,
    Value<String?>? sourceLanguage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DocumentsCompanion(
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
      organizationId: organizationId ?? this.organizationId,
      caseId: caseId ?? this.caseId,
      classificationState: classificationState ?? this.classificationState,
      status: status ?? this.status,
      documentDate: documentDate ?? this.documentDate,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientDocumentId.present) {
      map['client_document_id'] = Variable<String>(clientDocumentId.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<String>(caseId.value);
    }
    if (classificationState.present) {
      map['classification_state'] = Variable<String>(classificationState.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (documentDate.present) {
      map['document_date'] = Variable<DateTime>(documentDate.value);
    }
    if (sourceLanguage.present) {
      map['source_language'] = Variable<String>(sourceLanguage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('organizationId: $organizationId, ')
          ..write('caseId: $caseId, ')
          ..write('classificationState: $classificationState, ')
          ..write('status: $status, ')
          ..write('documentDate: $documentDate, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentFilesTable extends DocumentFiles
    with TableInfo<$DocumentFilesTable, DocumentFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientDocumentIdMeta = const VerificationMeta(
    'clientDocumentId',
  );
  @override
  late final GeneratedColumn<String> clientDocumentId = GeneratedColumn<String>(
    'client_document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (client_document_id)',
    ),
  );
  static const VerificationMeta _localUriMeta = const VerificationMeta(
    'localUri',
  );
  @override
  late final GeneratedColumn<String> localUri = GeneratedColumn<String>(
    'local_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalFilenameMeta = const VerificationMeta(
    'originalFilename',
  );
  @override
  late final GeneratedColumn<String> originalFilename = GeneratedColumn<String>(
    'original_filename',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageOrderMeta = const VerificationMeta(
    'pageOrder',
  );
  @override
  late final GeneratedColumn<int> pageOrder = GeneratedColumn<int>(
    'page_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _importSourceMeta = const VerificationMeta(
    'importSource',
  );
  @override
  late final GeneratedColumn<String> importSource = GeneratedColumn<String>(
    'import_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('filePicker'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientDocumentId,
    localUri,
    mediaType,
    originalFilename,
    byteSize,
    importedAt,
    pageOrder,
    importSource,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_document_id')) {
      context.handle(
        _clientDocumentIdMeta,
        clientDocumentId.isAcceptableOrUnknown(
          data['client_document_id']!,
          _clientDocumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientDocumentIdMeta);
    }
    if (data.containsKey('local_uri')) {
      context.handle(
        _localUriMeta,
        localUri.isAcceptableOrUnknown(data['local_uri']!, _localUriMeta),
      );
    } else if (isInserting) {
      context.missing(_localUriMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('original_filename')) {
      context.handle(
        _originalFilenameMeta,
        originalFilename.isAcceptableOrUnknown(
          data['original_filename']!,
          _originalFilenameMeta,
        ),
      );
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('page_order')) {
      context.handle(
        _pageOrderMeta,
        pageOrder.isAcceptableOrUnknown(data['page_order']!, _pageOrderMeta),
      );
    }
    if (data.containsKey('import_source')) {
      context.handle(
        _importSourceMeta,
        importSource.isAcceptableOrUnknown(
          data['import_source']!,
          _importSourceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_document_id'],
      )!,
      localUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_uri'],
      )!,
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      originalFilename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_filename'],
      ),
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      ),
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
      pageOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_order'],
      )!,
      importSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_source'],
      )!,
    );
  }

  @override
  $DocumentFilesTable createAlias(String alias) {
    return $DocumentFilesTable(attachedDatabase, alias);
  }
}

class DocumentFile extends DataClass implements Insertable<DocumentFile> {
  final String id;
  final String clientDocumentId;
  final String localUri;
  final String mediaType;
  final String? originalFilename;
  final int? byteSize;
  final DateTime importedAt;
  final int pageOrder;
  final String importSource;
  const DocumentFile({
    required this.id,
    required this.clientDocumentId,
    required this.localUri,
    required this.mediaType,
    this.originalFilename,
    this.byteSize,
    required this.importedAt,
    required this.pageOrder,
    required this.importSource,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_document_id'] = Variable<String>(clientDocumentId);
    map['local_uri'] = Variable<String>(localUri);
    map['media_type'] = Variable<String>(mediaType);
    if (!nullToAbsent || originalFilename != null) {
      map['original_filename'] = Variable<String>(originalFilename);
    }
    if (!nullToAbsent || byteSize != null) {
      map['byte_size'] = Variable<int>(byteSize);
    }
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['page_order'] = Variable<int>(pageOrder);
    map['import_source'] = Variable<String>(importSource);
    return map;
  }

  DocumentFilesCompanion toCompanion(bool nullToAbsent) {
    return DocumentFilesCompanion(
      id: Value(id),
      clientDocumentId: Value(clientDocumentId),
      localUri: Value(localUri),
      mediaType: Value(mediaType),
      originalFilename: originalFilename == null && nullToAbsent
          ? const Value.absent()
          : Value(originalFilename),
      byteSize: byteSize == null && nullToAbsent
          ? const Value.absent()
          : Value(byteSize),
      importedAt: Value(importedAt),
      pageOrder: Value(pageOrder),
      importSource: Value(importSource),
    );
  }

  factory DocumentFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentFile(
      id: serializer.fromJson<String>(json['id']),
      clientDocumentId: serializer.fromJson<String>(json['clientDocumentId']),
      localUri: serializer.fromJson<String>(json['localUri']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      originalFilename: serializer.fromJson<String?>(json['originalFilename']),
      byteSize: serializer.fromJson<int?>(json['byteSize']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      pageOrder: serializer.fromJson<int>(json['pageOrder']),
      importSource: serializer.fromJson<String>(json['importSource']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientDocumentId': serializer.toJson<String>(clientDocumentId),
      'localUri': serializer.toJson<String>(localUri),
      'mediaType': serializer.toJson<String>(mediaType),
      'originalFilename': serializer.toJson<String?>(originalFilename),
      'byteSize': serializer.toJson<int?>(byteSize),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'pageOrder': serializer.toJson<int>(pageOrder),
      'importSource': serializer.toJson<String>(importSource),
    };
  }

  DocumentFile copyWith({
    String? id,
    String? clientDocumentId,
    String? localUri,
    String? mediaType,
    Value<String?> originalFilename = const Value.absent(),
    Value<int?> byteSize = const Value.absent(),
    DateTime? importedAt,
    int? pageOrder,
    String? importSource,
  }) => DocumentFile(
    id: id ?? this.id,
    clientDocumentId: clientDocumentId ?? this.clientDocumentId,
    localUri: localUri ?? this.localUri,
    mediaType: mediaType ?? this.mediaType,
    originalFilename: originalFilename.present
        ? originalFilename.value
        : this.originalFilename,
    byteSize: byteSize.present ? byteSize.value : this.byteSize,
    importedAt: importedAt ?? this.importedAt,
    pageOrder: pageOrder ?? this.pageOrder,
    importSource: importSource ?? this.importSource,
  );
  DocumentFile copyWithCompanion(DocumentFilesCompanion data) {
    return DocumentFile(
      id: data.id.present ? data.id.value : this.id,
      clientDocumentId: data.clientDocumentId.present
          ? data.clientDocumentId.value
          : this.clientDocumentId,
      localUri: data.localUri.present ? data.localUri.value : this.localUri,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      originalFilename: data.originalFilename.present
          ? data.originalFilename.value
          : this.originalFilename,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      pageOrder: data.pageOrder.present ? data.pageOrder.value : this.pageOrder,
      importSource: data.importSource.present
          ? data.importSource.value
          : this.importSource,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentFile(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('localUri: $localUri, ')
          ..write('mediaType: $mediaType, ')
          ..write('originalFilename: $originalFilename, ')
          ..write('byteSize: $byteSize, ')
          ..write('importedAt: $importedAt, ')
          ..write('pageOrder: $pageOrder, ')
          ..write('importSource: $importSource')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientDocumentId,
    localUri,
    mediaType,
    originalFilename,
    byteSize,
    importedAt,
    pageOrder,
    importSource,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentFile &&
          other.id == this.id &&
          other.clientDocumentId == this.clientDocumentId &&
          other.localUri == this.localUri &&
          other.mediaType == this.mediaType &&
          other.originalFilename == this.originalFilename &&
          other.byteSize == this.byteSize &&
          other.importedAt == this.importedAt &&
          other.pageOrder == this.pageOrder &&
          other.importSource == this.importSource);
}

class DocumentFilesCompanion extends UpdateCompanion<DocumentFile> {
  final Value<String> id;
  final Value<String> clientDocumentId;
  final Value<String> localUri;
  final Value<String> mediaType;
  final Value<String?> originalFilename;
  final Value<int?> byteSize;
  final Value<DateTime> importedAt;
  final Value<int> pageOrder;
  final Value<String> importSource;
  final Value<int> rowid;
  const DocumentFilesCompanion({
    this.id = const Value.absent(),
    this.clientDocumentId = const Value.absent(),
    this.localUri = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.originalFilename = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.pageOrder = const Value.absent(),
    this.importSource = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentFilesCompanion.insert({
    required String id,
    required String clientDocumentId,
    required String localUri,
    required String mediaType,
    this.originalFilename = const Value.absent(),
    this.byteSize = const Value.absent(),
    required DateTime importedAt,
    this.pageOrder = const Value.absent(),
    this.importSource = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientDocumentId = Value(clientDocumentId),
       localUri = Value(localUri),
       mediaType = Value(mediaType),
       importedAt = Value(importedAt);
  static Insertable<DocumentFile> custom({
    Expression<String>? id,
    Expression<String>? clientDocumentId,
    Expression<String>? localUri,
    Expression<String>? mediaType,
    Expression<String>? originalFilename,
    Expression<int>? byteSize,
    Expression<DateTime>? importedAt,
    Expression<int>? pageOrder,
    Expression<String>? importSource,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientDocumentId != null) 'client_document_id': clientDocumentId,
      if (localUri != null) 'local_uri': localUri,
      if (mediaType != null) 'media_type': mediaType,
      if (originalFilename != null) 'original_filename': originalFilename,
      if (byteSize != null) 'byte_size': byteSize,
      if (importedAt != null) 'imported_at': importedAt,
      if (pageOrder != null) 'page_order': pageOrder,
      if (importSource != null) 'import_source': importSource,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentFilesCompanion copyWith({
    Value<String>? id,
    Value<String>? clientDocumentId,
    Value<String>? localUri,
    Value<String>? mediaType,
    Value<String?>? originalFilename,
    Value<int?>? byteSize,
    Value<DateTime>? importedAt,
    Value<int>? pageOrder,
    Value<String>? importSource,
    Value<int>? rowid,
  }) {
    return DocumentFilesCompanion(
      id: id ?? this.id,
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
      localUri: localUri ?? this.localUri,
      mediaType: mediaType ?? this.mediaType,
      originalFilename: originalFilename ?? this.originalFilename,
      byteSize: byteSize ?? this.byteSize,
      importedAt: importedAt ?? this.importedAt,
      pageOrder: pageOrder ?? this.pageOrder,
      importSource: importSource ?? this.importSource,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientDocumentId.present) {
      map['client_document_id'] = Variable<String>(clientDocumentId.value);
    }
    if (localUri.present) {
      map['local_uri'] = Variable<String>(localUri.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (originalFilename.present) {
      map['original_filename'] = Variable<String>(originalFilename.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (pageOrder.present) {
      map['page_order'] = Variable<int>(pageOrder.value);
    }
    if (importSource.present) {
      map['import_source'] = Variable<String>(importSource.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentFilesCompanion(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('localUri: $localUri, ')
          ..write('mediaType: $mediaType, ')
          ..write('originalFilename: $originalFilename, ')
          ..write('byteSize: $byteSize, ')
          ..write('importedAt: $importedAt, ')
          ..write('pageOrder: $pageOrder, ')
          ..write('importSource: $importSource, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysesTable extends Analyses with TableInfo<$AnalysesTable, Analyse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientDocumentIdMeta = const VerificationMeta(
    'clientDocumentId',
  );
  @override
  late final GeneratedColumn<String> clientDocumentId = GeneratedColumn<String>(
    'client_document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (client_document_id)',
    ),
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<String> schemaVersion = GeneratedColumn<String>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetLanguageMeta = const VerificationMeta(
    'targetLanguage',
  );
  @override
  late final GeneratedColumn<String> targetLanguage = GeneratedColumn<String>(
    'target_language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisStatusMeta = const VerificationMeta(
    'analysisStatus',
  );
  @override
  late final GeneratedColumn<String> analysisStatus = GeneratedColumn<String>(
    'analysis_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('complete'),
  );
  static const VerificationMeta _actionRequiredMeta = const VerificationMeta(
    'actionRequired',
  );
  @override
  late final GeneratedColumn<String> actionRequired = GeneratedColumn<String>(
    'action_required',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _documentDateMeta = const VerificationMeta(
    'documentDate',
  );
  @override
  late final GeneratedColumn<String> documentDate = GeneratedColumn<String>(
    'document_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detectedLanguageMeta = const VerificationMeta(
    'detectedLanguage',
  );
  @override
  late final GeneratedColumn<String> detectedLanguage = GeneratedColumn<String>(
    'detected_language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('undetermined'),
  );
  static const VerificationMeta _urgencyMeta = const VerificationMeta(
    'urgency',
  );
  @override
  late final GeneratedColumn<String> urgency = GeneratedColumn<String>(
    'urgency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('uncertain'),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _explanationStyleMeta = const VerificationMeta(
    'explanationStyle',
  );
  @override
  late final GeneratedColumn<String> explanationStyle = GeneratedColumn<String>(
    'explanation_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('standard'),
  );
  static const VerificationMeta _suggestedOrganizationNameMeta =
      const VerificationMeta('suggestedOrganizationName');
  @override
  late final GeneratedColumn<String> suggestedOrganizationName =
      GeneratedColumn<String>(
        'suggested_organization_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _suggestedDocumentTypeMeta =
      const VerificationMeta('suggestedDocumentType');
  @override
  late final GeneratedColumn<String> suggestedDocumentType =
      GeneratedColumn<String>(
        'suggested_document_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientDocumentId,
    schemaVersion,
    targetLanguage,
    summary,
    explanation,
    state,
    analysisStatus,
    actionRequired,
    documentDate,
    detectedLanguage,
    urgency,
    confidence,
    explanationStyle,
    suggestedOrganizationName,
    suggestedDocumentType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analyses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Analyse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_document_id')) {
      context.handle(
        _clientDocumentIdMeta,
        clientDocumentId.isAcceptableOrUnknown(
          data['client_document_id']!,
          _clientDocumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientDocumentIdMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    if (data.containsKey('target_language')) {
      context.handle(
        _targetLanguageMeta,
        targetLanguage.isAcceptableOrUnknown(
          data['target_language']!,
          _targetLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetLanguageMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('analysis_status')) {
      context.handle(
        _analysisStatusMeta,
        analysisStatus.isAcceptableOrUnknown(
          data['analysis_status']!,
          _analysisStatusMeta,
        ),
      );
    }
    if (data.containsKey('action_required')) {
      context.handle(
        _actionRequiredMeta,
        actionRequired.isAcceptableOrUnknown(
          data['action_required']!,
          _actionRequiredMeta,
        ),
      );
    }
    if (data.containsKey('document_date')) {
      context.handle(
        _documentDateMeta,
        documentDate.isAcceptableOrUnknown(
          data['document_date']!,
          _documentDateMeta,
        ),
      );
    }
    if (data.containsKey('detected_language')) {
      context.handle(
        _detectedLanguageMeta,
        detectedLanguage.isAcceptableOrUnknown(
          data['detected_language']!,
          _detectedLanguageMeta,
        ),
      );
    }
    if (data.containsKey('urgency')) {
      context.handle(
        _urgencyMeta,
        urgency.isAcceptableOrUnknown(data['urgency']!, _urgencyMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('explanation_style')) {
      context.handle(
        _explanationStyleMeta,
        explanationStyle.isAcceptableOrUnknown(
          data['explanation_style']!,
          _explanationStyleMeta,
        ),
      );
    }
    if (data.containsKey('suggested_organization_name')) {
      context.handle(
        _suggestedOrganizationNameMeta,
        suggestedOrganizationName.isAcceptableOrUnknown(
          data['suggested_organization_name']!,
          _suggestedOrganizationNameMeta,
        ),
      );
    }
    if (data.containsKey('suggested_document_type')) {
      context.handle(
        _suggestedDocumentTypeMeta,
        suggestedDocumentType.isAcceptableOrUnknown(
          data['suggested_document_type']!,
          _suggestedDocumentTypeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Analyse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Analyse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_document_id'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schema_version'],
      )!,
      targetLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_language'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      analysisStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_status'],
      )!,
      actionRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_required'],
      ),
      documentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_date'],
      ),
      detectedLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detected_language'],
      )!,
      urgency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urgency'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      explanationStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_style'],
      )!,
      suggestedOrganizationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_organization_name'],
      ),
      suggestedDocumentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_document_type'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AnalysesTable createAlias(String alias) {
    return $AnalysesTable(attachedDatabase, alias);
  }
}

class Analyse extends DataClass implements Insertable<Analyse> {
  final String id;
  final String clientDocumentId;
  final String schemaVersion;
  final String targetLanguage;
  final String? summary;
  final String? explanation;
  final String state;
  final String analysisStatus;
  final String? actionRequired;
  final String? documentDate;
  final String detectedLanguage;
  final String urgency;
  final double? confidence;
  final String explanationStyle;
  final String? suggestedOrganizationName;
  final String? suggestedDocumentType;
  final DateTime createdAt;
  const Analyse({
    required this.id,
    required this.clientDocumentId,
    required this.schemaVersion,
    required this.targetLanguage,
    this.summary,
    this.explanation,
    required this.state,
    required this.analysisStatus,
    this.actionRequired,
    this.documentDate,
    required this.detectedLanguage,
    required this.urgency,
    this.confidence,
    required this.explanationStyle,
    this.suggestedOrganizationName,
    this.suggestedDocumentType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_document_id'] = Variable<String>(clientDocumentId);
    map['schema_version'] = Variable<String>(schemaVersion);
    map['target_language'] = Variable<String>(targetLanguage);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    map['state'] = Variable<String>(state);
    map['analysis_status'] = Variable<String>(analysisStatus);
    if (!nullToAbsent || actionRequired != null) {
      map['action_required'] = Variable<String>(actionRequired);
    }
    if (!nullToAbsent || documentDate != null) {
      map['document_date'] = Variable<String>(documentDate);
    }
    map['detected_language'] = Variable<String>(detectedLanguage);
    map['urgency'] = Variable<String>(urgency);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    map['explanation_style'] = Variable<String>(explanationStyle);
    if (!nullToAbsent || suggestedOrganizationName != null) {
      map['suggested_organization_name'] = Variable<String>(
        suggestedOrganizationName,
      );
    }
    if (!nullToAbsent || suggestedDocumentType != null) {
      map['suggested_document_type'] = Variable<String>(suggestedDocumentType);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AnalysesCompanion toCompanion(bool nullToAbsent) {
    return AnalysesCompanion(
      id: Value(id),
      clientDocumentId: Value(clientDocumentId),
      schemaVersion: Value(schemaVersion),
      targetLanguage: Value(targetLanguage),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      state: Value(state),
      analysisStatus: Value(analysisStatus),
      actionRequired: actionRequired == null && nullToAbsent
          ? const Value.absent()
          : Value(actionRequired),
      documentDate: documentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(documentDate),
      detectedLanguage: Value(detectedLanguage),
      urgency: Value(urgency),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      explanationStyle: Value(explanationStyle),
      suggestedOrganizationName:
          suggestedOrganizationName == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedOrganizationName),
      suggestedDocumentType: suggestedDocumentType == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedDocumentType),
      createdAt: Value(createdAt),
    );
  }

  factory Analyse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Analyse(
      id: serializer.fromJson<String>(json['id']),
      clientDocumentId: serializer.fromJson<String>(json['clientDocumentId']),
      schemaVersion: serializer.fromJson<String>(json['schemaVersion']),
      targetLanguage: serializer.fromJson<String>(json['targetLanguage']),
      summary: serializer.fromJson<String?>(json['summary']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      state: serializer.fromJson<String>(json['state']),
      analysisStatus: serializer.fromJson<String>(json['analysisStatus']),
      actionRequired: serializer.fromJson<String?>(json['actionRequired']),
      documentDate: serializer.fromJson<String?>(json['documentDate']),
      detectedLanguage: serializer.fromJson<String>(json['detectedLanguage']),
      urgency: serializer.fromJson<String>(json['urgency']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      explanationStyle: serializer.fromJson<String>(json['explanationStyle']),
      suggestedOrganizationName: serializer.fromJson<String?>(
        json['suggestedOrganizationName'],
      ),
      suggestedDocumentType: serializer.fromJson<String?>(
        json['suggestedDocumentType'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientDocumentId': serializer.toJson<String>(clientDocumentId),
      'schemaVersion': serializer.toJson<String>(schemaVersion),
      'targetLanguage': serializer.toJson<String>(targetLanguage),
      'summary': serializer.toJson<String?>(summary),
      'explanation': serializer.toJson<String?>(explanation),
      'state': serializer.toJson<String>(state),
      'analysisStatus': serializer.toJson<String>(analysisStatus),
      'actionRequired': serializer.toJson<String?>(actionRequired),
      'documentDate': serializer.toJson<String?>(documentDate),
      'detectedLanguage': serializer.toJson<String>(detectedLanguage),
      'urgency': serializer.toJson<String>(urgency),
      'confidence': serializer.toJson<double?>(confidence),
      'explanationStyle': serializer.toJson<String>(explanationStyle),
      'suggestedOrganizationName': serializer.toJson<String?>(
        suggestedOrganizationName,
      ),
      'suggestedDocumentType': serializer.toJson<String?>(
        suggestedDocumentType,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Analyse copyWith({
    String? id,
    String? clientDocumentId,
    String? schemaVersion,
    String? targetLanguage,
    Value<String?> summary = const Value.absent(),
    Value<String?> explanation = const Value.absent(),
    String? state,
    String? analysisStatus,
    Value<String?> actionRequired = const Value.absent(),
    Value<String?> documentDate = const Value.absent(),
    String? detectedLanguage,
    String? urgency,
    Value<double?> confidence = const Value.absent(),
    String? explanationStyle,
    Value<String?> suggestedOrganizationName = const Value.absent(),
    Value<String?> suggestedDocumentType = const Value.absent(),
    DateTime? createdAt,
  }) => Analyse(
    id: id ?? this.id,
    clientDocumentId: clientDocumentId ?? this.clientDocumentId,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    targetLanguage: targetLanguage ?? this.targetLanguage,
    summary: summary.present ? summary.value : this.summary,
    explanation: explanation.present ? explanation.value : this.explanation,
    state: state ?? this.state,
    analysisStatus: analysisStatus ?? this.analysisStatus,
    actionRequired: actionRequired.present
        ? actionRequired.value
        : this.actionRequired,
    documentDate: documentDate.present ? documentDate.value : this.documentDate,
    detectedLanguage: detectedLanguage ?? this.detectedLanguage,
    urgency: urgency ?? this.urgency,
    confidence: confidence.present ? confidence.value : this.confidence,
    explanationStyle: explanationStyle ?? this.explanationStyle,
    suggestedOrganizationName: suggestedOrganizationName.present
        ? suggestedOrganizationName.value
        : this.suggestedOrganizationName,
    suggestedDocumentType: suggestedDocumentType.present
        ? suggestedDocumentType.value
        : this.suggestedDocumentType,
    createdAt: createdAt ?? this.createdAt,
  );
  Analyse copyWithCompanion(AnalysesCompanion data) {
    return Analyse(
      id: data.id.present ? data.id.value : this.id,
      clientDocumentId: data.clientDocumentId.present
          ? data.clientDocumentId.value
          : this.clientDocumentId,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      targetLanguage: data.targetLanguage.present
          ? data.targetLanguage.value
          : this.targetLanguage,
      summary: data.summary.present ? data.summary.value : this.summary,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      state: data.state.present ? data.state.value : this.state,
      analysisStatus: data.analysisStatus.present
          ? data.analysisStatus.value
          : this.analysisStatus,
      actionRequired: data.actionRequired.present
          ? data.actionRequired.value
          : this.actionRequired,
      documentDate: data.documentDate.present
          ? data.documentDate.value
          : this.documentDate,
      detectedLanguage: data.detectedLanguage.present
          ? data.detectedLanguage.value
          : this.detectedLanguage,
      urgency: data.urgency.present ? data.urgency.value : this.urgency,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      explanationStyle: data.explanationStyle.present
          ? data.explanationStyle.value
          : this.explanationStyle,
      suggestedOrganizationName: data.suggestedOrganizationName.present
          ? data.suggestedOrganizationName.value
          : this.suggestedOrganizationName,
      suggestedDocumentType: data.suggestedDocumentType.present
          ? data.suggestedDocumentType.value
          : this.suggestedDocumentType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Analyse(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('summary: $summary, ')
          ..write('explanation: $explanation, ')
          ..write('state: $state, ')
          ..write('analysisStatus: $analysisStatus, ')
          ..write('actionRequired: $actionRequired, ')
          ..write('documentDate: $documentDate, ')
          ..write('detectedLanguage: $detectedLanguage, ')
          ..write('urgency: $urgency, ')
          ..write('confidence: $confidence, ')
          ..write('explanationStyle: $explanationStyle, ')
          ..write('suggestedOrganizationName: $suggestedOrganizationName, ')
          ..write('suggestedDocumentType: $suggestedDocumentType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientDocumentId,
    schemaVersion,
    targetLanguage,
    summary,
    explanation,
    state,
    analysisStatus,
    actionRequired,
    documentDate,
    detectedLanguage,
    urgency,
    confidence,
    explanationStyle,
    suggestedOrganizationName,
    suggestedDocumentType,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Analyse &&
          other.id == this.id &&
          other.clientDocumentId == this.clientDocumentId &&
          other.schemaVersion == this.schemaVersion &&
          other.targetLanguage == this.targetLanguage &&
          other.summary == this.summary &&
          other.explanation == this.explanation &&
          other.state == this.state &&
          other.analysisStatus == this.analysisStatus &&
          other.actionRequired == this.actionRequired &&
          other.documentDate == this.documentDate &&
          other.detectedLanguage == this.detectedLanguage &&
          other.urgency == this.urgency &&
          other.confidence == this.confidence &&
          other.explanationStyle == this.explanationStyle &&
          other.suggestedOrganizationName == this.suggestedOrganizationName &&
          other.suggestedDocumentType == this.suggestedDocumentType &&
          other.createdAt == this.createdAt);
}

class AnalysesCompanion extends UpdateCompanion<Analyse> {
  final Value<String> id;
  final Value<String> clientDocumentId;
  final Value<String> schemaVersion;
  final Value<String> targetLanguage;
  final Value<String?> summary;
  final Value<String?> explanation;
  final Value<String> state;
  final Value<String> analysisStatus;
  final Value<String?> actionRequired;
  final Value<String?> documentDate;
  final Value<String> detectedLanguage;
  final Value<String> urgency;
  final Value<double?> confidence;
  final Value<String> explanationStyle;
  final Value<String?> suggestedOrganizationName;
  final Value<String?> suggestedDocumentType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AnalysesCompanion({
    this.id = const Value.absent(),
    this.clientDocumentId = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.targetLanguage = const Value.absent(),
    this.summary = const Value.absent(),
    this.explanation = const Value.absent(),
    this.state = const Value.absent(),
    this.analysisStatus = const Value.absent(),
    this.actionRequired = const Value.absent(),
    this.documentDate = const Value.absent(),
    this.detectedLanguage = const Value.absent(),
    this.urgency = const Value.absent(),
    this.confidence = const Value.absent(),
    this.explanationStyle = const Value.absent(),
    this.suggestedOrganizationName = const Value.absent(),
    this.suggestedDocumentType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysesCompanion.insert({
    required String id,
    required String clientDocumentId,
    required String schemaVersion,
    required String targetLanguage,
    this.summary = const Value.absent(),
    this.explanation = const Value.absent(),
    required String state,
    this.analysisStatus = const Value.absent(),
    this.actionRequired = const Value.absent(),
    this.documentDate = const Value.absent(),
    this.detectedLanguage = const Value.absent(),
    this.urgency = const Value.absent(),
    this.confidence = const Value.absent(),
    this.explanationStyle = const Value.absent(),
    this.suggestedOrganizationName = const Value.absent(),
    this.suggestedDocumentType = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientDocumentId = Value(clientDocumentId),
       schemaVersion = Value(schemaVersion),
       targetLanguage = Value(targetLanguage),
       state = Value(state),
       createdAt = Value(createdAt);
  static Insertable<Analyse> custom({
    Expression<String>? id,
    Expression<String>? clientDocumentId,
    Expression<String>? schemaVersion,
    Expression<String>? targetLanguage,
    Expression<String>? summary,
    Expression<String>? explanation,
    Expression<String>? state,
    Expression<String>? analysisStatus,
    Expression<String>? actionRequired,
    Expression<String>? documentDate,
    Expression<String>? detectedLanguage,
    Expression<String>? urgency,
    Expression<double>? confidence,
    Expression<String>? explanationStyle,
    Expression<String>? suggestedOrganizationName,
    Expression<String>? suggestedDocumentType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientDocumentId != null) 'client_document_id': clientDocumentId,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (targetLanguage != null) 'target_language': targetLanguage,
      if (summary != null) 'summary': summary,
      if (explanation != null) 'explanation': explanation,
      if (state != null) 'state': state,
      if (analysisStatus != null) 'analysis_status': analysisStatus,
      if (actionRequired != null) 'action_required': actionRequired,
      if (documentDate != null) 'document_date': documentDate,
      if (detectedLanguage != null) 'detected_language': detectedLanguage,
      if (urgency != null) 'urgency': urgency,
      if (confidence != null) 'confidence': confidence,
      if (explanationStyle != null) 'explanation_style': explanationStyle,
      if (suggestedOrganizationName != null)
        'suggested_organization_name': suggestedOrganizationName,
      if (suggestedDocumentType != null)
        'suggested_document_type': suggestedDocumentType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysesCompanion copyWith({
    Value<String>? id,
    Value<String>? clientDocumentId,
    Value<String>? schemaVersion,
    Value<String>? targetLanguage,
    Value<String?>? summary,
    Value<String?>? explanation,
    Value<String>? state,
    Value<String>? analysisStatus,
    Value<String?>? actionRequired,
    Value<String?>? documentDate,
    Value<String>? detectedLanguage,
    Value<String>? urgency,
    Value<double?>? confidence,
    Value<String>? explanationStyle,
    Value<String?>? suggestedOrganizationName,
    Value<String?>? suggestedDocumentType,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AnalysesCompanion(
      id: id ?? this.id,
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      summary: summary ?? this.summary,
      explanation: explanation ?? this.explanation,
      state: state ?? this.state,
      analysisStatus: analysisStatus ?? this.analysisStatus,
      actionRequired: actionRequired ?? this.actionRequired,
      documentDate: documentDate ?? this.documentDate,
      detectedLanguage: detectedLanguage ?? this.detectedLanguage,
      urgency: urgency ?? this.urgency,
      confidence: confidence ?? this.confidence,
      explanationStyle: explanationStyle ?? this.explanationStyle,
      suggestedOrganizationName:
          suggestedOrganizationName ?? this.suggestedOrganizationName,
      suggestedDocumentType:
          suggestedDocumentType ?? this.suggestedDocumentType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientDocumentId.present) {
      map['client_document_id'] = Variable<String>(clientDocumentId.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<String>(schemaVersion.value);
    }
    if (targetLanguage.present) {
      map['target_language'] = Variable<String>(targetLanguage.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (analysisStatus.present) {
      map['analysis_status'] = Variable<String>(analysisStatus.value);
    }
    if (actionRequired.present) {
      map['action_required'] = Variable<String>(actionRequired.value);
    }
    if (documentDate.present) {
      map['document_date'] = Variable<String>(documentDate.value);
    }
    if (detectedLanguage.present) {
      map['detected_language'] = Variable<String>(detectedLanguage.value);
    }
    if (urgency.present) {
      map['urgency'] = Variable<String>(urgency.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (explanationStyle.present) {
      map['explanation_style'] = Variable<String>(explanationStyle.value);
    }
    if (suggestedOrganizationName.present) {
      map['suggested_organization_name'] = Variable<String>(
        suggestedOrganizationName.value,
      );
    }
    if (suggestedDocumentType.present) {
      map['suggested_document_type'] = Variable<String>(
        suggestedDocumentType.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysesCompanion(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('summary: $summary, ')
          ..write('explanation: $explanation, ')
          ..write('state: $state, ')
          ..write('analysisStatus: $analysisStatus, ')
          ..write('actionRequired: $actionRequired, ')
          ..write('documentDate: $documentDate, ')
          ..write('detectedLanguage: $detectedLanguage, ')
          ..write('urgency: $urgency, ')
          ..write('confidence: $confidence, ')
          ..write('explanationStyle: $explanationStyle, ')
          ..write('suggestedOrganizationName: $suggestedOrganizationName, ')
          ..write('suggestedDocumentType: $suggestedDocumentType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisQualityReasonsTable extends AnalysisQualityReasons
    with TableInfo<$AnalysisQualityReasonsTable, AnalysisQualityReason> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisQualityReasonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analyses (id)',
    ),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, analysisId, reason];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_quality_reasons';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisQualityReason> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisQualityReason map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisQualityReason(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
    );
  }

  @override
  $AnalysisQualityReasonsTable createAlias(String alias) {
    return $AnalysisQualityReasonsTable(attachedDatabase, alias);
  }
}

class AnalysisQualityReason extends DataClass
    implements Insertable<AnalysisQualityReason> {
  final String id;
  final String analysisId;
  final String reason;
  const AnalysisQualityReason({
    required this.id,
    required this.analysisId,
    required this.reason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['reason'] = Variable<String>(reason);
    return map;
  }

  AnalysisQualityReasonsCompanion toCompanion(bool nullToAbsent) {
    return AnalysisQualityReasonsCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      reason: Value(reason),
    );
  }

  factory AnalysisQualityReason.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisQualityReason(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      reason: serializer.fromJson<String>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'reason': serializer.toJson<String>(reason),
    };
  }

  AnalysisQualityReason copyWith({
    String? id,
    String? analysisId,
    String? reason,
  }) => AnalysisQualityReason(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    reason: reason ?? this.reason,
  );
  AnalysisQualityReason copyWithCompanion(
    AnalysisQualityReasonsCompanion data,
  ) {
    return AnalysisQualityReason(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisQualityReason(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, analysisId, reason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisQualityReason &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.reason == this.reason);
}

class AnalysisQualityReasonsCompanion
    extends UpdateCompanion<AnalysisQualityReason> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<String> reason;
  final Value<int> rowid;
  const AnalysisQualityReasonsCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.reason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisQualityReasonsCompanion.insert({
    required String id,
    required String analysisId,
    required String reason,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       reason = Value(reason);
  static Insertable<AnalysisQualityReason> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<String>? reason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (reason != null) 'reason': reason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisQualityReasonsCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<String>? reason,
    Value<int>? rowid,
  }) {
    return AnalysisQualityReasonsCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      reason: reason ?? this.reason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisQualityReasonsCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('reason: $reason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisNextActionsTable extends AnalysisNextActions
    with TableInfo<$AnalysisNextActionsTable, AnalysisNextAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisNextActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analyses (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, analysisId, position, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_next_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisNextAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisNextAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisNextAction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AnalysisNextActionsTable createAlias(String alias) {
    return $AnalysisNextActionsTable(attachedDatabase, alias);
  }
}

class AnalysisNextAction extends DataClass
    implements Insertable<AnalysisNextAction> {
  final String id;
  final String analysisId;
  final int position;
  final String value;
  const AnalysisNextAction({
    required this.id,
    required this.analysisId,
    required this.position,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['position'] = Variable<int>(position);
    map['value'] = Variable<String>(value);
    return map;
  }

  AnalysisNextActionsCompanion toCompanion(bool nullToAbsent) {
    return AnalysisNextActionsCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      position: Value(position),
      value: Value(value),
    );
  }

  factory AnalysisNextAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisNextAction(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      position: serializer.fromJson<int>(json['position']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'position': serializer.toJson<int>(position),
      'value': serializer.toJson<String>(value),
    };
  }

  AnalysisNextAction copyWith({
    String? id,
    String? analysisId,
    int? position,
    String? value,
  }) => AnalysisNextAction(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    position: position ?? this.position,
    value: value ?? this.value,
  );
  AnalysisNextAction copyWithCompanion(AnalysisNextActionsCompanion data) {
    return AnalysisNextAction(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      position: data.position.present ? data.position.value : this.position,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisNextAction(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, analysisId, position, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisNextAction &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.position == this.position &&
          other.value == this.value);
}

class AnalysisNextActionsCompanion extends UpdateCompanion<AnalysisNextAction> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<int> position;
  final Value<String> value;
  final Value<int> rowid;
  const AnalysisNextActionsCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.position = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisNextActionsCompanion.insert({
    required String id,
    required String analysisId,
    required int position,
    required String value,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       position = Value(position),
       value = Value(value);
  static Insertable<AnalysisNextAction> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<int>? position,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (position != null) 'position': position,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisNextActionsCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<int>? position,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AnalysisNextActionsCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      position: position ?? this.position,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisNextActionsCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisUncertaintiesTable extends AnalysisUncertainties
    with TableInfo<$AnalysisUncertaintiesTable, AnalysisUncertainty> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisUncertaintiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analyses (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, analysisId, position, message];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_uncertainties';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisUncertainty> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisUncertainty map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisUncertainty(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
    );
  }

  @override
  $AnalysisUncertaintiesTable createAlias(String alias) {
    return $AnalysisUncertaintiesTable(attachedDatabase, alias);
  }
}

class AnalysisUncertainty extends DataClass
    implements Insertable<AnalysisUncertainty> {
  final String id;
  final String analysisId;
  final int position;
  final String message;
  const AnalysisUncertainty({
    required this.id,
    required this.analysisId,
    required this.position,
    required this.message,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['position'] = Variable<int>(position);
    map['message'] = Variable<String>(message);
    return map;
  }

  AnalysisUncertaintiesCompanion toCompanion(bool nullToAbsent) {
    return AnalysisUncertaintiesCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      position: Value(position),
      message: Value(message),
    );
  }

  factory AnalysisUncertainty.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisUncertainty(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      position: serializer.fromJson<int>(json['position']),
      message: serializer.fromJson<String>(json['message']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'position': serializer.toJson<int>(position),
      'message': serializer.toJson<String>(message),
    };
  }

  AnalysisUncertainty copyWith({
    String? id,
    String? analysisId,
    int? position,
    String? message,
  }) => AnalysisUncertainty(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    position: position ?? this.position,
    message: message ?? this.message,
  );
  AnalysisUncertainty copyWithCompanion(AnalysisUncertaintiesCompanion data) {
    return AnalysisUncertainty(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      position: data.position.present ? data.position.value : this.position,
      message: data.message.present ? data.message.value : this.message,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisUncertainty(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('message: $message')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, analysisId, position, message);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisUncertainty &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.position == this.position &&
          other.message == this.message);
}

class AnalysisUncertaintiesCompanion
    extends UpdateCompanion<AnalysisUncertainty> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<int> position;
  final Value<String> message;
  final Value<int> rowid;
  const AnalysisUncertaintiesCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.position = const Value.absent(),
    this.message = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisUncertaintiesCompanion.insert({
    required String id,
    required String analysisId,
    required int position,
    required String message,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       position = Value(position),
       message = Value(message);
  static Insertable<AnalysisUncertainty> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<int>? position,
    Expression<String>? message,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (position != null) 'position': position,
      if (message != null) 'message': message,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisUncertaintiesCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<int>? position,
    Value<String>? message,
    Value<int>? rowid,
  }) {
    return AnalysisUncertaintiesCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      position: position ?? this.position,
      message: message ?? this.message,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisUncertaintiesCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('message: $message, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisPracticalStatesTable extends AnalysisPracticalStates
    with TableInfo<$AnalysisPracticalStatesTable, AnalysisPracticalState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisPracticalStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analyses (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, analysisId, position, state];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_practical_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisPracticalState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisPracticalState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisPracticalState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
    );
  }

  @override
  $AnalysisPracticalStatesTable createAlias(String alias) {
    return $AnalysisPracticalStatesTable(attachedDatabase, alias);
  }
}

class AnalysisPracticalState extends DataClass
    implements Insertable<AnalysisPracticalState> {
  final String id;
  final String analysisId;
  final int position;
  final String state;
  const AnalysisPracticalState({
    required this.id,
    required this.analysisId,
    required this.position,
    required this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['position'] = Variable<int>(position);
    map['state'] = Variable<String>(state);
    return map;
  }

  AnalysisPracticalStatesCompanion toCompanion(bool nullToAbsent) {
    return AnalysisPracticalStatesCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      position: Value(position),
      state: Value(state),
    );
  }

  factory AnalysisPracticalState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisPracticalState(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      position: serializer.fromJson<int>(json['position']),
      state: serializer.fromJson<String>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'position': serializer.toJson<int>(position),
      'state': serializer.toJson<String>(state),
    };
  }

  AnalysisPracticalState copyWith({
    String? id,
    String? analysisId,
    int? position,
    String? state,
  }) => AnalysisPracticalState(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    position: position ?? this.position,
    state: state ?? this.state,
  );
  AnalysisPracticalState copyWithCompanion(
    AnalysisPracticalStatesCompanion data,
  ) {
    return AnalysisPracticalState(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      position: data.position.present ? data.position.value : this.position,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisPracticalState(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, analysisId, position, state);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisPracticalState &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.position == this.position &&
          other.state == this.state);
}

class AnalysisPracticalStatesCompanion
    extends UpdateCompanion<AnalysisPracticalState> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<int> position;
  final Value<String> state;
  final Value<int> rowid;
  const AnalysisPracticalStatesCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.position = const Value.absent(),
    this.state = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisPracticalStatesCompanion.insert({
    required String id,
    required String analysisId,
    required int position,
    required String state,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       position = Value(position),
       state = Value(state);
  static Insertable<AnalysisPracticalState> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<int>? position,
    Expression<String>? state,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (position != null) 'position': position,
      if (state != null) 'state': state,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisPracticalStatesCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<int>? position,
    Value<String>? state,
    Value<int>? rowid,
  }) {
    return AnalysisPracticalStatesCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      position: position ?? this.position,
      state: state ?? this.state,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisPracticalStatesCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('state: $state, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisDeadlinesTable extends AnalysisDeadlines
    with TableInfo<$AnalysisDeadlinesTable, AnalysisDeadline> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisDeadlinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analyses (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOrRangeMeta = const VerificationMeta(
    'dateOrRange',
  );
  @override
  late final GeneratedColumn<String> dateOrRange = GeneratedColumn<String>(
    'date_or_range',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consequenceMeta = const VerificationMeta(
    'consequence',
  );
  @override
  late final GeneratedColumn<String> consequence = GeneratedColumn<String>(
    'consequence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceReferenceMeta = const VerificationMeta(
    'sourceReference',
  );
  @override
  late final GeneratedColumn<String> sourceReference = GeneratedColumn<String>(
    'source_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    analysisId,
    position,
    label,
    dateOrRange,
    confidence,
    time,
    timezone,
    consequence,
    sourceReference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_deadlines';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisDeadline> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('date_or_range')) {
      context.handle(
        _dateOrRangeMeta,
        dateOrRange.isAcceptableOrUnknown(
          data['date_or_range']!,
          _dateOrRangeMeta,
        ),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    if (data.containsKey('consequence')) {
      context.handle(
        _consequenceMeta,
        consequence.isAcceptableOrUnknown(
          data['consequence']!,
          _consequenceMeta,
        ),
      );
    }
    if (data.containsKey('source_reference')) {
      context.handle(
        _sourceReferenceMeta,
        sourceReference.isAcceptableOrUnknown(
          data['source_reference']!,
          _sourceReferenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisDeadline map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisDeadline(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      dateOrRange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_or_range'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      ),
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      ),
      consequence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}consequence'],
      ),
      sourceReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference'],
      ),
    );
  }

  @override
  $AnalysisDeadlinesTable createAlias(String alias) {
    return $AnalysisDeadlinesTable(attachedDatabase, alias);
  }
}

class AnalysisDeadline extends DataClass
    implements Insertable<AnalysisDeadline> {
  final String id;
  final String analysisId;
  final int position;
  final String label;
  final String? dateOrRange;
  final double? confidence;
  final String? time;
  final String? timezone;
  final String? consequence;
  final String? sourceReference;
  const AnalysisDeadline({
    required this.id,
    required this.analysisId,
    required this.position,
    required this.label,
    this.dateOrRange,
    this.confidence,
    this.time,
    this.timezone,
    this.consequence,
    this.sourceReference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['position'] = Variable<int>(position);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || dateOrRange != null) {
      map['date_or_range'] = Variable<String>(dateOrRange);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<String>(time);
    }
    if (!nullToAbsent || timezone != null) {
      map['timezone'] = Variable<String>(timezone);
    }
    if (!nullToAbsent || consequence != null) {
      map['consequence'] = Variable<String>(consequence);
    }
    if (!nullToAbsent || sourceReference != null) {
      map['source_reference'] = Variable<String>(sourceReference);
    }
    return map;
  }

  AnalysisDeadlinesCompanion toCompanion(bool nullToAbsent) {
    return AnalysisDeadlinesCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      position: Value(position),
      label: Value(label),
      dateOrRange: dateOrRange == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOrRange),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      timezone: timezone == null && nullToAbsent
          ? const Value.absent()
          : Value(timezone),
      consequence: consequence == null && nullToAbsent
          ? const Value.absent()
          : Value(consequence),
      sourceReference: sourceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReference),
    );
  }

  factory AnalysisDeadline.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisDeadline(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      position: serializer.fromJson<int>(json['position']),
      label: serializer.fromJson<String>(json['label']),
      dateOrRange: serializer.fromJson<String?>(json['dateOrRange']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      time: serializer.fromJson<String?>(json['time']),
      timezone: serializer.fromJson<String?>(json['timezone']),
      consequence: serializer.fromJson<String?>(json['consequence']),
      sourceReference: serializer.fromJson<String?>(json['sourceReference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'position': serializer.toJson<int>(position),
      'label': serializer.toJson<String>(label),
      'dateOrRange': serializer.toJson<String?>(dateOrRange),
      'confidence': serializer.toJson<double?>(confidence),
      'time': serializer.toJson<String?>(time),
      'timezone': serializer.toJson<String?>(timezone),
      'consequence': serializer.toJson<String?>(consequence),
      'sourceReference': serializer.toJson<String?>(sourceReference),
    };
  }

  AnalysisDeadline copyWith({
    String? id,
    String? analysisId,
    int? position,
    String? label,
    Value<String?> dateOrRange = const Value.absent(),
    Value<double?> confidence = const Value.absent(),
    Value<String?> time = const Value.absent(),
    Value<String?> timezone = const Value.absent(),
    Value<String?> consequence = const Value.absent(),
    Value<String?> sourceReference = const Value.absent(),
  }) => AnalysisDeadline(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    position: position ?? this.position,
    label: label ?? this.label,
    dateOrRange: dateOrRange.present ? dateOrRange.value : this.dateOrRange,
    confidence: confidence.present ? confidence.value : this.confidence,
    time: time.present ? time.value : this.time,
    timezone: timezone.present ? timezone.value : this.timezone,
    consequence: consequence.present ? consequence.value : this.consequence,
    sourceReference: sourceReference.present
        ? sourceReference.value
        : this.sourceReference,
  );
  AnalysisDeadline copyWithCompanion(AnalysisDeadlinesCompanion data) {
    return AnalysisDeadline(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      position: data.position.present ? data.position.value : this.position,
      label: data.label.present ? data.label.value : this.label,
      dateOrRange: data.dateOrRange.present
          ? data.dateOrRange.value
          : this.dateOrRange,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      time: data.time.present ? data.time.value : this.time,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      consequence: data.consequence.present
          ? data.consequence.value
          : this.consequence,
      sourceReference: data.sourceReference.present
          ? data.sourceReference.value
          : this.sourceReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisDeadline(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('label: $label, ')
          ..write('dateOrRange: $dateOrRange, ')
          ..write('confidence: $confidence, ')
          ..write('time: $time, ')
          ..write('timezone: $timezone, ')
          ..write('consequence: $consequence, ')
          ..write('sourceReference: $sourceReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    analysisId,
    position,
    label,
    dateOrRange,
    confidence,
    time,
    timezone,
    consequence,
    sourceReference,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisDeadline &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.position == this.position &&
          other.label == this.label &&
          other.dateOrRange == this.dateOrRange &&
          other.confidence == this.confidence &&
          other.time == this.time &&
          other.timezone == this.timezone &&
          other.consequence == this.consequence &&
          other.sourceReference == this.sourceReference);
}

class AnalysisDeadlinesCompanion extends UpdateCompanion<AnalysisDeadline> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<int> position;
  final Value<String> label;
  final Value<String?> dateOrRange;
  final Value<double?> confidence;
  final Value<String?> time;
  final Value<String?> timezone;
  final Value<String?> consequence;
  final Value<String?> sourceReference;
  final Value<int> rowid;
  const AnalysisDeadlinesCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.position = const Value.absent(),
    this.label = const Value.absent(),
    this.dateOrRange = const Value.absent(),
    this.confidence = const Value.absent(),
    this.time = const Value.absent(),
    this.timezone = const Value.absent(),
    this.consequence = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisDeadlinesCompanion.insert({
    required String id,
    required String analysisId,
    required int position,
    required String label,
    this.dateOrRange = const Value.absent(),
    this.confidence = const Value.absent(),
    this.time = const Value.absent(),
    this.timezone = const Value.absent(),
    this.consequence = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       position = Value(position),
       label = Value(label);
  static Insertable<AnalysisDeadline> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<int>? position,
    Expression<String>? label,
    Expression<String>? dateOrRange,
    Expression<double>? confidence,
    Expression<String>? time,
    Expression<String>? timezone,
    Expression<String>? consequence,
    Expression<String>? sourceReference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (position != null) 'position': position,
      if (label != null) 'label': label,
      if (dateOrRange != null) 'date_or_range': dateOrRange,
      if (confidence != null) 'confidence': confidence,
      if (time != null) 'time': time,
      if (timezone != null) 'timezone': timezone,
      if (consequence != null) 'consequence': consequence,
      if (sourceReference != null) 'source_reference': sourceReference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisDeadlinesCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<int>? position,
    Value<String>? label,
    Value<String?>? dateOrRange,
    Value<double?>? confidence,
    Value<String?>? time,
    Value<String?>? timezone,
    Value<String?>? consequence,
    Value<String?>? sourceReference,
    Value<int>? rowid,
  }) {
    return AnalysisDeadlinesCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      position: position ?? this.position,
      label: label ?? this.label,
      dateOrRange: dateOrRange ?? this.dateOrRange,
      confidence: confidence ?? this.confidence,
      time: time ?? this.time,
      timezone: timezone ?? this.timezone,
      consequence: consequence ?? this.consequence,
      sourceReference: sourceReference ?? this.sourceReference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (dateOrRange.present) {
      map['date_or_range'] = Variable<String>(dateOrRange.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (consequence.present) {
      map['consequence'] = Variable<String>(consequence.value);
    }
    if (sourceReference.present) {
      map['source_reference'] = Variable<String>(sourceReference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisDeadlinesCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('label: $label, ')
          ..write('dateOrRange: $dateOrRange, ')
          ..write('confidence: $confidence, ')
          ..write('time: $time, ')
          ..write('timezone: $timezone, ')
          ..write('consequence: $consequence, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisAppointmentsTable extends AnalysisAppointments
    with TableInfo<$AnalysisAppointmentsTable, AnalysisAppointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisAppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analyses (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startOrDateMeta = const VerificationMeta(
    'startOrDate',
  );
  @override
  late final GeneratedColumn<String> startOrDate = GeneratedColumn<String>(
    'start_or_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<String> end = GeneratedColumn<String>(
    'end',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preparationMeta = const VerificationMeta(
    'preparation',
  );
  @override
  late final GeneratedColumn<String> preparation = GeneratedColumn<String>(
    'preparation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceReferenceMeta = const VerificationMeta(
    'sourceReference',
  );
  @override
  late final GeneratedColumn<String> sourceReference = GeneratedColumn<String>(
    'source_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    analysisId,
    position,
    label,
    startOrDate,
    confidence,
    end,
    location,
    preparation,
    sourceReference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_appointments';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisAppointment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('start_or_date')) {
      context.handle(
        _startOrDateMeta,
        startOrDate.isAcceptableOrUnknown(
          data['start_or_date']!,
          _startOrDateMeta,
        ),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('preparation')) {
      context.handle(
        _preparationMeta,
        preparation.isAcceptableOrUnknown(
          data['preparation']!,
          _preparationMeta,
        ),
      );
    }
    if (data.containsKey('source_reference')) {
      context.handle(
        _sourceReferenceMeta,
        sourceReference.isAcceptableOrUnknown(
          data['source_reference']!,
          _sourceReferenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisAppointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisAppointment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      startOrDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_or_date'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      preparation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preparation'],
      ),
      sourceReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference'],
      ),
    );
  }

  @override
  $AnalysisAppointmentsTable createAlias(String alias) {
    return $AnalysisAppointmentsTable(attachedDatabase, alias);
  }
}

class AnalysisAppointment extends DataClass
    implements Insertable<AnalysisAppointment> {
  final String id;
  final String analysisId;
  final int position;
  final String label;
  final String? startOrDate;
  final double? confidence;
  final String? end;
  final String? location;
  final String? preparation;
  final String? sourceReference;
  const AnalysisAppointment({
    required this.id,
    required this.analysisId,
    required this.position,
    required this.label,
    this.startOrDate,
    this.confidence,
    this.end,
    this.location,
    this.preparation,
    this.sourceReference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['position'] = Variable<int>(position);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || startOrDate != null) {
      map['start_or_date'] = Variable<String>(startOrDate);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<String>(end);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || preparation != null) {
      map['preparation'] = Variable<String>(preparation);
    }
    if (!nullToAbsent || sourceReference != null) {
      map['source_reference'] = Variable<String>(sourceReference);
    }
    return map;
  }

  AnalysisAppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AnalysisAppointmentsCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      position: Value(position),
      label: Value(label),
      startOrDate: startOrDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startOrDate),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      preparation: preparation == null && nullToAbsent
          ? const Value.absent()
          : Value(preparation),
      sourceReference: sourceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReference),
    );
  }

  factory AnalysisAppointment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisAppointment(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      position: serializer.fromJson<int>(json['position']),
      label: serializer.fromJson<String>(json['label']),
      startOrDate: serializer.fromJson<String?>(json['startOrDate']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      end: serializer.fromJson<String?>(json['end']),
      location: serializer.fromJson<String?>(json['location']),
      preparation: serializer.fromJson<String?>(json['preparation']),
      sourceReference: serializer.fromJson<String?>(json['sourceReference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'position': serializer.toJson<int>(position),
      'label': serializer.toJson<String>(label),
      'startOrDate': serializer.toJson<String?>(startOrDate),
      'confidence': serializer.toJson<double?>(confidence),
      'end': serializer.toJson<String?>(end),
      'location': serializer.toJson<String?>(location),
      'preparation': serializer.toJson<String?>(preparation),
      'sourceReference': serializer.toJson<String?>(sourceReference),
    };
  }

  AnalysisAppointment copyWith({
    String? id,
    String? analysisId,
    int? position,
    String? label,
    Value<String?> startOrDate = const Value.absent(),
    Value<double?> confidence = const Value.absent(),
    Value<String?> end = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> preparation = const Value.absent(),
    Value<String?> sourceReference = const Value.absent(),
  }) => AnalysisAppointment(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    position: position ?? this.position,
    label: label ?? this.label,
    startOrDate: startOrDate.present ? startOrDate.value : this.startOrDate,
    confidence: confidence.present ? confidence.value : this.confidence,
    end: end.present ? end.value : this.end,
    location: location.present ? location.value : this.location,
    preparation: preparation.present ? preparation.value : this.preparation,
    sourceReference: sourceReference.present
        ? sourceReference.value
        : this.sourceReference,
  );
  AnalysisAppointment copyWithCompanion(AnalysisAppointmentsCompanion data) {
    return AnalysisAppointment(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      position: data.position.present ? data.position.value : this.position,
      label: data.label.present ? data.label.value : this.label,
      startOrDate: data.startOrDate.present
          ? data.startOrDate.value
          : this.startOrDate,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      end: data.end.present ? data.end.value : this.end,
      location: data.location.present ? data.location.value : this.location,
      preparation: data.preparation.present
          ? data.preparation.value
          : this.preparation,
      sourceReference: data.sourceReference.present
          ? data.sourceReference.value
          : this.sourceReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisAppointment(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('label: $label, ')
          ..write('startOrDate: $startOrDate, ')
          ..write('confidence: $confidence, ')
          ..write('end: $end, ')
          ..write('location: $location, ')
          ..write('preparation: $preparation, ')
          ..write('sourceReference: $sourceReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    analysisId,
    position,
    label,
    startOrDate,
    confidence,
    end,
    location,
    preparation,
    sourceReference,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisAppointment &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.position == this.position &&
          other.label == this.label &&
          other.startOrDate == this.startOrDate &&
          other.confidence == this.confidence &&
          other.end == this.end &&
          other.location == this.location &&
          other.preparation == this.preparation &&
          other.sourceReference == this.sourceReference);
}

class AnalysisAppointmentsCompanion
    extends UpdateCompanion<AnalysisAppointment> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<int> position;
  final Value<String> label;
  final Value<String?> startOrDate;
  final Value<double?> confidence;
  final Value<String?> end;
  final Value<String?> location;
  final Value<String?> preparation;
  final Value<String?> sourceReference;
  final Value<int> rowid;
  const AnalysisAppointmentsCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.position = const Value.absent(),
    this.label = const Value.absent(),
    this.startOrDate = const Value.absent(),
    this.confidence = const Value.absent(),
    this.end = const Value.absent(),
    this.location = const Value.absent(),
    this.preparation = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisAppointmentsCompanion.insert({
    required String id,
    required String analysisId,
    required int position,
    required String label,
    this.startOrDate = const Value.absent(),
    this.confidence = const Value.absent(),
    this.end = const Value.absent(),
    this.location = const Value.absent(),
    this.preparation = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       position = Value(position),
       label = Value(label);
  static Insertable<AnalysisAppointment> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<int>? position,
    Expression<String>? label,
    Expression<String>? startOrDate,
    Expression<double>? confidence,
    Expression<String>? end,
    Expression<String>? location,
    Expression<String>? preparation,
    Expression<String>? sourceReference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (position != null) 'position': position,
      if (label != null) 'label': label,
      if (startOrDate != null) 'start_or_date': startOrDate,
      if (confidence != null) 'confidence': confidence,
      if (end != null) 'end': end,
      if (location != null) 'location': location,
      if (preparation != null) 'preparation': preparation,
      if (sourceReference != null) 'source_reference': sourceReference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisAppointmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<int>? position,
    Value<String>? label,
    Value<String?>? startOrDate,
    Value<double?>? confidence,
    Value<String?>? end,
    Value<String?>? location,
    Value<String?>? preparation,
    Value<String?>? sourceReference,
    Value<int>? rowid,
  }) {
    return AnalysisAppointmentsCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      position: position ?? this.position,
      label: label ?? this.label,
      startOrDate: startOrDate ?? this.startOrDate,
      confidence: confidence ?? this.confidence,
      end: end ?? this.end,
      location: location ?? this.location,
      preparation: preparation ?? this.preparation,
      sourceReference: sourceReference ?? this.sourceReference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (startOrDate.present) {
      map['start_or_date'] = Variable<String>(startOrDate.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (end.present) {
      map['end'] = Variable<String>(end.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (preparation.present) {
      map['preparation'] = Variable<String>(preparation.value);
    }
    if (sourceReference.present) {
      map['source_reference'] = Variable<String>(sourceReference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisAppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('label: $label, ')
          ..write('startOrDate: $startOrDate, ')
          ..write('confidence: $confidence, ')
          ..write('end: $end, ')
          ..write('location: $location, ')
          ..write('preparation: $preparation, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisAmountsTable extends AnalysisAmounts
    with TableInfo<$AnalysisAmountsTable, AnalysisAmount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisAmountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analyses (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceReferenceMeta = const VerificationMeta(
    'sourceReference',
  );
  @override
  late final GeneratedColumn<String> sourceReference = GeneratedColumn<String>(
    'source_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    analysisId,
    position,
    value,
    currency,
    direction,
    confidence,
    dueDate,
    purpose,
    sourceReference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_amounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisAmount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('source_reference')) {
      context.handle(
        _sourceReferenceMeta,
        sourceReference.isAcceptableOrUnknown(
          data['source_reference']!,
          _sourceReferenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisAmount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisAmount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      ),
      sourceReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference'],
      ),
    );
  }

  @override
  $AnalysisAmountsTable createAlias(String alias) {
    return $AnalysisAmountsTable(attachedDatabase, alias);
  }
}

class AnalysisAmount extends DataClass implements Insertable<AnalysisAmount> {
  final String id;
  final String analysisId;
  final int position;
  final String value;
  final String currency;
  final String direction;
  final double? confidence;
  final String? dueDate;
  final String? purpose;
  final String? sourceReference;
  const AnalysisAmount({
    required this.id,
    required this.analysisId,
    required this.position,
    required this.value,
    required this.currency,
    required this.direction,
    this.confidence,
    this.dueDate,
    this.purpose,
    this.sourceReference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['position'] = Variable<int>(position);
    map['value'] = Variable<String>(value);
    map['currency'] = Variable<String>(currency);
    map['direction'] = Variable<String>(direction);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || purpose != null) {
      map['purpose'] = Variable<String>(purpose);
    }
    if (!nullToAbsent || sourceReference != null) {
      map['source_reference'] = Variable<String>(sourceReference);
    }
    return map;
  }

  AnalysisAmountsCompanion toCompanion(bool nullToAbsent) {
    return AnalysisAmountsCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      position: Value(position),
      value: Value(value),
      currency: Value(currency),
      direction: Value(direction),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      purpose: purpose == null && nullToAbsent
          ? const Value.absent()
          : Value(purpose),
      sourceReference: sourceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReference),
    );
  }

  factory AnalysisAmount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisAmount(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      position: serializer.fromJson<int>(json['position']),
      value: serializer.fromJson<String>(json['value']),
      currency: serializer.fromJson<String>(json['currency']),
      direction: serializer.fromJson<String>(json['direction']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      purpose: serializer.fromJson<String?>(json['purpose']),
      sourceReference: serializer.fromJson<String?>(json['sourceReference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'position': serializer.toJson<int>(position),
      'value': serializer.toJson<String>(value),
      'currency': serializer.toJson<String>(currency),
      'direction': serializer.toJson<String>(direction),
      'confidence': serializer.toJson<double?>(confidence),
      'dueDate': serializer.toJson<String?>(dueDate),
      'purpose': serializer.toJson<String?>(purpose),
      'sourceReference': serializer.toJson<String?>(sourceReference),
    };
  }

  AnalysisAmount copyWith({
    String? id,
    String? analysisId,
    int? position,
    String? value,
    String? currency,
    String? direction,
    Value<double?> confidence = const Value.absent(),
    Value<String?> dueDate = const Value.absent(),
    Value<String?> purpose = const Value.absent(),
    Value<String?> sourceReference = const Value.absent(),
  }) => AnalysisAmount(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    position: position ?? this.position,
    value: value ?? this.value,
    currency: currency ?? this.currency,
    direction: direction ?? this.direction,
    confidence: confidence.present ? confidence.value : this.confidence,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    purpose: purpose.present ? purpose.value : this.purpose,
    sourceReference: sourceReference.present
        ? sourceReference.value
        : this.sourceReference,
  );
  AnalysisAmount copyWithCompanion(AnalysisAmountsCompanion data) {
    return AnalysisAmount(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      position: data.position.present ? data.position.value : this.position,
      value: data.value.present ? data.value.value : this.value,
      currency: data.currency.present ? data.currency.value : this.currency,
      direction: data.direction.present ? data.direction.value : this.direction,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      sourceReference: data.sourceReference.present
          ? data.sourceReference.value
          : this.sourceReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisAmount(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('value: $value, ')
          ..write('currency: $currency, ')
          ..write('direction: $direction, ')
          ..write('confidence: $confidence, ')
          ..write('dueDate: $dueDate, ')
          ..write('purpose: $purpose, ')
          ..write('sourceReference: $sourceReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    analysisId,
    position,
    value,
    currency,
    direction,
    confidence,
    dueDate,
    purpose,
    sourceReference,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisAmount &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.position == this.position &&
          other.value == this.value &&
          other.currency == this.currency &&
          other.direction == this.direction &&
          other.confidence == this.confidence &&
          other.dueDate == this.dueDate &&
          other.purpose == this.purpose &&
          other.sourceReference == this.sourceReference);
}

class AnalysisAmountsCompanion extends UpdateCompanion<AnalysisAmount> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<int> position;
  final Value<String> value;
  final Value<String> currency;
  final Value<String> direction;
  final Value<double?> confidence;
  final Value<String?> dueDate;
  final Value<String?> purpose;
  final Value<String?> sourceReference;
  final Value<int> rowid;
  const AnalysisAmountsCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.position = const Value.absent(),
    this.value = const Value.absent(),
    this.currency = const Value.absent(),
    this.direction = const Value.absent(),
    this.confidence = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.purpose = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisAmountsCompanion.insert({
    required String id,
    required String analysisId,
    required int position,
    required String value,
    required String currency,
    required String direction,
    this.confidence = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.purpose = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       position = Value(position),
       value = Value(value),
       currency = Value(currency),
       direction = Value(direction);
  static Insertable<AnalysisAmount> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<int>? position,
    Expression<String>? value,
    Expression<String>? currency,
    Expression<String>? direction,
    Expression<double>? confidence,
    Expression<String>? dueDate,
    Expression<String>? purpose,
    Expression<String>? sourceReference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (position != null) 'position': position,
      if (value != null) 'value': value,
      if (currency != null) 'currency': currency,
      if (direction != null) 'direction': direction,
      if (confidence != null) 'confidence': confidence,
      if (dueDate != null) 'due_date': dueDate,
      if (purpose != null) 'purpose': purpose,
      if (sourceReference != null) 'source_reference': sourceReference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisAmountsCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<int>? position,
    Value<String>? value,
    Value<String>? currency,
    Value<String>? direction,
    Value<double?>? confidence,
    Value<String?>? dueDate,
    Value<String?>? purpose,
    Value<String?>? sourceReference,
    Value<int>? rowid,
  }) {
    return AnalysisAmountsCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      position: position ?? this.position,
      value: value ?? this.value,
      currency: currency ?? this.currency,
      direction: direction ?? this.direction,
      confidence: confidence ?? this.confidence,
      dueDate: dueDate ?? this.dueDate,
      purpose: purpose ?? this.purpose,
      sourceReference: sourceReference ?? this.sourceReference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (sourceReference.present) {
      map['source_reference'] = Variable<String>(sourceReference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisAmountsCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('value: $value, ')
          ..write('currency: $currency, ')
          ..write('direction: $direction, ')
          ..write('confidence: $confidence, ')
          ..write('dueDate: $dueDate, ')
          ..write('purpose: $purpose, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisRequiredDocumentsTable extends AnalysisRequiredDocuments
    with TableInfo<$AnalysisRequiredDocumentsTable, AnalysisRequiredDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisRequiredDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analyses (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _submissionMethodMeta = const VerificationMeta(
    'submissionMethod',
  );
  @override
  late final GeneratedColumn<String> submissionMethod = GeneratedColumn<String>(
    'submission_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceReferenceMeta = const VerificationMeta(
    'sourceReference',
  );
  @override
  late final GeneratedColumn<String> sourceReference = GeneratedColumn<String>(
    'source_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    analysisId,
    position,
    description,
    confidence,
    dueDate,
    submissionMethod,
    sourceReference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_required_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisRequiredDocument> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('submission_method')) {
      context.handle(
        _submissionMethodMeta,
        submissionMethod.isAcceptableOrUnknown(
          data['submission_method']!,
          _submissionMethodMeta,
        ),
      );
    }
    if (data.containsKey('source_reference')) {
      context.handle(
        _sourceReferenceMeta,
        sourceReference.isAcceptableOrUnknown(
          data['source_reference']!,
          _sourceReferenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisRequiredDocument map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisRequiredDocument(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      submissionMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}submission_method'],
      ),
      sourceReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference'],
      ),
    );
  }

  @override
  $AnalysisRequiredDocumentsTable createAlias(String alias) {
    return $AnalysisRequiredDocumentsTable(attachedDatabase, alias);
  }
}

class AnalysisRequiredDocument extends DataClass
    implements Insertable<AnalysisRequiredDocument> {
  final String id;
  final String analysisId;
  final int position;
  final String description;
  final double? confidence;
  final String? dueDate;
  final String? submissionMethod;
  final String? sourceReference;
  const AnalysisRequiredDocument({
    required this.id,
    required this.analysisId,
    required this.position,
    required this.description,
    this.confidence,
    this.dueDate,
    this.submissionMethod,
    this.sourceReference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['position'] = Variable<int>(position);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || submissionMethod != null) {
      map['submission_method'] = Variable<String>(submissionMethod);
    }
    if (!nullToAbsent || sourceReference != null) {
      map['source_reference'] = Variable<String>(sourceReference);
    }
    return map;
  }

  AnalysisRequiredDocumentsCompanion toCompanion(bool nullToAbsent) {
    return AnalysisRequiredDocumentsCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      position: Value(position),
      description: Value(description),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      submissionMethod: submissionMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(submissionMethod),
      sourceReference: sourceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReference),
    );
  }

  factory AnalysisRequiredDocument.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisRequiredDocument(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      position: serializer.fromJson<int>(json['position']),
      description: serializer.fromJson<String>(json['description']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      submissionMethod: serializer.fromJson<String?>(json['submissionMethod']),
      sourceReference: serializer.fromJson<String?>(json['sourceReference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'position': serializer.toJson<int>(position),
      'description': serializer.toJson<String>(description),
      'confidence': serializer.toJson<double?>(confidence),
      'dueDate': serializer.toJson<String?>(dueDate),
      'submissionMethod': serializer.toJson<String?>(submissionMethod),
      'sourceReference': serializer.toJson<String?>(sourceReference),
    };
  }

  AnalysisRequiredDocument copyWith({
    String? id,
    String? analysisId,
    int? position,
    String? description,
    Value<double?> confidence = const Value.absent(),
    Value<String?> dueDate = const Value.absent(),
    Value<String?> submissionMethod = const Value.absent(),
    Value<String?> sourceReference = const Value.absent(),
  }) => AnalysisRequiredDocument(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    position: position ?? this.position,
    description: description ?? this.description,
    confidence: confidence.present ? confidence.value : this.confidence,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    submissionMethod: submissionMethod.present
        ? submissionMethod.value
        : this.submissionMethod,
    sourceReference: sourceReference.present
        ? sourceReference.value
        : this.sourceReference,
  );
  AnalysisRequiredDocument copyWithCompanion(
    AnalysisRequiredDocumentsCompanion data,
  ) {
    return AnalysisRequiredDocument(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      position: data.position.present ? data.position.value : this.position,
      description: data.description.present
          ? data.description.value
          : this.description,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      submissionMethod: data.submissionMethod.present
          ? data.submissionMethod.value
          : this.submissionMethod,
      sourceReference: data.sourceReference.present
          ? data.sourceReference.value
          : this.sourceReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisRequiredDocument(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('description: $description, ')
          ..write('confidence: $confidence, ')
          ..write('dueDate: $dueDate, ')
          ..write('submissionMethod: $submissionMethod, ')
          ..write('sourceReference: $sourceReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    analysisId,
    position,
    description,
    confidence,
    dueDate,
    submissionMethod,
    sourceReference,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisRequiredDocument &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.position == this.position &&
          other.description == this.description &&
          other.confidence == this.confidence &&
          other.dueDate == this.dueDate &&
          other.submissionMethod == this.submissionMethod &&
          other.sourceReference == this.sourceReference);
}

class AnalysisRequiredDocumentsCompanion
    extends UpdateCompanion<AnalysisRequiredDocument> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<int> position;
  final Value<String> description;
  final Value<double?> confidence;
  final Value<String?> dueDate;
  final Value<String?> submissionMethod;
  final Value<String?> sourceReference;
  final Value<int> rowid;
  const AnalysisRequiredDocumentsCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.position = const Value.absent(),
    this.description = const Value.absent(),
    this.confidence = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.submissionMethod = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisRequiredDocumentsCompanion.insert({
    required String id,
    required String analysisId,
    required int position,
    required String description,
    this.confidence = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.submissionMethod = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       position = Value(position),
       description = Value(description);
  static Insertable<AnalysisRequiredDocument> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<int>? position,
    Expression<String>? description,
    Expression<double>? confidence,
    Expression<String>? dueDate,
    Expression<String>? submissionMethod,
    Expression<String>? sourceReference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (position != null) 'position': position,
      if (description != null) 'description': description,
      if (confidence != null) 'confidence': confidence,
      if (dueDate != null) 'due_date': dueDate,
      if (submissionMethod != null) 'submission_method': submissionMethod,
      if (sourceReference != null) 'source_reference': sourceReference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisRequiredDocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<int>? position,
    Value<String>? description,
    Value<double?>? confidence,
    Value<String?>? dueDate,
    Value<String?>? submissionMethod,
    Value<String?>? sourceReference,
    Value<int>? rowid,
  }) {
    return AnalysisRequiredDocumentsCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      position: position ?? this.position,
      description: description ?? this.description,
      confidence: confidence ?? this.confidence,
      dueDate: dueDate ?? this.dueDate,
      submissionMethod: submissionMethod ?? this.submissionMethod,
      sourceReference: sourceReference ?? this.sourceReference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (submissionMethod.present) {
      map['submission_method'] = Variable<String>(submissionMethod.value);
    }
    if (sourceReference.present) {
      map['source_reference'] = Variable<String>(sourceReference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisRequiredDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('description: $description, ')
          ..write('confidence: $confidence, ')
          ..write('dueDate: $dueDate, ')
          ..write('submissionMethod: $submissionMethod, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisSuggestedTasksTable extends AnalysisSuggestedTasks
    with TableInfo<$AnalysisSuggestedTasksTable, AnalysisSuggestedTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisSuggestedTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analyses (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceReferenceMeta = const VerificationMeta(
    'sourceReference',
  );
  @override
  late final GeneratedColumn<String> sourceReference = GeneratedColumn<String>(
    'source_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    analysisId,
    position,
    title,
    confidence,
    dueDate,
    instructions,
    sourceReference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_suggested_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisSuggestedTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('source_reference')) {
      context.handle(
        _sourceReferenceMeta,
        sourceReference.isAcceptableOrUnknown(
          data['source_reference']!,
          _sourceReferenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisSuggestedTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisSuggestedTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      sourceReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference'],
      ),
    );
  }

  @override
  $AnalysisSuggestedTasksTable createAlias(String alias) {
    return $AnalysisSuggestedTasksTable(attachedDatabase, alias);
  }
}

class AnalysisSuggestedTask extends DataClass
    implements Insertable<AnalysisSuggestedTask> {
  final String id;
  final String analysisId;
  final int position;
  final String title;
  final double? confidence;
  final String? dueDate;
  final String? instructions;
  final String? sourceReference;
  const AnalysisSuggestedTask({
    required this.id,
    required this.analysisId,
    required this.position,
    required this.title,
    this.confidence,
    this.dueDate,
    this.instructions,
    this.sourceReference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['position'] = Variable<int>(position);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    if (!nullToAbsent || sourceReference != null) {
      map['source_reference'] = Variable<String>(sourceReference);
    }
    return map;
  }

  AnalysisSuggestedTasksCompanion toCompanion(bool nullToAbsent) {
    return AnalysisSuggestedTasksCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      position: Value(position),
      title: Value(title),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      sourceReference: sourceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReference),
    );
  }

  factory AnalysisSuggestedTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisSuggestedTask(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      position: serializer.fromJson<int>(json['position']),
      title: serializer.fromJson<String>(json['title']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      sourceReference: serializer.fromJson<String?>(json['sourceReference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'position': serializer.toJson<int>(position),
      'title': serializer.toJson<String>(title),
      'confidence': serializer.toJson<double?>(confidence),
      'dueDate': serializer.toJson<String?>(dueDate),
      'instructions': serializer.toJson<String?>(instructions),
      'sourceReference': serializer.toJson<String?>(sourceReference),
    };
  }

  AnalysisSuggestedTask copyWith({
    String? id,
    String? analysisId,
    int? position,
    String? title,
    Value<double?> confidence = const Value.absent(),
    Value<String?> dueDate = const Value.absent(),
    Value<String?> instructions = const Value.absent(),
    Value<String?> sourceReference = const Value.absent(),
  }) => AnalysisSuggestedTask(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    position: position ?? this.position,
    title: title ?? this.title,
    confidence: confidence.present ? confidence.value : this.confidence,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    instructions: instructions.present ? instructions.value : this.instructions,
    sourceReference: sourceReference.present
        ? sourceReference.value
        : this.sourceReference,
  );
  AnalysisSuggestedTask copyWithCompanion(
    AnalysisSuggestedTasksCompanion data,
  ) {
    return AnalysisSuggestedTask(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      position: data.position.present ? data.position.value : this.position,
      title: data.title.present ? data.title.value : this.title,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      sourceReference: data.sourceReference.present
          ? data.sourceReference.value
          : this.sourceReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisSuggestedTask(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('confidence: $confidence, ')
          ..write('dueDate: $dueDate, ')
          ..write('instructions: $instructions, ')
          ..write('sourceReference: $sourceReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    analysisId,
    position,
    title,
    confidence,
    dueDate,
    instructions,
    sourceReference,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisSuggestedTask &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.position == this.position &&
          other.title == this.title &&
          other.confidence == this.confidence &&
          other.dueDate == this.dueDate &&
          other.instructions == this.instructions &&
          other.sourceReference == this.sourceReference);
}

class AnalysisSuggestedTasksCompanion
    extends UpdateCompanion<AnalysisSuggestedTask> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<int> position;
  final Value<String> title;
  final Value<double?> confidence;
  final Value<String?> dueDate;
  final Value<String?> instructions;
  final Value<String?> sourceReference;
  final Value<int> rowid;
  const AnalysisSuggestedTasksCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.position = const Value.absent(),
    this.title = const Value.absent(),
    this.confidence = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.instructions = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisSuggestedTasksCompanion.insert({
    required String id,
    required String analysisId,
    required int position,
    required String title,
    this.confidence = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.instructions = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       position = Value(position),
       title = Value(title);
  static Insertable<AnalysisSuggestedTask> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<int>? position,
    Expression<String>? title,
    Expression<double>? confidence,
    Expression<String>? dueDate,
    Expression<String>? instructions,
    Expression<String>? sourceReference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (position != null) 'position': position,
      if (title != null) 'title': title,
      if (confidence != null) 'confidence': confidence,
      if (dueDate != null) 'due_date': dueDate,
      if (instructions != null) 'instructions': instructions,
      if (sourceReference != null) 'source_reference': sourceReference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisSuggestedTasksCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<int>? position,
    Value<String>? title,
    Value<double?>? confidence,
    Value<String?>? dueDate,
    Value<String?>? instructions,
    Value<String?>? sourceReference,
    Value<int>? rowid,
  }) {
    return AnalysisSuggestedTasksCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      position: position ?? this.position,
      title: title ?? this.title,
      confidence: confidence ?? this.confidence,
      dueDate: dueDate ?? this.dueDate,
      instructions: instructions ?? this.instructions,
      sourceReference: sourceReference ?? this.sourceReference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (sourceReference.present) {
      map['source_reference'] = Variable<String>(sourceReference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisSuggestedTasksCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('confidence: $confidence, ')
          ..write('dueDate: $dueDate, ')
          ..write('instructions: $instructions, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceReferencesTable extends SourceReferences
    with TableInfo<$SourceReferencesTable, SourceReference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceReferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analyses (id)',
    ),
  );
  static const VerificationMeta _clientDocumentIdMeta = const VerificationMeta(
    'clientDocumentId',
  );
  @override
  late final GeneratedColumn<String> clientDocumentId = GeneratedColumn<String>(
    'client_document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (client_document_id)',
    ),
  );
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES document_files (id)',
    ),
  );
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _excerptLabelMeta = const VerificationMeta(
    'excerptLabel',
  );
  @override
  late final GeneratedColumn<String> excerptLabel = GeneratedColumn<String>(
    'excerpt_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    analysisId,
    clientDocumentId,
    fileId,
    pageNumber,
    excerptLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_references';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceReference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('client_document_id')) {
      context.handle(
        _clientDocumentIdMeta,
        clientDocumentId.isAcceptableOrUnknown(
          data['client_document_id']!,
          _clientDocumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientDocumentIdMeta);
    }
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    }
    if (data.containsKey('excerpt_label')) {
      context.handle(
        _excerptLabelMeta,
        excerptLabel.isAcceptableOrUnknown(
          data['excerpt_label']!,
          _excerptLabelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceReference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceReference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      clientDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_document_id'],
      )!,
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      ),
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      ),
      excerptLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}excerpt_label'],
      ),
    );
  }

  @override
  $SourceReferencesTable createAlias(String alias) {
    return $SourceReferencesTable(attachedDatabase, alias);
  }
}

class SourceReference extends DataClass implements Insertable<SourceReference> {
  final String id;
  final String analysisId;
  final String clientDocumentId;
  final String? fileId;
  final int? pageNumber;
  final String? excerptLabel;
  const SourceReference({
    required this.id,
    required this.analysisId,
    required this.clientDocumentId,
    this.fileId,
    this.pageNumber,
    this.excerptLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['client_document_id'] = Variable<String>(clientDocumentId);
    if (!nullToAbsent || fileId != null) {
      map['file_id'] = Variable<String>(fileId);
    }
    if (!nullToAbsent || pageNumber != null) {
      map['page_number'] = Variable<int>(pageNumber);
    }
    if (!nullToAbsent || excerptLabel != null) {
      map['excerpt_label'] = Variable<String>(excerptLabel);
    }
    return map;
  }

  SourceReferencesCompanion toCompanion(bool nullToAbsent) {
    return SourceReferencesCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      clientDocumentId: Value(clientDocumentId),
      fileId: fileId == null && nullToAbsent
          ? const Value.absent()
          : Value(fileId),
      pageNumber: pageNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(pageNumber),
      excerptLabel: excerptLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(excerptLabel),
    );
  }

  factory SourceReference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceReference(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      clientDocumentId: serializer.fromJson<String>(json['clientDocumentId']),
      fileId: serializer.fromJson<String?>(json['fileId']),
      pageNumber: serializer.fromJson<int?>(json['pageNumber']),
      excerptLabel: serializer.fromJson<String?>(json['excerptLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'clientDocumentId': serializer.toJson<String>(clientDocumentId),
      'fileId': serializer.toJson<String?>(fileId),
      'pageNumber': serializer.toJson<int?>(pageNumber),
      'excerptLabel': serializer.toJson<String?>(excerptLabel),
    };
  }

  SourceReference copyWith({
    String? id,
    String? analysisId,
    String? clientDocumentId,
    Value<String?> fileId = const Value.absent(),
    Value<int?> pageNumber = const Value.absent(),
    Value<String?> excerptLabel = const Value.absent(),
  }) => SourceReference(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    clientDocumentId: clientDocumentId ?? this.clientDocumentId,
    fileId: fileId.present ? fileId.value : this.fileId,
    pageNumber: pageNumber.present ? pageNumber.value : this.pageNumber,
    excerptLabel: excerptLabel.present ? excerptLabel.value : this.excerptLabel,
  );
  SourceReference copyWithCompanion(SourceReferencesCompanion data) {
    return SourceReference(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      clientDocumentId: data.clientDocumentId.present
          ? data.clientDocumentId.value
          : this.clientDocumentId,
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      excerptLabel: data.excerptLabel.present
          ? data.excerptLabel.value
          : this.excerptLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceReference(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('fileId: $fileId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('excerptLabel: $excerptLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    analysisId,
    clientDocumentId,
    fileId,
    pageNumber,
    excerptLabel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceReference &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.clientDocumentId == this.clientDocumentId &&
          other.fileId == this.fileId &&
          other.pageNumber == this.pageNumber &&
          other.excerptLabel == this.excerptLabel);
}

class SourceReferencesCompanion extends UpdateCompanion<SourceReference> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<String> clientDocumentId;
  final Value<String?> fileId;
  final Value<int?> pageNumber;
  final Value<String?> excerptLabel;
  final Value<int> rowid;
  const SourceReferencesCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.clientDocumentId = const Value.absent(),
    this.fileId = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.excerptLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceReferencesCompanion.insert({
    required String id,
    required String analysisId,
    required String clientDocumentId,
    this.fileId = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.excerptLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       clientDocumentId = Value(clientDocumentId);
  static Insertable<SourceReference> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<String>? clientDocumentId,
    Expression<String>? fileId,
    Expression<int>? pageNumber,
    Expression<String>? excerptLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (clientDocumentId != null) 'client_document_id': clientDocumentId,
      if (fileId != null) 'file_id': fileId,
      if (pageNumber != null) 'page_number': pageNumber,
      if (excerptLabel != null) 'excerpt_label': excerptLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceReferencesCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<String>? clientDocumentId,
    Value<String?>? fileId,
    Value<int?>? pageNumber,
    Value<String?>? excerptLabel,
    Value<int>? rowid,
  }) {
    return SourceReferencesCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
      fileId: fileId ?? this.fileId,
      pageNumber: pageNumber ?? this.pageNumber,
      excerptLabel: excerptLabel ?? this.excerptLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (clientDocumentId.present) {
      map['client_document_id'] = Variable<String>(clientDocumentId.value);
    }
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (excerptLabel.present) {
      map['excerpt_label'] = Variable<String>(excerptLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceReferencesCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('fileId: $fileId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('excerptLabel: $excerptLabel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientDocumentIdMeta = const VerificationMeta(
    'clientDocumentId',
  );
  @override
  late final GeneratedColumn<String> clientDocumentId = GeneratedColumn<String>(
    'client_document_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (client_document_id)',
    ),
  );
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<String> caseId = GeneratedColumn<String>(
    'case_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cases (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provenanceMeta = const VerificationMeta(
    'provenance',
  );
  @override
  late final GeneratedColumn<String> provenance = GeneratedColumn<String>(
    'provenance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientDocumentId,
    caseId,
    title,
    dueAt,
    status,
    provenance,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_document_id')) {
      context.handle(
        _clientDocumentIdMeta,
        clientDocumentId.isAcceptableOrUnknown(
          data['client_document_id']!,
          _clientDocumentIdMeta,
        ),
      );
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('provenance')) {
      context.handle(
        _provenanceMeta,
        provenance.isAcceptableOrUnknown(data['provenance']!, _provenanceMeta),
      );
    } else if (isInserting) {
      context.missing(_provenanceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_document_id'],
      ),
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}case_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      provenance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provenance'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String? clientDocumentId;
  final String? caseId;
  final String title;
  final DateTime? dueAt;
  final String status;
  final String provenance;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Task({
    required this.id,
    this.clientDocumentId,
    this.caseId,
    required this.title,
    this.dueAt,
    required this.status,
    required this.provenance,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || clientDocumentId != null) {
      map['client_document_id'] = Variable<String>(clientDocumentId);
    }
    if (!nullToAbsent || caseId != null) {
      map['case_id'] = Variable<String>(caseId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    map['status'] = Variable<String>(status);
    map['provenance'] = Variable<String>(provenance);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      clientDocumentId: clientDocumentId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientDocumentId),
      caseId: caseId == null && nullToAbsent
          ? const Value.absent()
          : Value(caseId),
      title: Value(title),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      status: Value(status),
      provenance: Value(provenance),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      clientDocumentId: serializer.fromJson<String?>(json['clientDocumentId']),
      caseId: serializer.fromJson<String?>(json['caseId']),
      title: serializer.fromJson<String>(json['title']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      status: serializer.fromJson<String>(json['status']),
      provenance: serializer.fromJson<String>(json['provenance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientDocumentId': serializer.toJson<String?>(clientDocumentId),
      'caseId': serializer.toJson<String?>(caseId),
      'title': serializer.toJson<String>(title),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'status': serializer.toJson<String>(status),
      'provenance': serializer.toJson<String>(provenance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Task copyWith({
    String? id,
    Value<String?> clientDocumentId = const Value.absent(),
    Value<String?> caseId = const Value.absent(),
    String? title,
    Value<DateTime?> dueAt = const Value.absent(),
    String? status,
    String? provenance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Task(
    id: id ?? this.id,
    clientDocumentId: clientDocumentId.present
        ? clientDocumentId.value
        : this.clientDocumentId,
    caseId: caseId.present ? caseId.value : this.caseId,
    title: title ?? this.title,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    status: status ?? this.status,
    provenance: provenance ?? this.provenance,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      clientDocumentId: data.clientDocumentId.present
          ? data.clientDocumentId.value
          : this.clientDocumentId,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      title: data.title.present ? data.title.value : this.title,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      status: data.status.present ? data.status.value : this.status,
      provenance: data.provenance.present
          ? data.provenance.value
          : this.provenance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('caseId: $caseId, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('status: $status, ')
          ..write('provenance: $provenance, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientDocumentId,
    caseId,
    title,
    dueAt,
    status,
    provenance,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.clientDocumentId == this.clientDocumentId &&
          other.caseId == this.caseId &&
          other.title == this.title &&
          other.dueAt == this.dueAt &&
          other.status == this.status &&
          other.provenance == this.provenance &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String?> clientDocumentId;
  final Value<String?> caseId;
  final Value<String> title;
  final Value<DateTime?> dueAt;
  final Value<String> status;
  final Value<String> provenance;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.clientDocumentId = const Value.absent(),
    this.caseId = const Value.absent(),
    this.title = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.status = const Value.absent(),
    this.provenance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    this.clientDocumentId = const Value.absent(),
    this.caseId = const Value.absent(),
    required String title,
    this.dueAt = const Value.absent(),
    required String status,
    required String provenance,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       status = Value(status),
       provenance = Value(provenance),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? clientDocumentId,
    Expression<String>? caseId,
    Expression<String>? title,
    Expression<DateTime>? dueAt,
    Expression<String>? status,
    Expression<String>? provenance,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientDocumentId != null) 'client_document_id': clientDocumentId,
      if (caseId != null) 'case_id': caseId,
      if (title != null) 'title': title,
      if (dueAt != null) 'due_at': dueAt,
      if (status != null) 'status': status,
      if (provenance != null) 'provenance': provenance,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String?>? clientDocumentId,
    Value<String?>? caseId,
    Value<String>? title,
    Value<DateTime?>? dueAt,
    Value<String>? status,
    Value<String>? provenance,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
      caseId: caseId ?? this.caseId,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      status: status ?? this.status,
      provenance: provenance ?? this.provenance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientDocumentId.present) {
      map['client_document_id'] = Variable<String>(clientDocumentId.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<String>(caseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (provenance.present) {
      map['provenance'] = Variable<String>(provenance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('caseId: $caseId, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('status: $status, ')
          ..write('provenance: $provenance, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeadlinesTable extends Deadlines
    with TableInfo<$DeadlinesTable, Deadline> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeadlinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientDocumentIdMeta = const VerificationMeta(
    'clientDocumentId',
  );
  @override
  late final GeneratedColumn<String> clientDocumentId = GeneratedColumn<String>(
    'client_document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (client_document_id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, clientDocumentId, label, dueAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deadlines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Deadline> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_document_id')) {
      context.handle(
        _clientDocumentIdMeta,
        clientDocumentId.isAcceptableOrUnknown(
          data['client_document_id']!,
          _clientDocumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientDocumentIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deadline map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deadline(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_document_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
    );
  }

  @override
  $DeadlinesTable createAlias(String alias) {
    return $DeadlinesTable(attachedDatabase, alias);
  }
}

class Deadline extends DataClass implements Insertable<Deadline> {
  final String id;
  final String clientDocumentId;
  final String label;
  final DateTime dueAt;
  const Deadline({
    required this.id,
    required this.clientDocumentId,
    required this.label,
    required this.dueAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_document_id'] = Variable<String>(clientDocumentId);
    map['label'] = Variable<String>(label);
    map['due_at'] = Variable<DateTime>(dueAt);
    return map;
  }

  DeadlinesCompanion toCompanion(bool nullToAbsent) {
    return DeadlinesCompanion(
      id: Value(id),
      clientDocumentId: Value(clientDocumentId),
      label: Value(label),
      dueAt: Value(dueAt),
    );
  }

  factory Deadline.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deadline(
      id: serializer.fromJson<String>(json['id']),
      clientDocumentId: serializer.fromJson<String>(json['clientDocumentId']),
      label: serializer.fromJson<String>(json['label']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientDocumentId': serializer.toJson<String>(clientDocumentId),
      'label': serializer.toJson<String>(label),
      'dueAt': serializer.toJson<DateTime>(dueAt),
    };
  }

  Deadline copyWith({
    String? id,
    String? clientDocumentId,
    String? label,
    DateTime? dueAt,
  }) => Deadline(
    id: id ?? this.id,
    clientDocumentId: clientDocumentId ?? this.clientDocumentId,
    label: label ?? this.label,
    dueAt: dueAt ?? this.dueAt,
  );
  Deadline copyWithCompanion(DeadlinesCompanion data) {
    return Deadline(
      id: data.id.present ? data.id.value : this.id,
      clientDocumentId: data.clientDocumentId.present
          ? data.clientDocumentId.value
          : this.clientDocumentId,
      label: data.label.present ? data.label.value : this.label,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Deadline(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('label: $label, ')
          ..write('dueAt: $dueAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clientDocumentId, label, dueAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deadline &&
          other.id == this.id &&
          other.clientDocumentId == this.clientDocumentId &&
          other.label == this.label &&
          other.dueAt == this.dueAt);
}

class DeadlinesCompanion extends UpdateCompanion<Deadline> {
  final Value<String> id;
  final Value<String> clientDocumentId;
  final Value<String> label;
  final Value<DateTime> dueAt;
  final Value<int> rowid;
  const DeadlinesCompanion({
    this.id = const Value.absent(),
    this.clientDocumentId = const Value.absent(),
    this.label = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeadlinesCompanion.insert({
    required String id,
    required String clientDocumentId,
    required String label,
    required DateTime dueAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientDocumentId = Value(clientDocumentId),
       label = Value(label),
       dueAt = Value(dueAt);
  static Insertable<Deadline> custom({
    Expression<String>? id,
    Expression<String>? clientDocumentId,
    Expression<String>? label,
    Expression<DateTime>? dueAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientDocumentId != null) 'client_document_id': clientDocumentId,
      if (label != null) 'label': label,
      if (dueAt != null) 'due_at': dueAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeadlinesCompanion copyWith({
    Value<String>? id,
    Value<String>? clientDocumentId,
    Value<String>? label,
    Value<DateTime>? dueAt,
    Value<int>? rowid,
  }) {
    return DeadlinesCompanion(
      id: id ?? this.id,
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
      label: label ?? this.label,
      dueAt: dueAt ?? this.dueAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientDocumentId.present) {
      map['client_document_id'] = Variable<String>(clientDocumentId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeadlinesCompanion(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('label: $label, ')
          ..write('dueAt: $dueAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppointmentsTable extends Appointments
    with TableInfo<$AppointmentsTable, Appointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientDocumentIdMeta = const VerificationMeta(
    'clientDocumentId',
  );
  @override
  late final GeneratedColumn<String> clientDocumentId = GeneratedColumn<String>(
    'client_document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (client_document_id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, clientDocumentId, label, startsAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Appointment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_document_id')) {
      context.handle(
        _clientDocumentIdMeta,
        clientDocumentId.isAcceptableOrUnknown(
          data['client_document_id']!,
          _clientDocumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientDocumentIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Appointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Appointment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_document_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
    );
  }

  @override
  $AppointmentsTable createAlias(String alias) {
    return $AppointmentsTable(attachedDatabase, alias);
  }
}

class Appointment extends DataClass implements Insertable<Appointment> {
  final String id;
  final String clientDocumentId;
  final String label;
  final DateTime startsAt;
  const Appointment({
    required this.id,
    required this.clientDocumentId,
    required this.label,
    required this.startsAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_document_id'] = Variable<String>(clientDocumentId);
    map['label'] = Variable<String>(label);
    map['starts_at'] = Variable<DateTime>(startsAt);
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      id: Value(id),
      clientDocumentId: Value(clientDocumentId),
      label: Value(label),
      startsAt: Value(startsAt),
    );
  }

  factory Appointment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Appointment(
      id: serializer.fromJson<String>(json['id']),
      clientDocumentId: serializer.fromJson<String>(json['clientDocumentId']),
      label: serializer.fromJson<String>(json['label']),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientDocumentId': serializer.toJson<String>(clientDocumentId),
      'label': serializer.toJson<String>(label),
      'startsAt': serializer.toJson<DateTime>(startsAt),
    };
  }

  Appointment copyWith({
    String? id,
    String? clientDocumentId,
    String? label,
    DateTime? startsAt,
  }) => Appointment(
    id: id ?? this.id,
    clientDocumentId: clientDocumentId ?? this.clientDocumentId,
    label: label ?? this.label,
    startsAt: startsAt ?? this.startsAt,
  );
  Appointment copyWithCompanion(AppointmentsCompanion data) {
    return Appointment(
      id: data.id.present ? data.id.value : this.id,
      clientDocumentId: data.clientDocumentId.present
          ? data.clientDocumentId.value
          : this.clientDocumentId,
      label: data.label.present ? data.label.value : this.label,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Appointment(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('label: $label, ')
          ..write('startsAt: $startsAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clientDocumentId, label, startsAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Appointment &&
          other.id == this.id &&
          other.clientDocumentId == this.clientDocumentId &&
          other.label == this.label &&
          other.startsAt == this.startsAt);
}

class AppointmentsCompanion extends UpdateCompanion<Appointment> {
  final Value<String> id;
  final Value<String> clientDocumentId;
  final Value<String> label;
  final Value<DateTime> startsAt;
  final Value<int> rowid;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.clientDocumentId = const Value.absent(),
    this.label = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    required String id,
    required String clientDocumentId,
    required String label,
    required DateTime startsAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientDocumentId = Value(clientDocumentId),
       label = Value(label),
       startsAt = Value(startsAt);
  static Insertable<Appointment> custom({
    Expression<String>? id,
    Expression<String>? clientDocumentId,
    Expression<String>? label,
    Expression<DateTime>? startsAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientDocumentId != null) 'client_document_id': clientDocumentId,
      if (label != null) 'label': label,
      if (startsAt != null) 'starts_at': startsAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppointmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientDocumentId,
    Value<String>? label,
    Value<DateTime>? startsAt,
    Value<int>? rowid,
  }) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
      label: label ?? this.label,
      startsAt: startsAt ?? this.startsAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientDocumentId.present) {
      map['client_document_id'] = Variable<String>(clientDocumentId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('label: $label, ')
          ..write('startsAt: $startsAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AmountsTable extends Amounts with TableInfo<$AmountsTable, Amount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AmountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientDocumentIdMeta = const VerificationMeta(
    'clientDocumentId',
  );
  @override
  late final GeneratedColumn<String> clientDocumentId = GeneratedColumn<String>(
    'client_document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (client_document_id)',
    ),
  );
  static const VerificationMeta _valueInCentsMeta = const VerificationMeta(
    'valueInCents',
  );
  @override
  late final GeneratedColumn<int> valueInCents = GeneratedColumn<int>(
    'value_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientDocumentId,
    valueInCents,
    currency,
    direction,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'amounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Amount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_document_id')) {
      context.handle(
        _clientDocumentIdMeta,
        clientDocumentId.isAcceptableOrUnknown(
          data['client_document_id']!,
          _clientDocumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientDocumentIdMeta);
    }
    if (data.containsKey('value_in_cents')) {
      context.handle(
        _valueInCentsMeta,
        valueInCents.isAcceptableOrUnknown(
          data['value_in_cents']!,
          _valueInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valueInCentsMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Amount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Amount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_document_id'],
      )!,
      valueInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value_in_cents'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
    );
  }

  @override
  $AmountsTable createAlias(String alias) {
    return $AmountsTable(attachedDatabase, alias);
  }
}

class Amount extends DataClass implements Insertable<Amount> {
  final String id;
  final String clientDocumentId;
  final int valueInCents;
  final String currency;
  final String direction;
  const Amount({
    required this.id,
    required this.clientDocumentId,
    required this.valueInCents,
    required this.currency,
    required this.direction,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_document_id'] = Variable<String>(clientDocumentId);
    map['value_in_cents'] = Variable<int>(valueInCents);
    map['currency'] = Variable<String>(currency);
    map['direction'] = Variable<String>(direction);
    return map;
  }

  AmountsCompanion toCompanion(bool nullToAbsent) {
    return AmountsCompanion(
      id: Value(id),
      clientDocumentId: Value(clientDocumentId),
      valueInCents: Value(valueInCents),
      currency: Value(currency),
      direction: Value(direction),
    );
  }

  factory Amount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Amount(
      id: serializer.fromJson<String>(json['id']),
      clientDocumentId: serializer.fromJson<String>(json['clientDocumentId']),
      valueInCents: serializer.fromJson<int>(json['valueInCents']),
      currency: serializer.fromJson<String>(json['currency']),
      direction: serializer.fromJson<String>(json['direction']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientDocumentId': serializer.toJson<String>(clientDocumentId),
      'valueInCents': serializer.toJson<int>(valueInCents),
      'currency': serializer.toJson<String>(currency),
      'direction': serializer.toJson<String>(direction),
    };
  }

  Amount copyWith({
    String? id,
    String? clientDocumentId,
    int? valueInCents,
    String? currency,
    String? direction,
  }) => Amount(
    id: id ?? this.id,
    clientDocumentId: clientDocumentId ?? this.clientDocumentId,
    valueInCents: valueInCents ?? this.valueInCents,
    currency: currency ?? this.currency,
    direction: direction ?? this.direction,
  );
  Amount copyWithCompanion(AmountsCompanion data) {
    return Amount(
      id: data.id.present ? data.id.value : this.id,
      clientDocumentId: data.clientDocumentId.present
          ? data.clientDocumentId.value
          : this.clientDocumentId,
      valueInCents: data.valueInCents.present
          ? data.valueInCents.value
          : this.valueInCents,
      currency: data.currency.present ? data.currency.value : this.currency,
      direction: data.direction.present ? data.direction.value : this.direction,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Amount(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('valueInCents: $valueInCents, ')
          ..write('currency: $currency, ')
          ..write('direction: $direction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, clientDocumentId, valueInCents, currency, direction);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Amount &&
          other.id == this.id &&
          other.clientDocumentId == this.clientDocumentId &&
          other.valueInCents == this.valueInCents &&
          other.currency == this.currency &&
          other.direction == this.direction);
}

class AmountsCompanion extends UpdateCompanion<Amount> {
  final Value<String> id;
  final Value<String> clientDocumentId;
  final Value<int> valueInCents;
  final Value<String> currency;
  final Value<String> direction;
  final Value<int> rowid;
  const AmountsCompanion({
    this.id = const Value.absent(),
    this.clientDocumentId = const Value.absent(),
    this.valueInCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.direction = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AmountsCompanion.insert({
    required String id,
    required String clientDocumentId,
    required int valueInCents,
    required String currency,
    required String direction,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientDocumentId = Value(clientDocumentId),
       valueInCents = Value(valueInCents),
       currency = Value(currency),
       direction = Value(direction);
  static Insertable<Amount> custom({
    Expression<String>? id,
    Expression<String>? clientDocumentId,
    Expression<int>? valueInCents,
    Expression<String>? currency,
    Expression<String>? direction,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientDocumentId != null) 'client_document_id': clientDocumentId,
      if (valueInCents != null) 'value_in_cents': valueInCents,
      if (currency != null) 'currency': currency,
      if (direction != null) 'direction': direction,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AmountsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientDocumentId,
    Value<int>? valueInCents,
    Value<String>? currency,
    Value<String>? direction,
    Value<int>? rowid,
  }) {
    return AmountsCompanion(
      id: id ?? this.id,
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
      valueInCents: valueInCents ?? this.valueInCents,
      currency: currency ?? this.currency,
      direction: direction ?? this.direction,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientDocumentId.present) {
      map['client_document_id'] = Variable<String>(clientDocumentId.value);
    }
    if (valueInCents.present) {
      map['value_in_cents'] = Variable<int>(valueInCents.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AmountsCompanion(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('valueInCents: $valueInCents, ')
          ..write('currency: $currency, ')
          ..write('direction: $direction, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RequiredDocumentsTable extends RequiredDocuments
    with TableInfo<$RequiredDocumentsTable, RequiredDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequiredDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientDocumentIdMeta = const VerificationMeta(
    'clientDocumentId',
  );
  @override
  late final GeneratedColumn<String> clientDocumentId = GeneratedColumn<String>(
    'client_document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (client_document_id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('requested'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientDocumentId,
    description,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'required_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<RequiredDocument> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_document_id')) {
      context.handle(
        _clientDocumentIdMeta,
        clientDocumentId.isAcceptableOrUnknown(
          data['client_document_id']!,
          _clientDocumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientDocumentIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RequiredDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RequiredDocument(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_document_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $RequiredDocumentsTable createAlias(String alias) {
    return $RequiredDocumentsTable(attachedDatabase, alias);
  }
}

class RequiredDocument extends DataClass
    implements Insertable<RequiredDocument> {
  final String id;
  final String clientDocumentId;
  final String description;
  final String status;
  const RequiredDocument({
    required this.id,
    required this.clientDocumentId,
    required this.description,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_document_id'] = Variable<String>(clientDocumentId);
    map['description'] = Variable<String>(description);
    map['status'] = Variable<String>(status);
    return map;
  }

  RequiredDocumentsCompanion toCompanion(bool nullToAbsent) {
    return RequiredDocumentsCompanion(
      id: Value(id),
      clientDocumentId: Value(clientDocumentId),
      description: Value(description),
      status: Value(status),
    );
  }

  factory RequiredDocument.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RequiredDocument(
      id: serializer.fromJson<String>(json['id']),
      clientDocumentId: serializer.fromJson<String>(json['clientDocumentId']),
      description: serializer.fromJson<String>(json['description']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientDocumentId': serializer.toJson<String>(clientDocumentId),
      'description': serializer.toJson<String>(description),
      'status': serializer.toJson<String>(status),
    };
  }

  RequiredDocument copyWith({
    String? id,
    String? clientDocumentId,
    String? description,
    String? status,
  }) => RequiredDocument(
    id: id ?? this.id,
    clientDocumentId: clientDocumentId ?? this.clientDocumentId,
    description: description ?? this.description,
    status: status ?? this.status,
  );
  RequiredDocument copyWithCompanion(RequiredDocumentsCompanion data) {
    return RequiredDocument(
      id: data.id.present ? data.id.value : this.id,
      clientDocumentId: data.clientDocumentId.present
          ? data.clientDocumentId.value
          : this.clientDocumentId,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RequiredDocument(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('description: $description, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clientDocumentId, description, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequiredDocument &&
          other.id == this.id &&
          other.clientDocumentId == this.clientDocumentId &&
          other.description == this.description &&
          other.status == this.status);
}

class RequiredDocumentsCompanion extends UpdateCompanion<RequiredDocument> {
  final Value<String> id;
  final Value<String> clientDocumentId;
  final Value<String> description;
  final Value<String> status;
  final Value<int> rowid;
  const RequiredDocumentsCompanion({
    this.id = const Value.absent(),
    this.clientDocumentId = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RequiredDocumentsCompanion.insert({
    required String id,
    required String clientDocumentId,
    required String description,
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientDocumentId = Value(clientDocumentId),
       description = Value(description);
  static Insertable<RequiredDocument> custom({
    Expression<String>? id,
    Expression<String>? clientDocumentId,
    Expression<String>? description,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientDocumentId != null) 'client_document_id': clientDocumentId,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RequiredDocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientDocumentId,
    Value<String>? description,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return RequiredDocumentsCompanion(
      id: id ?? this.id,
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
      description: description ?? this.description,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientDocumentId.present) {
      map['client_document_id'] = Variable<String>(clientDocumentId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequiredDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisOperationsTable extends AnalysisOperations
    with TableInfo<$AnalysisOperationsTable, AnalysisOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientDocumentIdMeta = const VerificationMeta(
    'clientDocumentId',
  );
  @override
  late final GeneratedColumn<String> clientDocumentId = GeneratedColumn<String>(
    'client_document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (client_document_id)',
    ),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastFailureCodeMeta = const VerificationMeta(
    'lastFailureCode',
  );
  @override
  late final GeneratedColumn<String> lastFailureCode = GeneratedColumn<String>(
    'last_failure_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    clientDocumentId,
    state,
    lastFailureCode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('client_document_id')) {
      context.handle(
        _clientDocumentIdMeta,
        clientDocumentId.isAcceptableOrUnknown(
          data['client_document_id']!,
          _clientDocumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientDocumentIdMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('last_failure_code')) {
      context.handle(
        _lastFailureCodeMeta,
        lastFailureCode.isAcceptableOrUnknown(
          data['last_failure_code']!,
          _lastFailureCodeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  AnalysisOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisOperation(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      clientDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_document_id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      lastFailureCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_failure_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AnalysisOperationsTable createAlias(String alias) {
    return $AnalysisOperationsTable(attachedDatabase, alias);
  }
}

class AnalysisOperation extends DataClass
    implements Insertable<AnalysisOperation> {
  final String operationId;
  final String clientDocumentId;
  final String state;
  final String? lastFailureCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AnalysisOperation({
    required this.operationId,
    required this.clientDocumentId,
    required this.state,
    this.lastFailureCode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['client_document_id'] = Variable<String>(clientDocumentId);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || lastFailureCode != null) {
      map['last_failure_code'] = Variable<String>(lastFailureCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AnalysisOperationsCompanion toCompanion(bool nullToAbsent) {
    return AnalysisOperationsCompanion(
      operationId: Value(operationId),
      clientDocumentId: Value(clientDocumentId),
      state: Value(state),
      lastFailureCode: lastFailureCode == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFailureCode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AnalysisOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisOperation(
      operationId: serializer.fromJson<String>(json['operationId']),
      clientDocumentId: serializer.fromJson<String>(json['clientDocumentId']),
      state: serializer.fromJson<String>(json['state']),
      lastFailureCode: serializer.fromJson<String?>(json['lastFailureCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'clientDocumentId': serializer.toJson<String>(clientDocumentId),
      'state': serializer.toJson<String>(state),
      'lastFailureCode': serializer.toJson<String?>(lastFailureCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AnalysisOperation copyWith({
    String? operationId,
    String? clientDocumentId,
    String? state,
    Value<String?> lastFailureCode = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AnalysisOperation(
    operationId: operationId ?? this.operationId,
    clientDocumentId: clientDocumentId ?? this.clientDocumentId,
    state: state ?? this.state,
    lastFailureCode: lastFailureCode.present
        ? lastFailureCode.value
        : this.lastFailureCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AnalysisOperation copyWithCompanion(AnalysisOperationsCompanion data) {
    return AnalysisOperation(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      clientDocumentId: data.clientDocumentId.present
          ? data.clientDocumentId.value
          : this.clientDocumentId,
      state: data.state.present ? data.state.value : this.state,
      lastFailureCode: data.lastFailureCode.present
          ? data.lastFailureCode.value
          : this.lastFailureCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisOperation(')
          ..write('operationId: $operationId, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('state: $state, ')
          ..write('lastFailureCode: $lastFailureCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationId,
    clientDocumentId,
    state,
    lastFailureCode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisOperation &&
          other.operationId == this.operationId &&
          other.clientDocumentId == this.clientDocumentId &&
          other.state == this.state &&
          other.lastFailureCode == this.lastFailureCode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AnalysisOperationsCompanion extends UpdateCompanion<AnalysisOperation> {
  final Value<String> operationId;
  final Value<String> clientDocumentId;
  final Value<String> state;
  final Value<String?> lastFailureCode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AnalysisOperationsCompanion({
    this.operationId = const Value.absent(),
    this.clientDocumentId = const Value.absent(),
    this.state = const Value.absent(),
    this.lastFailureCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisOperationsCompanion.insert({
    required String operationId,
    required String clientDocumentId,
    required String state,
    this.lastFailureCode = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       clientDocumentId = Value(clientDocumentId),
       state = Value(state),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AnalysisOperation> custom({
    Expression<String>? operationId,
    Expression<String>? clientDocumentId,
    Expression<String>? state,
    Expression<String>? lastFailureCode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (clientDocumentId != null) 'client_document_id': clientDocumentId,
      if (state != null) 'state': state,
      if (lastFailureCode != null) 'last_failure_code': lastFailureCode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisOperationsCompanion copyWith({
    Value<String>? operationId,
    Value<String>? clientDocumentId,
    Value<String>? state,
    Value<String?>? lastFailureCode,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AnalysisOperationsCompanion(
      operationId: operationId ?? this.operationId,
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
      state: state ?? this.state,
      lastFailureCode: lastFailureCode ?? this.lastFailureCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (clientDocumentId.present) {
      map['client_document_id'] = Variable<String>(clientDocumentId.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (lastFailureCode.present) {
      map['last_failure_code'] = Variable<String>(lastFailureCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisOperationsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('clientDocumentId: $clientDocumentId, ')
          ..write('state: $state, ')
          ..write('lastFailureCode: $lastFailureCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const UserSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserSetting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      UserSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<UserSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OrganizationsTable organizations = $OrganizationsTable(this);
  late final $CasesTable cases = $CasesTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $DocumentFilesTable documentFiles = $DocumentFilesTable(this);
  late final $AnalysesTable analyses = $AnalysesTable(this);
  late final $AnalysisQualityReasonsTable analysisQualityReasons =
      $AnalysisQualityReasonsTable(this);
  late final $AnalysisNextActionsTable analysisNextActions =
      $AnalysisNextActionsTable(this);
  late final $AnalysisUncertaintiesTable analysisUncertainties =
      $AnalysisUncertaintiesTable(this);
  late final $AnalysisPracticalStatesTable analysisPracticalStates =
      $AnalysisPracticalStatesTable(this);
  late final $AnalysisDeadlinesTable analysisDeadlines =
      $AnalysisDeadlinesTable(this);
  late final $AnalysisAppointmentsTable analysisAppointments =
      $AnalysisAppointmentsTable(this);
  late final $AnalysisAmountsTable analysisAmounts = $AnalysisAmountsTable(
    this,
  );
  late final $AnalysisRequiredDocumentsTable analysisRequiredDocuments =
      $AnalysisRequiredDocumentsTable(this);
  late final $AnalysisSuggestedTasksTable analysisSuggestedTasks =
      $AnalysisSuggestedTasksTable(this);
  late final $SourceReferencesTable sourceReferences = $SourceReferencesTable(
    this,
  );
  late final $TasksTable tasks = $TasksTable(this);
  late final $DeadlinesTable deadlines = $DeadlinesTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $AmountsTable amounts = $AmountsTable(this);
  late final $RequiredDocumentsTable requiredDocuments =
      $RequiredDocumentsTable(this);
  late final $AnalysisOperationsTable analysisOperations =
      $AnalysisOperationsTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    organizations,
    cases,
    documents,
    documentFiles,
    analyses,
    analysisQualityReasons,
    analysisNextActions,
    analysisUncertainties,
    analysisPracticalStates,
    analysisDeadlines,
    analysisAppointments,
    analysisAmounts,
    analysisRequiredDocuments,
    analysisSuggestedTasks,
    sourceReferences,
    tasks,
    deadlines,
    appointments,
    amounts,
    requiredDocuments,
    analysisOperations,
    userSettings,
  ];
}

typedef $$OrganizationsTableCreateCompanionBuilder =
    OrganizationsCompanion Function({
      required String id,
      required String name,
      required String category,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$OrganizationsTableUpdateCompanionBuilder =
    OrganizationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$OrganizationsTableReferences
    extends BaseReferences<_$AppDatabase, $OrganizationsTable, Organization> {
  $$OrganizationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CasesTable, List<Case>> _casesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cases,
    aliasName: 'organizations__id__cases__organization_id',
  );

  $$CasesTableProcessedTableManager get casesRefs {
    final manager = $$CasesTableTableManager(
      $_db,
      $_db.cases,
    ).filter((f) => f.organizationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_casesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DocumentsTable, List<Document>>
  _documentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documents,
    aliasName: 'organizations__id__documents__organization_id',
  );

  $$DocumentsTableProcessedTableManager get documentsRefs {
    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.organizationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrganizationsTableFilterComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> casesRefs(
    Expression<bool> Function($$CasesTableFilterComposer f) f,
  ) {
    final $$CasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableFilterComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> documentsRefs(
    Expression<bool> Function($$DocumentsTableFilterComposer f) f,
  ) {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganizationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganizationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> casesRefs<T extends Object>(
    Expression<T> Function($$CasesTableAnnotationComposer a) f,
  ) {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> documentsRefs<T extends Object>(
    Expression<T> Function($$DocumentsTableAnnotationComposer a) f,
  ) {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganizationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganizationsTable,
          Organization,
          $$OrganizationsTableFilterComposer,
          $$OrganizationsTableOrderingComposer,
          $$OrganizationsTableAnnotationComposer,
          $$OrganizationsTableCreateCompanionBuilder,
          $$OrganizationsTableUpdateCompanionBuilder,
          (Organization, $$OrganizationsTableReferences),
          Organization,
          PrefetchHooks Function({bool casesRefs, bool documentsRefs})
        > {
  $$OrganizationsTableTableManager(_$AppDatabase db, $OrganizationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganizationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganizationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrganizationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizationsCompanion(
                id: id,
                name: name,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => OrganizationsCompanion.insert(
                id: id,
                name: name,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrganizationsTable, Organization>(table),
                  $$OrganizationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({casesRefs = false, documentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (casesRefs) db.cases,
                if (documentsRefs) db.documents,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (casesRefs)
                    await $_getPrefetchedData<
                      Organization,
                      $OrganizationsTable,
                      Case
                    >(
                      currentTable: table,
                      referencedTable: $$OrganizationsTableReferences
                          ._casesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OrganizationsTableReferences(
                            db,
                            table,
                            p0,
                          ).casesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.organizationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (documentsRefs)
                    await $_getPrefetchedData<
                      Organization,
                      $OrganizationsTable,
                      Document
                    >(
                      currentTable: table,
                      referencedTable: $$OrganizationsTableReferences
                          ._documentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OrganizationsTableReferences(
                            db,
                            table,
                            p0,
                          ).documentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.organizationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OrganizationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganizationsTable,
      Organization,
      $$OrganizationsTableFilterComposer,
      $$OrganizationsTableOrderingComposer,
      $$OrganizationsTableAnnotationComposer,
      $$OrganizationsTableCreateCompanionBuilder,
      $$OrganizationsTableUpdateCompanionBuilder,
      (Organization, $$OrganizationsTableReferences),
      Organization,
      PrefetchHooks Function({bool casesRefs, bool documentsRefs})
    >;
typedef $$CasesTableCreateCompanionBuilder = CasesCompanion Function({
  required String id,
  required String organizationId,
  required String title,
  Value<String> status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CasesTableUpdateCompanionBuilder = CasesCompanion Function({
  Value<String> id,
  Value<String> organizationId,
  Value<String> title,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$CasesTableReferences
    extends BaseReferences<_$AppDatabase, $CasesTable, Case> {
  $$CasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrganizationsTable _organizationIdTable(_$AppDatabase db) =>
      db.organizations.createAlias('cases__organization_id__organizations__id');

  $$OrganizationsTableProcessedTableManager get organizationId {
    final $_column = $_itemColumn<String>('organization_id')!;

    final manager = $$OrganizationsTableTableManager(
      $_db,
      $_db.organizations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DocumentsTable, List<Document>>
  _documentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documents,
    aliasName: 'cases__id__documents__case_id',
  );

  $$DocumentsTableProcessedTableManager get documentsRefs {
    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.caseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'cases__id__tasks__case_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.caseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CasesTableFilterComposer extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizationsTableFilterComposer get organizationId {
    final $$OrganizationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableFilterComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> documentsRefs(
    Expression<bool> Function($$DocumentsTableFilterComposer f) f,
  ) {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CasesTableOrderingComposer
    extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizationsTableOrderingComposer get organizationId {
    final $$OrganizationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableOrderingComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$OrganizationsTableAnnotationComposer get organizationId {
    final $$OrganizationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableAnnotationComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> documentsRefs<T extends Object>(
    Expression<T> Function($$DocumentsTableAnnotationComposer a) f,
  ) {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CasesTable,
          Case,
          $$CasesTableFilterComposer,
          $$CasesTableOrderingComposer,
          $$CasesTableAnnotationComposer,
          $$CasesTableCreateCompanionBuilder,
          $$CasesTableUpdateCompanionBuilder,
          (Case, $$CasesTableReferences),
          Case,
          PrefetchHooks Function({
            bool organizationId,
            bool documentsRefs,
            bool tasksRefs,
          })
        > {
  $$CasesTableTableManager(_$AppDatabase db, $CasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> organizationId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CasesCompanion(
                id: id,
                organizationId: organizationId,
                title: title,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String organizationId,
                required String title,
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CasesCompanion.insert(
                id: id,
                organizationId: organizationId,
                title: title,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CasesTable, Case>(table),
                  $$CasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                organizationId = false,
                documentsRefs = false,
                tasksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (documentsRefs) db.documents,
                    if (tasksRefs) db.tasks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (organizationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.organizationId,
                            referencedTable: $$CasesTableReferences
                                ._organizationIdTable(db),
                            referencedColumn: $$CasesTableReferences
                                ._organizationIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (documentsRefs)
                        await $_getPrefetchedData<Case, $CasesTable, Document>(
                          currentTable: table,
                          referencedTable: $$CasesTableReferences
                              ._documentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CasesTableReferences(
                                db,
                                table,
                                p0,
                              ).documentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.caseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<Case, $CasesTable, Task>(
                          currentTable: table,
                          referencedTable: $$CasesTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CasesTableReferences(db, table, p0).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.caseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CasesTable,
      Case,
      $$CasesTableFilterComposer,
      $$CasesTableOrderingComposer,
      $$CasesTableAnnotationComposer,
      $$CasesTableCreateCompanionBuilder,
      $$CasesTableUpdateCompanionBuilder,
      (Case, $$CasesTableReferences),
      Case,
      PrefetchHooks Function({
        bool organizationId,
        bool documentsRefs,
        bool tasksRefs,
      })
    >;
typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  required String clientDocumentId,
  Value<String?> organizationId,
  Value<String?> caseId,
  required String classificationState,
  required String status,
  Value<DateTime?> documentDate,
  Value<String?> sourceLanguage,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<String> clientDocumentId,
  Value<String?> organizationId,
  Value<String?> caseId,
  Value<String> classificationState,
  Value<String> status,
  Value<DateTime?> documentDate,
  Value<String?> sourceLanguage,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$DocumentsTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentsTable, Document> {
  $$DocumentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrganizationsTable _organizationIdTable(_$AppDatabase db) => db
      .organizations
      .createAlias('documents__organization_id__organizations__id');

  $$OrganizationsTableProcessedTableManager? get organizationId {
    final $_column = $_itemColumn<String>('organization_id');
    if ($_column == null) return null;
    final manager = $$OrganizationsTableTableManager(
      $_db,
      $_db.organizations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CasesTable _caseIdTable(_$AppDatabase db) =>
      db.cases.createAlias('documents__case_id__cases__id');

  $$CasesTableProcessedTableManager? get caseId {
    final $_column = $_itemColumn<String>('case_id');
    if ($_column == null) return null;
    final manager = $$CasesTableTableManager(
      $_db,
      $_db.cases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DocumentFilesTable, List<DocumentFile>>
  _documentFilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documentFiles,
    aliasName:
        'documents__client_document_id__document_files__client_document_id',
  );

  $$DocumentFilesTableProcessedTableManager get documentFilesRefs {
    final manager = $$DocumentFilesTableTableManager($_db, $_db.documentFiles)
        .filter(
          (f) => f.clientDocumentId.clientDocumentId.sqlEquals(
            $_itemColumn<String>('client_document_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_documentFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnalysesTable, List<Analyse>> _analysesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.analyses,
    aliasName: 'documents__client_document_id__analyses__client_document_id',
  );

  $$AnalysesTableProcessedTableManager get analysesRefs {
    final manager = $$AnalysesTableTableManager($_db, $_db.analyses).filter(
      (f) => f.clientDocumentId.clientDocumentId.sqlEquals(
        $_itemColumn<String>('client_document_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_analysesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SourceReferencesTable, List<SourceReference>>
  _sourceReferencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceReferences,
    aliasName:
        'documents__client_document_id__source_references__client_document_id',
  );

  $$SourceReferencesTableProcessedTableManager get sourceReferencesRefs {
    final manager =
        $$SourceReferencesTableTableManager($_db, $_db.sourceReferences).filter(
          (f) => f.clientDocumentId.clientDocumentId.sqlEquals(
            $_itemColumn<String>('client_document_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _sourceReferencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'documents__client_document_id__tasks__client_document_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager($_db, $_db.tasks).filter(
      (f) => f.clientDocumentId.clientDocumentId.sqlEquals(
        $_itemColumn<String>('client_document_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeadlinesTable, List<Deadline>>
  _deadlinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deadlines,
    aliasName: 'documents__client_document_id__deadlines__client_document_id',
  );

  $$DeadlinesTableProcessedTableManager get deadlinesRefs {
    final manager = $$DeadlinesTableTableManager($_db, $_db.deadlines).filter(
      (f) => f.clientDocumentId.clientDocumentId.sqlEquals(
        $_itemColumn<String>('client_document_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_deadlinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AppointmentsTable, List<Appointment>>
  _appointmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appointments,
    aliasName:
        'documents__client_document_id__appointments__client_document_id',
  );

  $$AppointmentsTableProcessedTableManager get appointmentsRefs {
    final manager = $$AppointmentsTableTableManager($_db, $_db.appointments)
        .filter(
          (f) => f.clientDocumentId.clientDocumentId.sqlEquals(
            $_itemColumn<String>('client_document_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_appointmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AmountsTable, List<Amount>> _amountsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.amounts,
    aliasName: 'documents__client_document_id__amounts__client_document_id',
  );

  $$AmountsTableProcessedTableManager get amountsRefs {
    final manager = $$AmountsTableTableManager($_db, $_db.amounts).filter(
      (f) => f.clientDocumentId.clientDocumentId.sqlEquals(
        $_itemColumn<String>('client_document_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_amountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RequiredDocumentsTable, List<RequiredDocument>>
  _requiredDocumentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.requiredDocuments,
    aliasName:
        'documents__client_document_id__required_documents__client_document_id',
  );

  $$RequiredDocumentsTableProcessedTableManager get requiredDocumentsRefs {
    final manager =
        $$RequiredDocumentsTableTableManager(
          $_db,
          $_db.requiredDocuments,
        ).filter(
          (f) => f.clientDocumentId.clientDocumentId.sqlEquals(
            $_itemColumn<String>('client_document_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _requiredDocumentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnalysisOperationsTable, List<AnalysisOperation>>
  _analysisOperationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.analysisOperations,
        aliasName: 'documents__client_document_id__analysis_operations__client_document_id',
      );

  $$AnalysisOperationsTableProcessedTableManager get analysisOperationsRefs {
    final manager =
        $$AnalysisOperationsTableTableManager(
          $_db,
          $_db.analysisOperations,
        ).filter(
          (f) => f.clientDocumentId.clientDocumentId.sqlEquals(
            $_itemColumn<String>('client_document_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _analysisOperationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientDocumentId => $composableBuilder(
    column: $table.clientDocumentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classificationState => $composableBuilder(
    column: $table.classificationState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get documentDate => $composableBuilder(
    column: $table.documentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizationsTableFilterComposer get organizationId {
    final $$OrganizationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableFilterComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CasesTableFilterComposer get caseId {
    final $$CasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableFilterComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> documentFilesRefs(
    Expression<bool> Function($$DocumentFilesTableFilterComposer f) f,
  ) {
    final $$DocumentFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documentFiles,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFilesTableFilterComposer(
            $db: $db,
            $table: $db.documentFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> analysesRefs(
    Expression<bool> Function($$AnalysesTableFilterComposer f) f,
  ) {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sourceReferencesRefs(
    Expression<bool> Function($$SourceReferencesTableFilterComposer f) f,
  ) {
    final $$SourceReferencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.sourceReferences,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceReferencesTableFilterComposer(
            $db: $db,
            $table: $db.sourceReferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deadlinesRefs(
    Expression<bool> Function($$DeadlinesTableFilterComposer f) f,
  ) {
    final $$DeadlinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.deadlines,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeadlinesTableFilterComposer(
            $db: $db,
            $table: $db.deadlines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> appointmentsRefs(
    Expression<bool> Function($$AppointmentsTableFilterComposer f) f,
  ) {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> amountsRefs(
    Expression<bool> Function($$AmountsTableFilterComposer f) f,
  ) {
    final $$AmountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.amounts,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AmountsTableFilterComposer(
            $db: $db,
            $table: $db.amounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> requiredDocumentsRefs(
    Expression<bool> Function($$RequiredDocumentsTableFilterComposer f) f,
  ) {
    final $$RequiredDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.requiredDocuments,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequiredDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.requiredDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> analysisOperationsRefs(
    Expression<bool> Function($$AnalysisOperationsTableFilterComposer f) f,
  ) {
    final $$AnalysisOperationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.analysisOperations,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysisOperationsTableFilterComposer(
            $db: $db,
            $table: $db.analysisOperations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientDocumentId => $composableBuilder(
    column: $table.clientDocumentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classificationState => $composableBuilder(
    column: $table.classificationState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get documentDate => $composableBuilder(
    column: $table.documentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizationsTableOrderingComposer get organizationId {
    final $$OrganizationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableOrderingComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CasesTableOrderingComposer get caseId {
    final $$CasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableOrderingComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientDocumentId => $composableBuilder(
    column: $table.clientDocumentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classificationState => $composableBuilder(
    column: $table.classificationState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get documentDate => $composableBuilder(
    column: $table.documentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$OrganizationsTableAnnotationComposer get organizationId {
    final $$OrganizationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableAnnotationComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CasesTableAnnotationComposer get caseId {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> documentFilesRefs<T extends Object>(
    Expression<T> Function($$DocumentFilesTableAnnotationComposer a) f,
  ) {
    final $$DocumentFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documentFiles,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.documentFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> analysesRefs<T extends Object>(
    Expression<T> Function($$AnalysesTableAnnotationComposer a) f,
  ) {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sourceReferencesRefs<T extends Object>(
    Expression<T> Function($$SourceReferencesTableAnnotationComposer a) f,
  ) {
    final $$SourceReferencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.sourceReferences,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceReferencesTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceReferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> deadlinesRefs<T extends Object>(
    Expression<T> Function($$DeadlinesTableAnnotationComposer a) f,
  ) {
    final $$DeadlinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.deadlines,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeadlinesTableAnnotationComposer(
            $db: $db,
            $table: $db.deadlines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> appointmentsRefs<T extends Object>(
    Expression<T> Function($$AppointmentsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> amountsRefs<T extends Object>(
    Expression<T> Function($$AmountsTableAnnotationComposer a) f,
  ) {
    final $$AmountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.amounts,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AmountsTableAnnotationComposer(
            $db: $db,
            $table: $db.amounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> requiredDocumentsRefs<T extends Object>(
    Expression<T> Function($$RequiredDocumentsTableAnnotationComposer a) f,
  ) {
    final $$RequiredDocumentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.clientDocumentId,
          referencedTable: $db.requiredDocuments,
          getReferencedColumn: (t) => t.clientDocumentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RequiredDocumentsTableAnnotationComposer(
                $db: $db,
                $table: $db.requiredDocuments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> analysisOperationsRefs<T extends Object>(
    Expression<T> Function($$AnalysisOperationsTableAnnotationComposer a) f,
  ) {
    final $$AnalysisOperationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.clientDocumentId,
          referencedTable: $db.analysisOperations,
          getReferencedColumn: (t) => t.clientDocumentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisOperationsTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisOperations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentsTable,
          Document,
          $$DocumentsTableFilterComposer,
          $$DocumentsTableOrderingComposer,
          $$DocumentsTableAnnotationComposer,
          $$DocumentsTableCreateCompanionBuilder,
          $$DocumentsTableUpdateCompanionBuilder,
          (Document, $$DocumentsTableReferences),
          Document,
          PrefetchHooks Function({
            bool organizationId,
            bool caseId,
            bool documentFilesRefs,
            bool analysesRefs,
            bool sourceReferencesRefs,
            bool tasksRefs,
            bool deadlinesRefs,
            bool appointmentsRefs,
            bool amountsRefs,
            bool requiredDocumentsRefs,
            bool analysisOperationsRefs,
          })
        > {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientDocumentId = const Value.absent(),
                Value<String?> organizationId = const Value.absent(),
                Value<String?> caseId = const Value.absent(),
                Value<String> classificationState = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> documentDate = const Value.absent(),
                Value<String?> sourceLanguage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentsCompanion(
                clientDocumentId: clientDocumentId,
                organizationId: organizationId,
                caseId: caseId,
                classificationState: classificationState,
                status: status,
                documentDate: documentDate,
                sourceLanguage: sourceLanguage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientDocumentId,
                Value<String?> organizationId = const Value.absent(),
                Value<String?> caseId = const Value.absent(),
                required String classificationState,
                required String status,
                Value<DateTime?> documentDate = const Value.absent(),
                Value<String?> sourceLanguage = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DocumentsCompanion.insert(
                clientDocumentId: clientDocumentId,
                organizationId: organizationId,
                caseId: caseId,
                classificationState: classificationState,
                status: status,
                documentDate: documentDate,
                sourceLanguage: sourceLanguage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentsTable, Document>(table),
                  $$DocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                organizationId = false,
                caseId = false,
                documentFilesRefs = false,
                analysesRefs = false,
                sourceReferencesRefs = false,
                tasksRefs = false,
                deadlinesRefs = false,
                appointmentsRefs = false,
                amountsRefs = false,
                requiredDocumentsRefs = false,
                analysisOperationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (documentFilesRefs) db.documentFiles,
                    if (analysesRefs) db.analyses,
                    if (sourceReferencesRefs) db.sourceReferences,
                    if (tasksRefs) db.tasks,
                    if (deadlinesRefs) db.deadlines,
                    if (appointmentsRefs) db.appointments,
                    if (amountsRefs) db.amounts,
                    if (requiredDocumentsRefs) db.requiredDocuments,
                    if (analysisOperationsRefs) db.analysisOperations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (organizationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.organizationId,
                            referencedTable: $$DocumentsTableReferences
                                ._organizationIdTable(db),
                            referencedColumn: $$DocumentsTableReferences
                                ._organizationIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (caseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.caseId,
                            referencedTable: $$DocumentsTableReferences
                                ._caseIdTable(db),
                            referencedColumn: $$DocumentsTableReferences
                                ._caseIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (documentFilesRefs)
                        await $_getPrefetchedData<
                          Document,
                          $DocumentsTable,
                          DocumentFile
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._documentFilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).documentFilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.clientDocumentId == item.clientDocumentId,
                              ),
                          typedResults: items,
                        ),
                      if (analysesRefs)
                        await $_getPrefetchedData<
                          Document,
                          $DocumentsTable,
                          Analyse
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._analysesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).analysesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.clientDocumentId == item.clientDocumentId,
                              ),
                          typedResults: items,
                        ),
                      if (sourceReferencesRefs)
                        await $_getPrefetchedData<
                          Document,
                          $DocumentsTable,
                          SourceReference
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._sourceReferencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceReferencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.clientDocumentId == item.clientDocumentId,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          Document,
                          $DocumentsTable,
                          Task
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.clientDocumentId == item.clientDocumentId,
                              ),
                          typedResults: items,
                        ),
                      if (deadlinesRefs)
                        await $_getPrefetchedData<
                          Document,
                          $DocumentsTable,
                          Deadline
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._deadlinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).deadlinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.clientDocumentId == item.clientDocumentId,
                              ),
                          typedResults: items,
                        ),
                      if (appointmentsRefs)
                        await $_getPrefetchedData<
                          Document,
                          $DocumentsTable,
                          Appointment
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._appointmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.clientDocumentId == item.clientDocumentId,
                              ),
                          typedResults: items,
                        ),
                      if (amountsRefs)
                        await $_getPrefetchedData<
                          Document,
                          $DocumentsTable,
                          Amount
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._amountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).amountsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.clientDocumentId == item.clientDocumentId,
                              ),
                          typedResults: items,
                        ),
                      if (requiredDocumentsRefs)
                        await $_getPrefetchedData<
                          Document,
                          $DocumentsTable,
                          RequiredDocument
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._requiredDocumentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).requiredDocumentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.clientDocumentId == item.clientDocumentId,
                              ),
                          typedResults: items,
                        ),
                      if (analysisOperationsRefs)
                        await $_getPrefetchedData<
                          Document,
                          $DocumentsTable,
                          AnalysisOperation
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._analysisOperationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisOperationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.clientDocumentId == item.clientDocumentId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentsTable,
      Document,
      $$DocumentsTableFilterComposer,
      $$DocumentsTableOrderingComposer,
      $$DocumentsTableAnnotationComposer,
      $$DocumentsTableCreateCompanionBuilder,
      $$DocumentsTableUpdateCompanionBuilder,
      (Document, $$DocumentsTableReferences),
      Document,
      PrefetchHooks Function({
        bool organizationId,
        bool caseId,
        bool documentFilesRefs,
        bool analysesRefs,
        bool sourceReferencesRefs,
        bool tasksRefs,
        bool deadlinesRefs,
        bool appointmentsRefs,
        bool amountsRefs,
        bool requiredDocumentsRefs,
        bool analysisOperationsRefs,
      })
    >;
typedef $$DocumentFilesTableCreateCompanionBuilder =
    DocumentFilesCompanion Function({
      required String id,
      required String clientDocumentId,
      required String localUri,
      required String mediaType,
      Value<String?> originalFilename,
      Value<int?> byteSize,
      required DateTime importedAt,
      Value<int> pageOrder,
      Value<String> importSource,
      Value<int> rowid,
    });
typedef $$DocumentFilesTableUpdateCompanionBuilder =
    DocumentFilesCompanion Function({
      Value<String> id,
      Value<String> clientDocumentId,
      Value<String> localUri,
      Value<String> mediaType,
      Value<String?> originalFilename,
      Value<int?> byteSize,
      Value<DateTime> importedAt,
      Value<int> pageOrder,
      Value<String> importSource,
      Value<int> rowid,
    });

final class $$DocumentFilesTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentFilesTable, DocumentFile> {
  $$DocumentFilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DocumentsTable _clientDocumentIdTable(_$AppDatabase db) =>
      db.documents.createAlias(
        'document_files__client_document_id__documents__client_document_id',
      );

  $$DocumentsTableProcessedTableManager get clientDocumentId {
    final $_column = $_itemColumn<String>('client_document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.clientDocumentId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SourceReferencesTable, List<SourceReference>>
  _sourceReferencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceReferences,
    aliasName: 'document_files__id__source_references__file_id',
  );

  $$SourceReferencesTableProcessedTableManager get sourceReferencesRefs {
    final manager = $$SourceReferencesTableTableManager(
      $_db,
      $_db.sourceReferences,
    ).filter((f) => f.fileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sourceReferencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DocumentFilesTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentFilesTable> {
  $$DocumentFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localUri => $composableBuilder(
    column: $table.localUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageOrder => $composableBuilder(
    column: $table.pageOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get clientDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sourceReferencesRefs(
    Expression<bool> Function($$SourceReferencesTableFilterComposer f) f,
  ) {
    final $$SourceReferencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceReferences,
      getReferencedColumn: (t) => t.fileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceReferencesTableFilterComposer(
            $db: $db,
            $table: $db.sourceReferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentFilesTable> {
  $$DocumentFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localUri => $composableBuilder(
    column: $table.localUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageOrder => $composableBuilder(
    column: $table.pageOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get clientDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentFilesTable> {
  $$DocumentFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localUri =>
      $composableBuilder(column: $table.localUri, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => column,
  );

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageOrder =>
      $composableBuilder(column: $table.pageOrder, builder: (column) => column);

  GeneratedColumn<String> get importSource => $composableBuilder(
    column: $table.importSource,
    builder: (column) => column,
  );

  $$DocumentsTableAnnotationComposer get clientDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sourceReferencesRefs<T extends Object>(
    Expression<T> Function($$SourceReferencesTableAnnotationComposer a) f,
  ) {
    final $$SourceReferencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceReferences,
      getReferencedColumn: (t) => t.fileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceReferencesTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceReferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentFilesTable,
          DocumentFile,
          $$DocumentFilesTableFilterComposer,
          $$DocumentFilesTableOrderingComposer,
          $$DocumentFilesTableAnnotationComposer,
          $$DocumentFilesTableCreateCompanionBuilder,
          $$DocumentFilesTableUpdateCompanionBuilder,
          (DocumentFile, $$DocumentFilesTableReferences),
          DocumentFile,
          PrefetchHooks Function({
            bool clientDocumentId,
            bool sourceReferencesRefs,
          })
        > {
  $$DocumentFilesTableTableManager(_$AppDatabase db, $DocumentFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientDocumentId = const Value.absent(),
                Value<String> localUri = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String?> originalFilename = const Value.absent(),
                Value<int?> byteSize = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<int> pageOrder = const Value.absent(),
                Value<String> importSource = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentFilesCompanion(
                id: id,
                clientDocumentId: clientDocumentId,
                localUri: localUri,
                mediaType: mediaType,
                originalFilename: originalFilename,
                byteSize: byteSize,
                importedAt: importedAt,
                pageOrder: pageOrder,
                importSource: importSource,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientDocumentId,
                required String localUri,
                required String mediaType,
                Value<String?> originalFilename = const Value.absent(),
                Value<int?> byteSize = const Value.absent(),
                required DateTime importedAt,
                Value<int> pageOrder = const Value.absent(),
                Value<String> importSource = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentFilesCompanion.insert(
                id: id,
                clientDocumentId: clientDocumentId,
                localUri: localUri,
                mediaType: mediaType,
                originalFilename: originalFilename,
                byteSize: byteSize,
                importedAt: importedAt,
                pageOrder: pageOrder,
                importSource: importSource,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentFilesTable, DocumentFile>(table),
                  $$DocumentFilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({clientDocumentId = false, sourceReferencesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceReferencesRefs) db.sourceReferences,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clientDocumentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.clientDocumentId,
                            referencedTable: $$DocumentFilesTableReferences
                                ._clientDocumentIdTable(db),
                            referencedColumn: $$DocumentFilesTableReferences
                                ._clientDocumentIdTable(db)
                                .clientDocumentId,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sourceReferencesRefs)
                        await $_getPrefetchedData<
                          DocumentFile,
                          $DocumentFilesTable,
                          SourceReference
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentFilesTableReferences
                              ._sourceReferencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentFilesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceReferencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DocumentFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentFilesTable,
      DocumentFile,
      $$DocumentFilesTableFilterComposer,
      $$DocumentFilesTableOrderingComposer,
      $$DocumentFilesTableAnnotationComposer,
      $$DocumentFilesTableCreateCompanionBuilder,
      $$DocumentFilesTableUpdateCompanionBuilder,
      (DocumentFile, $$DocumentFilesTableReferences),
      DocumentFile,
      PrefetchHooks Function({bool clientDocumentId, bool sourceReferencesRefs})
    >;
typedef $$AnalysesTableCreateCompanionBuilder = AnalysesCompanion Function({
  required String id,
  required String clientDocumentId,
  required String schemaVersion,
  required String targetLanguage,
  Value<String?> summary,
  Value<String?> explanation,
  required String state,
  Value<String> analysisStatus,
  Value<String?> actionRequired,
  Value<String?> documentDate,
  Value<String> detectedLanguage,
  Value<String> urgency,
  Value<double?> confidence,
  Value<String> explanationStyle,
  Value<String?> suggestedOrganizationName,
  Value<String?> suggestedDocumentType,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$AnalysesTableUpdateCompanionBuilder = AnalysesCompanion Function({
  Value<String> id,
  Value<String> clientDocumentId,
  Value<String> schemaVersion,
  Value<String> targetLanguage,
  Value<String?> summary,
  Value<String?> explanation,
  Value<String> state,
  Value<String> analysisStatus,
  Value<String?> actionRequired,
  Value<String?> documentDate,
  Value<String> detectedLanguage,
  Value<String> urgency,
  Value<double?> confidence,
  Value<String> explanationStyle,
  Value<String?> suggestedOrganizationName,
  Value<String?> suggestedDocumentType,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AnalysesTableReferences
    extends BaseReferences<_$AppDatabase, $AnalysesTable, Analyse> {
  $$AnalysesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DocumentsTable _clientDocumentIdTable(_$AppDatabase db) =>
      db.documents.createAlias(
        'analyses__client_document_id__documents__client_document_id',
      );

  $$DocumentsTableProcessedTableManager get clientDocumentId {
    final $_column = $_itemColumn<String>('client_document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.clientDocumentId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $AnalysisQualityReasonsTable,
    List<AnalysisQualityReason>
  >
  _analysisQualityReasonsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.analysisQualityReasons,
        aliasName: 'analyses__id__analysis_quality_reasons__analysis_id',
      );

  $$AnalysisQualityReasonsTableProcessedTableManager
  get analysisQualityReasonsRefs {
    final manager = $$AnalysisQualityReasonsTableTableManager(
      $_db,
      $_db.analysisQualityReasons,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _analysisQualityReasonsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AnalysisNextActionsTable,
    List<AnalysisNextAction>
  >
  _analysisNextActionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.analysisNextActions,
        aliasName: 'analyses__id__analysis_next_actions__analysis_id',
      );

  $$AnalysisNextActionsTableProcessedTableManager get analysisNextActionsRefs {
    final manager = $$AnalysisNextActionsTableTableManager(
      $_db,
      $_db.analysisNextActions,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _analysisNextActionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AnalysisUncertaintiesTable,
    List<AnalysisUncertainty>
  >
  _analysisUncertaintiesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.analysisUncertainties,
        aliasName: 'analyses__id__analysis_uncertainties__analysis_id',
      );

  $$AnalysisUncertaintiesTableProcessedTableManager
  get analysisUncertaintiesRefs {
    final manager = $$AnalysisUncertaintiesTableTableManager(
      $_db,
      $_db.analysisUncertainties,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _analysisUncertaintiesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AnalysisPracticalStatesTable,
    List<AnalysisPracticalState>
  >
  _analysisPracticalStatesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.analysisPracticalStates,
        aliasName: 'analyses__id__analysis_practical_states__analysis_id',
      );

  $$AnalysisPracticalStatesTableProcessedTableManager
  get analysisPracticalStatesRefs {
    final manager = $$AnalysisPracticalStatesTableTableManager(
      $_db,
      $_db.analysisPracticalStates,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _analysisPracticalStatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnalysisDeadlinesTable, List<AnalysisDeadline>>
  _analysisDeadlinesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.analysisDeadlines,
        aliasName: 'analyses__id__analysis_deadlines__analysis_id',
      );

  $$AnalysisDeadlinesTableProcessedTableManager get analysisDeadlinesRefs {
    final manager = $$AnalysisDeadlinesTableTableManager(
      $_db,
      $_db.analysisDeadlines,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _analysisDeadlinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AnalysisAppointmentsTable,
    List<AnalysisAppointment>
  >
  _analysisAppointmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.analysisAppointments,
        aliasName: 'analyses__id__analysis_appointments__analysis_id',
      );

  $$AnalysisAppointmentsTableProcessedTableManager
  get analysisAppointmentsRefs {
    final manager = $$AnalysisAppointmentsTableTableManager(
      $_db,
      $_db.analysisAppointments,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _analysisAppointmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnalysisAmountsTable, List<AnalysisAmount>>
  _analysisAmountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.analysisAmounts,
    aliasName: 'analyses__id__analysis_amounts__analysis_id',
  );

  $$AnalysisAmountsTableProcessedTableManager get analysisAmountsRefs {
    final manager = $$AnalysisAmountsTableTableManager(
      $_db,
      $_db.analysisAmounts,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _analysisAmountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AnalysisRequiredDocumentsTable,
    List<AnalysisRequiredDocument>
  >
  _analysisRequiredDocumentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.analysisRequiredDocuments,
        aliasName: 'analyses__id__analysis_required_documents__analysis_id',
      );

  $$AnalysisRequiredDocumentsTableProcessedTableManager
  get analysisRequiredDocumentsRefs {
    final manager = $$AnalysisRequiredDocumentsTableTableManager(
      $_db,
      $_db.analysisRequiredDocuments,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _analysisRequiredDocumentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AnalysisSuggestedTasksTable,
    List<AnalysisSuggestedTask>
  >
  _analysisSuggestedTasksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.analysisSuggestedTasks,
        aliasName: 'analyses__id__analysis_suggested_tasks__analysis_id',
      );

  $$AnalysisSuggestedTasksTableProcessedTableManager
  get analysisSuggestedTasksRefs {
    final manager = $$AnalysisSuggestedTasksTableTableManager(
      $_db,
      $_db.analysisSuggestedTasks,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _analysisSuggestedTasksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SourceReferencesTable, List<SourceReference>>
  _sourceReferencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceReferences,
    aliasName: 'analyses__id__source_references__analysis_id',
  );

  $$SourceReferencesTableProcessedTableManager get sourceReferencesRefs {
    final manager = $$SourceReferencesTableTableManager(
      $_db,
      $_db.sourceReferences,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sourceReferencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AnalysesTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysesTable> {
  $$AnalysesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get analysisStatus => $composableBuilder(
    column: $table.analysisStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionRequired => $composableBuilder(
    column: $table.actionRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentDate => $composableBuilder(
    column: $table.documentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detectedLanguage => $composableBuilder(
    column: $table.detectedLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urgency => $composableBuilder(
    column: $table.urgency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationStyle => $composableBuilder(
    column: $table.explanationStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedOrganizationName => $composableBuilder(
    column: $table.suggestedOrganizationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedDocumentType => $composableBuilder(
    column: $table.suggestedDocumentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get clientDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> analysisQualityReasonsRefs(
    Expression<bool> Function($$AnalysisQualityReasonsTableFilterComposer f) f,
  ) {
    final $$AnalysisQualityReasonsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisQualityReasons,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisQualityReasonsTableFilterComposer(
                $db: $db,
                $table: $db.analysisQualityReasons,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> analysisNextActionsRefs(
    Expression<bool> Function($$AnalysisNextActionsTableFilterComposer f) f,
  ) {
    final $$AnalysisNextActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.analysisNextActions,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysisNextActionsTableFilterComposer(
            $db: $db,
            $table: $db.analysisNextActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> analysisUncertaintiesRefs(
    Expression<bool> Function($$AnalysisUncertaintiesTableFilterComposer f) f,
  ) {
    final $$AnalysisUncertaintiesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisUncertainties,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisUncertaintiesTableFilterComposer(
                $db: $db,
                $table: $db.analysisUncertainties,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> analysisPracticalStatesRefs(
    Expression<bool> Function($$AnalysisPracticalStatesTableFilterComposer f) f,
  ) {
    final $$AnalysisPracticalStatesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisPracticalStates,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisPracticalStatesTableFilterComposer(
                $db: $db,
                $table: $db.analysisPracticalStates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> analysisDeadlinesRefs(
    Expression<bool> Function($$AnalysisDeadlinesTableFilterComposer f) f,
  ) {
    final $$AnalysisDeadlinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.analysisDeadlines,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysisDeadlinesTableFilterComposer(
            $db: $db,
            $table: $db.analysisDeadlines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> analysisAppointmentsRefs(
    Expression<bool> Function($$AnalysisAppointmentsTableFilterComposer f) f,
  ) {
    final $$AnalysisAppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.analysisAppointments,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysisAppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.analysisAppointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> analysisAmountsRefs(
    Expression<bool> Function($$AnalysisAmountsTableFilterComposer f) f,
  ) {
    final $$AnalysisAmountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.analysisAmounts,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysisAmountsTableFilterComposer(
            $db: $db,
            $table: $db.analysisAmounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> analysisRequiredDocumentsRefs(
    Expression<bool> Function($$AnalysisRequiredDocumentsTableFilterComposer f)
    f,
  ) {
    final $$AnalysisRequiredDocumentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisRequiredDocuments,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisRequiredDocumentsTableFilterComposer(
                $db: $db,
                $table: $db.analysisRequiredDocuments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> analysisSuggestedTasksRefs(
    Expression<bool> Function($$AnalysisSuggestedTasksTableFilterComposer f) f,
  ) {
    final $$AnalysisSuggestedTasksTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisSuggestedTasks,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisSuggestedTasksTableFilterComposer(
                $db: $db,
                $table: $db.analysisSuggestedTasks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> sourceReferencesRefs(
    Expression<bool> Function($$SourceReferencesTableFilterComposer f) f,
  ) {
    final $$SourceReferencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceReferences,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceReferencesTableFilterComposer(
            $db: $db,
            $table: $db.sourceReferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnalysesTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysesTable> {
  $$AnalysesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get analysisStatus => $composableBuilder(
    column: $table.analysisStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionRequired => $composableBuilder(
    column: $table.actionRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentDate => $composableBuilder(
    column: $table.documentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detectedLanguage => $composableBuilder(
    column: $table.detectedLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urgency => $composableBuilder(
    column: $table.urgency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationStyle => $composableBuilder(
    column: $table.explanationStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedOrganizationName => $composableBuilder(
    column: $table.suggestedOrganizationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedDocumentType => $composableBuilder(
    column: $table.suggestedDocumentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get clientDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysesTable> {
  $$AnalysesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get analysisStatus => $composableBuilder(
    column: $table.analysisStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionRequired => $composableBuilder(
    column: $table.actionRequired,
    builder: (column) => column,
  );

  GeneratedColumn<String> get documentDate => $composableBuilder(
    column: $table.documentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get detectedLanguage => $composableBuilder(
    column: $table.detectedLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get urgency =>
      $composableBuilder(column: $table.urgency, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanationStyle => $composableBuilder(
    column: $table.explanationStyle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suggestedOrganizationName => $composableBuilder(
    column: $table.suggestedOrganizationName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suggestedDocumentType => $composableBuilder(
    column: $table.suggestedDocumentType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get clientDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> analysisQualityReasonsRefs<T extends Object>(
    Expression<T> Function($$AnalysisQualityReasonsTableAnnotationComposer a) f,
  ) {
    final $$AnalysisQualityReasonsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisQualityReasons,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisQualityReasonsTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisQualityReasons,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> analysisNextActionsRefs<T extends Object>(
    Expression<T> Function($$AnalysisNextActionsTableAnnotationComposer a) f,
  ) {
    final $$AnalysisNextActionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisNextActions,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisNextActionsTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisNextActions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> analysisUncertaintiesRefs<T extends Object>(
    Expression<T> Function($$AnalysisUncertaintiesTableAnnotationComposer a) f,
  ) {
    final $$AnalysisUncertaintiesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisUncertainties,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisUncertaintiesTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisUncertainties,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> analysisPracticalStatesRefs<T extends Object>(
    Expression<T> Function($$AnalysisPracticalStatesTableAnnotationComposer a)
    f,
  ) {
    final $$AnalysisPracticalStatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisPracticalStates,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisPracticalStatesTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisPracticalStates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> analysisDeadlinesRefs<T extends Object>(
    Expression<T> Function($$AnalysisDeadlinesTableAnnotationComposer a) f,
  ) {
    final $$AnalysisDeadlinesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisDeadlines,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisDeadlinesTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisDeadlines,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> analysisAppointmentsRefs<T extends Object>(
    Expression<T> Function($$AnalysisAppointmentsTableAnnotationComposer a) f,
  ) {
    final $$AnalysisAppointmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisAppointments,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisAppointmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisAppointments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> analysisAmountsRefs<T extends Object>(
    Expression<T> Function($$AnalysisAmountsTableAnnotationComposer a) f,
  ) {
    final $$AnalysisAmountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.analysisAmounts,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysisAmountsTableAnnotationComposer(
            $db: $db,
            $table: $db.analysisAmounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> analysisRequiredDocumentsRefs<T extends Object>(
    Expression<T> Function($$AnalysisRequiredDocumentsTableAnnotationComposer a)
    f,
  ) {
    final $$AnalysisRequiredDocumentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisRequiredDocuments,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisRequiredDocumentsTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisRequiredDocuments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> analysisSuggestedTasksRefs<T extends Object>(
    Expression<T> Function($$AnalysisSuggestedTasksTableAnnotationComposer a) f,
  ) {
    final $$AnalysisSuggestedTasksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisSuggestedTasks,
          getReferencedColumn: (t) => t.analysisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisSuggestedTasksTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisSuggestedTasks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> sourceReferencesRefs<T extends Object>(
    Expression<T> Function($$SourceReferencesTableAnnotationComposer a) f,
  ) {
    final $$SourceReferencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceReferences,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceReferencesTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceReferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnalysesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysesTable,
          Analyse,
          $$AnalysesTableFilterComposer,
          $$AnalysesTableOrderingComposer,
          $$AnalysesTableAnnotationComposer,
          $$AnalysesTableCreateCompanionBuilder,
          $$AnalysesTableUpdateCompanionBuilder,
          (Analyse, $$AnalysesTableReferences),
          Analyse,
          PrefetchHooks Function({
            bool clientDocumentId,
            bool analysisQualityReasonsRefs,
            bool analysisNextActionsRefs,
            bool analysisUncertaintiesRefs,
            bool analysisPracticalStatesRefs,
            bool analysisDeadlinesRefs,
            bool analysisAppointmentsRefs,
            bool analysisAmountsRefs,
            bool analysisRequiredDocumentsRefs,
            bool analysisSuggestedTasksRefs,
            bool sourceReferencesRefs,
          })
        > {
  $$AnalysesTableTableManager(_$AppDatabase db, $AnalysesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalysesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalysesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientDocumentId = const Value.absent(),
                Value<String> schemaVersion = const Value.absent(),
                Value<String> targetLanguage = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> analysisStatus = const Value.absent(),
                Value<String?> actionRequired = const Value.absent(),
                Value<String?> documentDate = const Value.absent(),
                Value<String> detectedLanguage = const Value.absent(),
                Value<String> urgency = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String> explanationStyle = const Value.absent(),
                Value<String?> suggestedOrganizationName = const Value.absent(),
                Value<String?> suggestedDocumentType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysesCompanion(
                id: id,
                clientDocumentId: clientDocumentId,
                schemaVersion: schemaVersion,
                targetLanguage: targetLanguage,
                summary: summary,
                explanation: explanation,
                state: state,
                analysisStatus: analysisStatus,
                actionRequired: actionRequired,
                documentDate: documentDate,
                detectedLanguage: detectedLanguage,
                urgency: urgency,
                confidence: confidence,
                explanationStyle: explanationStyle,
                suggestedOrganizationName: suggestedOrganizationName,
                suggestedDocumentType: suggestedDocumentType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientDocumentId,
                required String schemaVersion,
                required String targetLanguage,
                Value<String?> summary = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                required String state,
                Value<String> analysisStatus = const Value.absent(),
                Value<String?> actionRequired = const Value.absent(),
                Value<String?> documentDate = const Value.absent(),
                Value<String> detectedLanguage = const Value.absent(),
                Value<String> urgency = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String> explanationStyle = const Value.absent(),
                Value<String?> suggestedOrganizationName = const Value.absent(),
                Value<String?> suggestedDocumentType = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AnalysesCompanion.insert(
                id: id,
                clientDocumentId: clientDocumentId,
                schemaVersion: schemaVersion,
                targetLanguage: targetLanguage,
                summary: summary,
                explanation: explanation,
                state: state,
                analysisStatus: analysisStatus,
                actionRequired: actionRequired,
                documentDate: documentDate,
                detectedLanguage: detectedLanguage,
                urgency: urgency,
                confidence: confidence,
                explanationStyle: explanationStyle,
                suggestedOrganizationName: suggestedOrganizationName,
                suggestedDocumentType: suggestedDocumentType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnalysesTable, Analyse>(table),
                  $$AnalysesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clientDocumentId = false,
                analysisQualityReasonsRefs = false,
                analysisNextActionsRefs = false,
                analysisUncertaintiesRefs = false,
                analysisPracticalStatesRefs = false,
                analysisDeadlinesRefs = false,
                analysisAppointmentsRefs = false,
                analysisAmountsRefs = false,
                analysisRequiredDocumentsRefs = false,
                analysisSuggestedTasksRefs = false,
                sourceReferencesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (analysisQualityReasonsRefs) db.analysisQualityReasons,
                    if (analysisNextActionsRefs) db.analysisNextActions,
                    if (analysisUncertaintiesRefs) db.analysisUncertainties,
                    if (analysisPracticalStatesRefs) db.analysisPracticalStates,
                    if (analysisDeadlinesRefs) db.analysisDeadlines,
                    if (analysisAppointmentsRefs) db.analysisAppointments,
                    if (analysisAmountsRefs) db.analysisAmounts,
                    if (analysisRequiredDocumentsRefs)
                      db.analysisRequiredDocuments,
                    if (analysisSuggestedTasksRefs) db.analysisSuggestedTasks,
                    if (sourceReferencesRefs) db.sourceReferences,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clientDocumentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.clientDocumentId,
                            referencedTable: $$AnalysesTableReferences
                                ._clientDocumentIdTable(db),
                            referencedColumn: $$AnalysesTableReferences
                                ._clientDocumentIdTable(db)
                                .clientDocumentId,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (analysisQualityReasonsRefs)
                        await $_getPrefetchedData<
                          Analyse,
                          $AnalysesTable,
                          AnalysisQualityReason
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysesTableReferences
                              ._analysisQualityReasonsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisQualityReasonsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (analysisNextActionsRefs)
                        await $_getPrefetchedData<
                          Analyse,
                          $AnalysesTable,
                          AnalysisNextAction
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysesTableReferences
                              ._analysisNextActionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisNextActionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (analysisUncertaintiesRefs)
                        await $_getPrefetchedData<
                          Analyse,
                          $AnalysesTable,
                          AnalysisUncertainty
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysesTableReferences
                              ._analysisUncertaintiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisUncertaintiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (analysisPracticalStatesRefs)
                        await $_getPrefetchedData<
                          Analyse,
                          $AnalysesTable,
                          AnalysisPracticalState
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysesTableReferences
                              ._analysisPracticalStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisPracticalStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (analysisDeadlinesRefs)
                        await $_getPrefetchedData<
                          Analyse,
                          $AnalysesTable,
                          AnalysisDeadline
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysesTableReferences
                              ._analysisDeadlinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisDeadlinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (analysisAppointmentsRefs)
                        await $_getPrefetchedData<
                          Analyse,
                          $AnalysesTable,
                          AnalysisAppointment
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysesTableReferences
                              ._analysisAppointmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisAppointmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (analysisAmountsRefs)
                        await $_getPrefetchedData<
                          Analyse,
                          $AnalysesTable,
                          AnalysisAmount
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysesTableReferences
                              ._analysisAmountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisAmountsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (analysisRequiredDocumentsRefs)
                        await $_getPrefetchedData<
                          Analyse,
                          $AnalysesTable,
                          AnalysisRequiredDocument
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysesTableReferences
                              ._analysisRequiredDocumentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisRequiredDocumentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (analysisSuggestedTasksRefs)
                        await $_getPrefetchedData<
                          Analyse,
                          $AnalysesTable,
                          AnalysisSuggestedTask
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysesTableReferences
                              ._analysisSuggestedTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisSuggestedTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sourceReferencesRefs)
                        await $_getPrefetchedData<
                          Analyse,
                          $AnalysesTable,
                          SourceReference
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysesTableReferences
                              ._sourceReferencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceReferencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AnalysesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysesTable,
      Analyse,
      $$AnalysesTableFilterComposer,
      $$AnalysesTableOrderingComposer,
      $$AnalysesTableAnnotationComposer,
      $$AnalysesTableCreateCompanionBuilder,
      $$AnalysesTableUpdateCompanionBuilder,
      (Analyse, $$AnalysesTableReferences),
      Analyse,
      PrefetchHooks Function({
        bool clientDocumentId,
        bool analysisQualityReasonsRefs,
        bool analysisNextActionsRefs,
        bool analysisUncertaintiesRefs,
        bool analysisPracticalStatesRefs,
        bool analysisDeadlinesRefs,
        bool analysisAppointmentsRefs,
        bool analysisAmountsRefs,
        bool analysisRequiredDocumentsRefs,
        bool analysisSuggestedTasksRefs,
        bool sourceReferencesRefs,
      })
    >;
typedef $$AnalysisQualityReasonsTableCreateCompanionBuilder =
    AnalysisQualityReasonsCompanion Function({
      required String id,
      required String analysisId,
      required String reason,
      Value<int> rowid,
    });
typedef $$AnalysisQualityReasonsTableUpdateCompanionBuilder =
    AnalysisQualityReasonsCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<String> reason,
      Value<int> rowid,
    });

final class $$AnalysisQualityReasonsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnalysisQualityReasonsTable,
          AnalysisQualityReason
        > {
  $$AnalysisQualityReasonsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysesTable _analysisIdTable(_$AppDatabase db) => db.analyses
      .createAlias('analysis_quality_reasons__analysis_id__analyses__id');

  $$AnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AnalysesTableTableManager(
      $_db,
      $_db.analyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnalysisQualityReasonsTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisQualityReasonsTable> {
  $$AnalysisQualityReasonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysesTableFilterComposer get analysisId {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisQualityReasonsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisQualityReasonsTable> {
  $$AnalysisQualityReasonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysesTableOrderingComposer get analysisId {
    final $$AnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisQualityReasonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisQualityReasonsTable> {
  $$AnalysisQualityReasonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  $$AnalysesTableAnnotationComposer get analysisId {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisQualityReasonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisQualityReasonsTable,
          AnalysisQualityReason,
          $$AnalysisQualityReasonsTableFilterComposer,
          $$AnalysisQualityReasonsTableOrderingComposer,
          $$AnalysisQualityReasonsTableAnnotationComposer,
          $$AnalysisQualityReasonsTableCreateCompanionBuilder,
          $$AnalysisQualityReasonsTableUpdateCompanionBuilder,
          (AnalysisQualityReason, $$AnalysisQualityReasonsTableReferences),
          AnalysisQualityReason,
          PrefetchHooks Function({bool analysisId})
        > {
  $$AnalysisQualityReasonsTableTableManager(
    _$AppDatabase db,
    $AnalysisQualityReasonsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisQualityReasonsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AnalysisQualityReasonsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AnalysisQualityReasonsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisQualityReasonsCompanion(
                id: id,
                analysisId: analysisId,
                reason: reason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required String reason,
                Value<int> rowid = const Value.absent(),
              }) => AnalysisQualityReasonsCompanion.insert(
                id: id,
                analysisId: analysisId,
                reason: reason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $AnalysisQualityReasonsTable,
                    AnalysisQualityReason
                  >(table),
                  $$AnalysisQualityReasonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisId,
                        referencedTable: $$AnalysisQualityReasonsTableReferences
                            ._analysisIdTable(db),
                        referencedColumn:
                            $$AnalysisQualityReasonsTableReferences
                                ._analysisIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnalysisQualityReasonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisQualityReasonsTable,
      AnalysisQualityReason,
      $$AnalysisQualityReasonsTableFilterComposer,
      $$AnalysisQualityReasonsTableOrderingComposer,
      $$AnalysisQualityReasonsTableAnnotationComposer,
      $$AnalysisQualityReasonsTableCreateCompanionBuilder,
      $$AnalysisQualityReasonsTableUpdateCompanionBuilder,
      (AnalysisQualityReason, $$AnalysisQualityReasonsTableReferences),
      AnalysisQualityReason,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$AnalysisNextActionsTableCreateCompanionBuilder =
    AnalysisNextActionsCompanion Function({
      required String id,
      required String analysisId,
      required int position,
      required String value,
      Value<int> rowid,
    });
typedef $$AnalysisNextActionsTableUpdateCompanionBuilder =
    AnalysisNextActionsCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<int> position,
      Value<String> value,
      Value<int> rowid,
    });

final class $$AnalysisNextActionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnalysisNextActionsTable,
          AnalysisNextAction
        > {
  $$AnalysisNextActionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysesTable _analysisIdTable(_$AppDatabase db) => db.analyses
      .createAlias('analysis_next_actions__analysis_id__analyses__id');

  $$AnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AnalysesTableTableManager(
      $_db,
      $_db.analyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnalysisNextActionsTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisNextActionsTable> {
  $$AnalysisNextActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysesTableFilterComposer get analysisId {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisNextActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisNextActionsTable> {
  $$AnalysisNextActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysesTableOrderingComposer get analysisId {
    final $$AnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisNextActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisNextActionsTable> {
  $$AnalysisNextActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$AnalysesTableAnnotationComposer get analysisId {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisNextActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisNextActionsTable,
          AnalysisNextAction,
          $$AnalysisNextActionsTableFilterComposer,
          $$AnalysisNextActionsTableOrderingComposer,
          $$AnalysisNextActionsTableAnnotationComposer,
          $$AnalysisNextActionsTableCreateCompanionBuilder,
          $$AnalysisNextActionsTableUpdateCompanionBuilder,
          (AnalysisNextAction, $$AnalysisNextActionsTableReferences),
          AnalysisNextAction,
          PrefetchHooks Function({bool analysisId})
        > {
  $$AnalysisNextActionsTableTableManager(
    _$AppDatabase db,
    $AnalysisNextActionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisNextActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalysisNextActionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AnalysisNextActionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisNextActionsCompanion(
                id: id,
                analysisId: analysisId,
                position: position,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required int position,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AnalysisNextActionsCompanion.insert(
                id: id,
                analysisId: analysisId,
                position: position,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnalysisNextActionsTable, AnalysisNextAction>(
                    table,
                  ),
                  $$AnalysisNextActionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisId,
                        referencedTable: $$AnalysisNextActionsTableReferences
                            ._analysisIdTable(db),
                        referencedColumn: $$AnalysisNextActionsTableReferences
                            ._analysisIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnalysisNextActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisNextActionsTable,
      AnalysisNextAction,
      $$AnalysisNextActionsTableFilterComposer,
      $$AnalysisNextActionsTableOrderingComposer,
      $$AnalysisNextActionsTableAnnotationComposer,
      $$AnalysisNextActionsTableCreateCompanionBuilder,
      $$AnalysisNextActionsTableUpdateCompanionBuilder,
      (AnalysisNextAction, $$AnalysisNextActionsTableReferences),
      AnalysisNextAction,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$AnalysisUncertaintiesTableCreateCompanionBuilder =
    AnalysisUncertaintiesCompanion Function({
      required String id,
      required String analysisId,
      required int position,
      required String message,
      Value<int> rowid,
    });
typedef $$AnalysisUncertaintiesTableUpdateCompanionBuilder =
    AnalysisUncertaintiesCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<int> position,
      Value<String> message,
      Value<int> rowid,
    });

final class $$AnalysisUncertaintiesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnalysisUncertaintiesTable,
          AnalysisUncertainty
        > {
  $$AnalysisUncertaintiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysesTable _analysisIdTable(_$AppDatabase db) => db.analyses
      .createAlias('analysis_uncertainties__analysis_id__analyses__id');

  $$AnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AnalysesTableTableManager(
      $_db,
      $_db.analyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnalysisUncertaintiesTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisUncertaintiesTable> {
  $$AnalysisUncertaintiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysesTableFilterComposer get analysisId {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisUncertaintiesTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisUncertaintiesTable> {
  $$AnalysisUncertaintiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysesTableOrderingComposer get analysisId {
    final $$AnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisUncertaintiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisUncertaintiesTable> {
  $$AnalysisUncertaintiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  $$AnalysesTableAnnotationComposer get analysisId {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisUncertaintiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisUncertaintiesTable,
          AnalysisUncertainty,
          $$AnalysisUncertaintiesTableFilterComposer,
          $$AnalysisUncertaintiesTableOrderingComposer,
          $$AnalysisUncertaintiesTableAnnotationComposer,
          $$AnalysisUncertaintiesTableCreateCompanionBuilder,
          $$AnalysisUncertaintiesTableUpdateCompanionBuilder,
          (AnalysisUncertainty, $$AnalysisUncertaintiesTableReferences),
          AnalysisUncertainty,
          PrefetchHooks Function({bool analysisId})
        > {
  $$AnalysisUncertaintiesTableTableManager(
    _$AppDatabase db,
    $AnalysisUncertaintiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisUncertaintiesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AnalysisUncertaintiesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AnalysisUncertaintiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisUncertaintiesCompanion(
                id: id,
                analysisId: analysisId,
                position: position,
                message: message,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required int position,
                required String message,
                Value<int> rowid = const Value.absent(),
              }) => AnalysisUncertaintiesCompanion.insert(
                id: id,
                analysisId: analysisId,
                position: position,
                message: message,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnalysisUncertaintiesTable, AnalysisUncertainty>(
                    table,
                  ),
                  $$AnalysisUncertaintiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisId,
                        referencedTable: $$AnalysisUncertaintiesTableReferences
                            ._analysisIdTable(db),
                        referencedColumn: $$AnalysisUncertaintiesTableReferences
                            ._analysisIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnalysisUncertaintiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisUncertaintiesTable,
      AnalysisUncertainty,
      $$AnalysisUncertaintiesTableFilterComposer,
      $$AnalysisUncertaintiesTableOrderingComposer,
      $$AnalysisUncertaintiesTableAnnotationComposer,
      $$AnalysisUncertaintiesTableCreateCompanionBuilder,
      $$AnalysisUncertaintiesTableUpdateCompanionBuilder,
      (AnalysisUncertainty, $$AnalysisUncertaintiesTableReferences),
      AnalysisUncertainty,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$AnalysisPracticalStatesTableCreateCompanionBuilder =
    AnalysisPracticalStatesCompanion Function({
      required String id,
      required String analysisId,
      required int position,
      required String state,
      Value<int> rowid,
    });
typedef $$AnalysisPracticalStatesTableUpdateCompanionBuilder =
    AnalysisPracticalStatesCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<int> position,
      Value<String> state,
      Value<int> rowid,
    });

final class $$AnalysisPracticalStatesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnalysisPracticalStatesTable,
          AnalysisPracticalState
        > {
  $$AnalysisPracticalStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysesTable _analysisIdTable(_$AppDatabase db) => db.analyses
      .createAlias('analysis_practical_states__analysis_id__analyses__id');

  $$AnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AnalysesTableTableManager(
      $_db,
      $_db.analyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnalysisPracticalStatesTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisPracticalStatesTable> {
  $$AnalysisPracticalStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysesTableFilterComposer get analysisId {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisPracticalStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisPracticalStatesTable> {
  $$AnalysisPracticalStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysesTableOrderingComposer get analysisId {
    final $$AnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisPracticalStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisPracticalStatesTable> {
  $$AnalysisPracticalStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  $$AnalysesTableAnnotationComposer get analysisId {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisPracticalStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisPracticalStatesTable,
          AnalysisPracticalState,
          $$AnalysisPracticalStatesTableFilterComposer,
          $$AnalysisPracticalStatesTableOrderingComposer,
          $$AnalysisPracticalStatesTableAnnotationComposer,
          $$AnalysisPracticalStatesTableCreateCompanionBuilder,
          $$AnalysisPracticalStatesTableUpdateCompanionBuilder,
          (AnalysisPracticalState, $$AnalysisPracticalStatesTableReferences),
          AnalysisPracticalState,
          PrefetchHooks Function({bool analysisId})
        > {
  $$AnalysisPracticalStatesTableTableManager(
    _$AppDatabase db,
    $AnalysisPracticalStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisPracticalStatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AnalysisPracticalStatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AnalysisPracticalStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisPracticalStatesCompanion(
                id: id,
                analysisId: analysisId,
                position: position,
                state: state,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required int position,
                required String state,
                Value<int> rowid = const Value.absent(),
              }) => AnalysisPracticalStatesCompanion.insert(
                id: id,
                analysisId: analysisId,
                position: position,
                state: state,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $AnalysisPracticalStatesTable,
                    AnalysisPracticalState
                  >(table),
                  $$AnalysisPracticalStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisId,
                        referencedTable:
                            $$AnalysisPracticalStatesTableReferences
                                ._analysisIdTable(db),
                        referencedColumn:
                            $$AnalysisPracticalStatesTableReferences
                                ._analysisIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnalysisPracticalStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisPracticalStatesTable,
      AnalysisPracticalState,
      $$AnalysisPracticalStatesTableFilterComposer,
      $$AnalysisPracticalStatesTableOrderingComposer,
      $$AnalysisPracticalStatesTableAnnotationComposer,
      $$AnalysisPracticalStatesTableCreateCompanionBuilder,
      $$AnalysisPracticalStatesTableUpdateCompanionBuilder,
      (AnalysisPracticalState, $$AnalysisPracticalStatesTableReferences),
      AnalysisPracticalState,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$AnalysisDeadlinesTableCreateCompanionBuilder =
    AnalysisDeadlinesCompanion Function({
      required String id,
      required String analysisId,
      required int position,
      required String label,
      Value<String?> dateOrRange,
      Value<double?> confidence,
      Value<String?> time,
      Value<String?> timezone,
      Value<String?> consequence,
      Value<String?> sourceReference,
      Value<int> rowid,
    });
typedef $$AnalysisDeadlinesTableUpdateCompanionBuilder =
    AnalysisDeadlinesCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<int> position,
      Value<String> label,
      Value<String?> dateOrRange,
      Value<double?> confidence,
      Value<String?> time,
      Value<String?> timezone,
      Value<String?> consequence,
      Value<String?> sourceReference,
      Value<int> rowid,
    });

final class $$AnalysisDeadlinesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnalysisDeadlinesTable,
          AnalysisDeadline
        > {
  $$AnalysisDeadlinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysesTable _analysisIdTable(_$AppDatabase db) =>
      db.analyses.createAlias('analysis_deadlines__analysis_id__analyses__id');

  $$AnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AnalysesTableTableManager(
      $_db,
      $_db.analyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnalysisDeadlinesTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisDeadlinesTable> {
  $$AnalysisDeadlinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateOrRange => $composableBuilder(
    column: $table.dateOrRange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get consequence => $composableBuilder(
    column: $table.consequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysesTableFilterComposer get analysisId {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisDeadlinesTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisDeadlinesTable> {
  $$AnalysisDeadlinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateOrRange => $composableBuilder(
    column: $table.dateOrRange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get consequence => $composableBuilder(
    column: $table.consequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysesTableOrderingComposer get analysisId {
    final $$AnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisDeadlinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisDeadlinesTable> {
  $$AnalysisDeadlinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get dateOrRange => $composableBuilder(
    column: $table.dateOrRange,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<String> get consequence => $composableBuilder(
    column: $table.consequence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => column,
  );

  $$AnalysesTableAnnotationComposer get analysisId {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisDeadlinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisDeadlinesTable,
          AnalysisDeadline,
          $$AnalysisDeadlinesTableFilterComposer,
          $$AnalysisDeadlinesTableOrderingComposer,
          $$AnalysisDeadlinesTableAnnotationComposer,
          $$AnalysisDeadlinesTableCreateCompanionBuilder,
          $$AnalysisDeadlinesTableUpdateCompanionBuilder,
          (AnalysisDeadline, $$AnalysisDeadlinesTableReferences),
          AnalysisDeadline,
          PrefetchHooks Function({bool analysisId})
        > {
  $$AnalysisDeadlinesTableTableManager(
    _$AppDatabase db,
    $AnalysisDeadlinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisDeadlinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalysisDeadlinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalysisDeadlinesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> dateOrRange = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> time = const Value.absent(),
                Value<String?> timezone = const Value.absent(),
                Value<String?> consequence = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisDeadlinesCompanion(
                id: id,
                analysisId: analysisId,
                position: position,
                label: label,
                dateOrRange: dateOrRange,
                confidence: confidence,
                time: time,
                timezone: timezone,
                consequence: consequence,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required int position,
                required String label,
                Value<String?> dateOrRange = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> time = const Value.absent(),
                Value<String?> timezone = const Value.absent(),
                Value<String?> consequence = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisDeadlinesCompanion.insert(
                id: id,
                analysisId: analysisId,
                position: position,
                label: label,
                dateOrRange: dateOrRange,
                confidence: confidence,
                time: time,
                timezone: timezone,
                consequence: consequence,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnalysisDeadlinesTable, AnalysisDeadline>(table),
                  $$AnalysisDeadlinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisId,
                        referencedTable: $$AnalysisDeadlinesTableReferences
                            ._analysisIdTable(db),
                        referencedColumn: $$AnalysisDeadlinesTableReferences
                            ._analysisIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnalysisDeadlinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisDeadlinesTable,
      AnalysisDeadline,
      $$AnalysisDeadlinesTableFilterComposer,
      $$AnalysisDeadlinesTableOrderingComposer,
      $$AnalysisDeadlinesTableAnnotationComposer,
      $$AnalysisDeadlinesTableCreateCompanionBuilder,
      $$AnalysisDeadlinesTableUpdateCompanionBuilder,
      (AnalysisDeadline, $$AnalysisDeadlinesTableReferences),
      AnalysisDeadline,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$AnalysisAppointmentsTableCreateCompanionBuilder =
    AnalysisAppointmentsCompanion Function({
      required String id,
      required String analysisId,
      required int position,
      required String label,
      Value<String?> startOrDate,
      Value<double?> confidence,
      Value<String?> end,
      Value<String?> location,
      Value<String?> preparation,
      Value<String?> sourceReference,
      Value<int> rowid,
    });
typedef $$AnalysisAppointmentsTableUpdateCompanionBuilder =
    AnalysisAppointmentsCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<int> position,
      Value<String> label,
      Value<String?> startOrDate,
      Value<double?> confidence,
      Value<String?> end,
      Value<String?> location,
      Value<String?> preparation,
      Value<String?> sourceReference,
      Value<int> rowid,
    });

final class $$AnalysisAppointmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnalysisAppointmentsTable,
          AnalysisAppointment
        > {
  $$AnalysisAppointmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysesTable _analysisIdTable(_$AppDatabase db) => db.analyses
      .createAlias('analysis_appointments__analysis_id__analyses__id');

  $$AnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AnalysesTableTableManager(
      $_db,
      $_db.analyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnalysisAppointmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisAppointmentsTable> {
  $$AnalysisAppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startOrDate => $composableBuilder(
    column: $table.startOrDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preparation => $composableBuilder(
    column: $table.preparation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysesTableFilterComposer get analysisId {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisAppointmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisAppointmentsTable> {
  $$AnalysisAppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startOrDate => $composableBuilder(
    column: $table.startOrDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preparation => $composableBuilder(
    column: $table.preparation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysesTableOrderingComposer get analysisId {
    final $$AnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisAppointmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisAppointmentsTable> {
  $$AnalysisAppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get startOrDate => $composableBuilder(
    column: $table.startOrDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get preparation => $composableBuilder(
    column: $table.preparation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => column,
  );

  $$AnalysesTableAnnotationComposer get analysisId {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisAppointmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisAppointmentsTable,
          AnalysisAppointment,
          $$AnalysisAppointmentsTableFilterComposer,
          $$AnalysisAppointmentsTableOrderingComposer,
          $$AnalysisAppointmentsTableAnnotationComposer,
          $$AnalysisAppointmentsTableCreateCompanionBuilder,
          $$AnalysisAppointmentsTableUpdateCompanionBuilder,
          (AnalysisAppointment, $$AnalysisAppointmentsTableReferences),
          AnalysisAppointment,
          PrefetchHooks Function({bool analysisId})
        > {
  $$AnalysisAppointmentsTableTableManager(
    _$AppDatabase db,
    $AnalysisAppointmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisAppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalysisAppointmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AnalysisAppointmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> startOrDate = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> end = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> preparation = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisAppointmentsCompanion(
                id: id,
                analysisId: analysisId,
                position: position,
                label: label,
                startOrDate: startOrDate,
                confidence: confidence,
                end: end,
                location: location,
                preparation: preparation,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required int position,
                required String label,
                Value<String?> startOrDate = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> end = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> preparation = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisAppointmentsCompanion.insert(
                id: id,
                analysisId: analysisId,
                position: position,
                label: label,
                startOrDate: startOrDate,
                confidence: confidence,
                end: end,
                location: location,
                preparation: preparation,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnalysisAppointmentsTable, AnalysisAppointment>(
                    table,
                  ),
                  $$AnalysisAppointmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisId,
                        referencedTable: $$AnalysisAppointmentsTableReferences
                            ._analysisIdTable(db),
                        referencedColumn: $$AnalysisAppointmentsTableReferences
                            ._analysisIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnalysisAppointmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisAppointmentsTable,
      AnalysisAppointment,
      $$AnalysisAppointmentsTableFilterComposer,
      $$AnalysisAppointmentsTableOrderingComposer,
      $$AnalysisAppointmentsTableAnnotationComposer,
      $$AnalysisAppointmentsTableCreateCompanionBuilder,
      $$AnalysisAppointmentsTableUpdateCompanionBuilder,
      (AnalysisAppointment, $$AnalysisAppointmentsTableReferences),
      AnalysisAppointment,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$AnalysisAmountsTableCreateCompanionBuilder =
    AnalysisAmountsCompanion Function({
      required String id,
      required String analysisId,
      required int position,
      required String value,
      required String currency,
      required String direction,
      Value<double?> confidence,
      Value<String?> dueDate,
      Value<String?> purpose,
      Value<String?> sourceReference,
      Value<int> rowid,
    });
typedef $$AnalysisAmountsTableUpdateCompanionBuilder =
    AnalysisAmountsCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<int> position,
      Value<String> value,
      Value<String> currency,
      Value<String> direction,
      Value<double?> confidence,
      Value<String?> dueDate,
      Value<String?> purpose,
      Value<String?> sourceReference,
      Value<int> rowid,
    });

final class $$AnalysisAmountsTableReferences
    extends
        BaseReferences<_$AppDatabase, $AnalysisAmountsTable, AnalysisAmount> {
  $$AnalysisAmountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysesTable _analysisIdTable(_$AppDatabase db) =>
      db.analyses.createAlias('analysis_amounts__analysis_id__analyses__id');

  $$AnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AnalysesTableTableManager(
      $_db,
      $_db.analyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnalysisAmountsTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisAmountsTable> {
  $$AnalysisAmountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysesTableFilterComposer get analysisId {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisAmountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisAmountsTable> {
  $$AnalysisAmountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysesTableOrderingComposer get analysisId {
    final $$AnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisAmountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisAmountsTable> {
  $$AnalysisAmountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => column,
  );

  $$AnalysesTableAnnotationComposer get analysisId {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisAmountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisAmountsTable,
          AnalysisAmount,
          $$AnalysisAmountsTableFilterComposer,
          $$AnalysisAmountsTableOrderingComposer,
          $$AnalysisAmountsTableAnnotationComposer,
          $$AnalysisAmountsTableCreateCompanionBuilder,
          $$AnalysisAmountsTableUpdateCompanionBuilder,
          (AnalysisAmount, $$AnalysisAmountsTableReferences),
          AnalysisAmount,
          PrefetchHooks Function({bool analysisId})
        > {
  $$AnalysisAmountsTableTableManager(
    _$AppDatabase db,
    $AnalysisAmountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisAmountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalysisAmountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalysisAmountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisAmountsCompanion(
                id: id,
                analysisId: analysisId,
                position: position,
                value: value,
                currency: currency,
                direction: direction,
                confidence: confidence,
                dueDate: dueDate,
                purpose: purpose,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required int position,
                required String value,
                required String currency,
                required String direction,
                Value<double?> confidence = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisAmountsCompanion.insert(
                id: id,
                analysisId: analysisId,
                position: position,
                value: value,
                currency: currency,
                direction: direction,
                confidence: confidence,
                dueDate: dueDate,
                purpose: purpose,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnalysisAmountsTable, AnalysisAmount>(table),
                  $$AnalysisAmountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisId,
                        referencedTable: $$AnalysisAmountsTableReferences
                            ._analysisIdTable(db),
                        referencedColumn: $$AnalysisAmountsTableReferences
                            ._analysisIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnalysisAmountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisAmountsTable,
      AnalysisAmount,
      $$AnalysisAmountsTableFilterComposer,
      $$AnalysisAmountsTableOrderingComposer,
      $$AnalysisAmountsTableAnnotationComposer,
      $$AnalysisAmountsTableCreateCompanionBuilder,
      $$AnalysisAmountsTableUpdateCompanionBuilder,
      (AnalysisAmount, $$AnalysisAmountsTableReferences),
      AnalysisAmount,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$AnalysisRequiredDocumentsTableCreateCompanionBuilder =
    AnalysisRequiredDocumentsCompanion Function({
      required String id,
      required String analysisId,
      required int position,
      required String description,
      Value<double?> confidence,
      Value<String?> dueDate,
      Value<String?> submissionMethod,
      Value<String?> sourceReference,
      Value<int> rowid,
    });
typedef $$AnalysisRequiredDocumentsTableUpdateCompanionBuilder =
    AnalysisRequiredDocumentsCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<int> position,
      Value<String> description,
      Value<double?> confidence,
      Value<String?> dueDate,
      Value<String?> submissionMethod,
      Value<String?> sourceReference,
      Value<int> rowid,
    });

final class $$AnalysisRequiredDocumentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnalysisRequiredDocumentsTable,
          AnalysisRequiredDocument
        > {
  $$AnalysisRequiredDocumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysesTable _analysisIdTable(_$AppDatabase db) => db.analyses
      .createAlias('analysis_required_documents__analysis_id__analyses__id');

  $$AnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AnalysesTableTableManager(
      $_db,
      $_db.analyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnalysisRequiredDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisRequiredDocumentsTable> {
  $$AnalysisRequiredDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get submissionMethod => $composableBuilder(
    column: $table.submissionMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysesTableFilterComposer get analysisId {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisRequiredDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisRequiredDocumentsTable> {
  $$AnalysisRequiredDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get submissionMethod => $composableBuilder(
    column: $table.submissionMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysesTableOrderingComposer get analysisId {
    final $$AnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisRequiredDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisRequiredDocumentsTable> {
  $$AnalysisRequiredDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get submissionMethod => $composableBuilder(
    column: $table.submissionMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => column,
  );

  $$AnalysesTableAnnotationComposer get analysisId {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisRequiredDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisRequiredDocumentsTable,
          AnalysisRequiredDocument,
          $$AnalysisRequiredDocumentsTableFilterComposer,
          $$AnalysisRequiredDocumentsTableOrderingComposer,
          $$AnalysisRequiredDocumentsTableAnnotationComposer,
          $$AnalysisRequiredDocumentsTableCreateCompanionBuilder,
          $$AnalysisRequiredDocumentsTableUpdateCompanionBuilder,
          (
            AnalysisRequiredDocument,
            $$AnalysisRequiredDocumentsTableReferences,
          ),
          AnalysisRequiredDocument,
          PrefetchHooks Function({bool analysisId})
        > {
  $$AnalysisRequiredDocumentsTableTableManager(
    _$AppDatabase db,
    $AnalysisRequiredDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisRequiredDocumentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AnalysisRequiredDocumentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AnalysisRequiredDocumentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> submissionMethod = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisRequiredDocumentsCompanion(
                id: id,
                analysisId: analysisId,
                position: position,
                description: description,
                confidence: confidence,
                dueDate: dueDate,
                submissionMethod: submissionMethod,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required int position,
                required String description,
                Value<double?> confidence = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> submissionMethod = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisRequiredDocumentsCompanion.insert(
                id: id,
                analysisId: analysisId,
                position: position,
                description: description,
                confidence: confidence,
                dueDate: dueDate,
                submissionMethod: submissionMethod,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $AnalysisRequiredDocumentsTable,
                    AnalysisRequiredDocument
                  >(table),
                  $$AnalysisRequiredDocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisId,
                        referencedTable:
                            $$AnalysisRequiredDocumentsTableReferences
                                ._analysisIdTable(db),
                        referencedColumn:
                            $$AnalysisRequiredDocumentsTableReferences
                                ._analysisIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnalysisRequiredDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisRequiredDocumentsTable,
      AnalysisRequiredDocument,
      $$AnalysisRequiredDocumentsTableFilterComposer,
      $$AnalysisRequiredDocumentsTableOrderingComposer,
      $$AnalysisRequiredDocumentsTableAnnotationComposer,
      $$AnalysisRequiredDocumentsTableCreateCompanionBuilder,
      $$AnalysisRequiredDocumentsTableUpdateCompanionBuilder,
      (AnalysisRequiredDocument, $$AnalysisRequiredDocumentsTableReferences),
      AnalysisRequiredDocument,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$AnalysisSuggestedTasksTableCreateCompanionBuilder =
    AnalysisSuggestedTasksCompanion Function({
      required String id,
      required String analysisId,
      required int position,
      required String title,
      Value<double?> confidence,
      Value<String?> dueDate,
      Value<String?> instructions,
      Value<String?> sourceReference,
      Value<int> rowid,
    });
typedef $$AnalysisSuggestedTasksTableUpdateCompanionBuilder =
    AnalysisSuggestedTasksCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<int> position,
      Value<String> title,
      Value<double?> confidence,
      Value<String?> dueDate,
      Value<String?> instructions,
      Value<String?> sourceReference,
      Value<int> rowid,
    });

final class $$AnalysisSuggestedTasksTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnalysisSuggestedTasksTable,
          AnalysisSuggestedTask
        > {
  $$AnalysisSuggestedTasksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysesTable _analysisIdTable(_$AppDatabase db) => db.analyses
      .createAlias('analysis_suggested_tasks__analysis_id__analyses__id');

  $$AnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AnalysesTableTableManager(
      $_db,
      $_db.analyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnalysisSuggestedTasksTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisSuggestedTasksTable> {
  $$AnalysisSuggestedTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysesTableFilterComposer get analysisId {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisSuggestedTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisSuggestedTasksTable> {
  $$AnalysisSuggestedTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysesTableOrderingComposer get analysisId {
    final $$AnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisSuggestedTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisSuggestedTasksTable> {
  $$AnalysisSuggestedTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => column,
  );

  $$AnalysesTableAnnotationComposer get analysisId {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisSuggestedTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisSuggestedTasksTable,
          AnalysisSuggestedTask,
          $$AnalysisSuggestedTasksTableFilterComposer,
          $$AnalysisSuggestedTasksTableOrderingComposer,
          $$AnalysisSuggestedTasksTableAnnotationComposer,
          $$AnalysisSuggestedTasksTableCreateCompanionBuilder,
          $$AnalysisSuggestedTasksTableUpdateCompanionBuilder,
          (AnalysisSuggestedTask, $$AnalysisSuggestedTasksTableReferences),
          AnalysisSuggestedTask,
          PrefetchHooks Function({bool analysisId})
        > {
  $$AnalysisSuggestedTasksTableTableManager(
    _$AppDatabase db,
    $AnalysisSuggestedTasksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisSuggestedTasksTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AnalysisSuggestedTasksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AnalysisSuggestedTasksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisSuggestedTasksCompanion(
                id: id,
                analysisId: analysisId,
                position: position,
                title: title,
                confidence: confidence,
                dueDate: dueDate,
                instructions: instructions,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required int position,
                required String title,
                Value<double?> confidence = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisSuggestedTasksCompanion.insert(
                id: id,
                analysisId: analysisId,
                position: position,
                title: title,
                confidence: confidence,
                dueDate: dueDate,
                instructions: instructions,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $AnalysisSuggestedTasksTable,
                    AnalysisSuggestedTask
                  >(table),
                  $$AnalysisSuggestedTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisId,
                        referencedTable: $$AnalysisSuggestedTasksTableReferences
                            ._analysisIdTable(db),
                        referencedColumn:
                            $$AnalysisSuggestedTasksTableReferences
                                ._analysisIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnalysisSuggestedTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisSuggestedTasksTable,
      AnalysisSuggestedTask,
      $$AnalysisSuggestedTasksTableFilterComposer,
      $$AnalysisSuggestedTasksTableOrderingComposer,
      $$AnalysisSuggestedTasksTableAnnotationComposer,
      $$AnalysisSuggestedTasksTableCreateCompanionBuilder,
      $$AnalysisSuggestedTasksTableUpdateCompanionBuilder,
      (AnalysisSuggestedTask, $$AnalysisSuggestedTasksTableReferences),
      AnalysisSuggestedTask,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$SourceReferencesTableCreateCompanionBuilder =
    SourceReferencesCompanion Function({
      required String id,
      required String analysisId,
      required String clientDocumentId,
      Value<String?> fileId,
      Value<int?> pageNumber,
      Value<String?> excerptLabel,
      Value<int> rowid,
    });
typedef $$SourceReferencesTableUpdateCompanionBuilder =
    SourceReferencesCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<String> clientDocumentId,
      Value<String?> fileId,
      Value<int?> pageNumber,
      Value<String?> excerptLabel,
      Value<int> rowid,
    });

final class $$SourceReferencesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SourceReferencesTable, SourceReference> {
  $$SourceReferencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysesTable _analysisIdTable(_$AppDatabase db) =>
      db.analyses.createAlias('source_references__analysis_id__analyses__id');

  $$AnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AnalysesTableTableManager(
      $_db,
      $_db.analyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DocumentsTable _clientDocumentIdTable(_$AppDatabase db) =>
      db.documents.createAlias(
        'source_references__client_document_id__documents__client_document_id',
      );

  $$DocumentsTableProcessedTableManager get clientDocumentId {
    final $_column = $_itemColumn<String>('client_document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.clientDocumentId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DocumentFilesTable _fileIdTable(_$AppDatabase db) => db.documentFiles
      .createAlias('source_references__file_id__document_files__id');

  $$DocumentFilesTableProcessedTableManager? get fileId {
    final $_column = $_itemColumn<String>('file_id');
    if ($_column == null) return null;
    final manager = $$DocumentFilesTableTableManager(
      $_db,
      $_db.documentFiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SourceReferencesTableFilterComposer
    extends Composer<_$AppDatabase, $SourceReferencesTable> {
  $$SourceReferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get excerptLabel => $composableBuilder(
    column: $table.excerptLabel,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysesTableFilterComposer get analysisId {
    final $$AnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableFilterComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentsTableFilterComposer get clientDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentFilesTableFilterComposer get fileId {
    final $$DocumentFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fileId,
      referencedTable: $db.documentFiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFilesTableFilterComposer(
            $db: $db,
            $table: $db.documentFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceReferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceReferencesTable> {
  $$SourceReferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get excerptLabel => $composableBuilder(
    column: $table.excerptLabel,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysesTableOrderingComposer get analysisId {
    final $$AnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentsTableOrderingComposer get clientDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentFilesTableOrderingComposer get fileId {
    final $$DocumentFilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fileId,
      referencedTable: $db.documentFiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFilesTableOrderingComposer(
            $db: $db,
            $table: $db.documentFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceReferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceReferencesTable> {
  $$SourceReferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get excerptLabel => $composableBuilder(
    column: $table.excerptLabel,
    builder: (column) => column,
  );

  $$AnalysesTableAnnotationComposer get analysisId {
    final $$AnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.analyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.analyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentsTableAnnotationComposer get clientDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentFilesTableAnnotationComposer get fileId {
    final $$DocumentFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fileId,
      referencedTable: $db.documentFiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.documentFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceReferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceReferencesTable,
          SourceReference,
          $$SourceReferencesTableFilterComposer,
          $$SourceReferencesTableOrderingComposer,
          $$SourceReferencesTableAnnotationComposer,
          $$SourceReferencesTableCreateCompanionBuilder,
          $$SourceReferencesTableUpdateCompanionBuilder,
          (SourceReference, $$SourceReferencesTableReferences),
          SourceReference,
          PrefetchHooks Function({
            bool analysisId,
            bool clientDocumentId,
            bool fileId,
          })
        > {
  $$SourceReferencesTableTableManager(
    _$AppDatabase db,
    $SourceReferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceReferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceReferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceReferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<String> clientDocumentId = const Value.absent(),
                Value<String?> fileId = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<String?> excerptLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceReferencesCompanion(
                id: id,
                analysisId: analysisId,
                clientDocumentId: clientDocumentId,
                fileId: fileId,
                pageNumber: pageNumber,
                excerptLabel: excerptLabel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required String clientDocumentId,
                Value<String?> fileId = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<String?> excerptLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceReferencesCompanion.insert(
                id: id,
                analysisId: analysisId,
                clientDocumentId: clientDocumentId,
                fileId: fileId,
                pageNumber: pageNumber,
                excerptLabel: excerptLabel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceReferencesTable, SourceReference>(table),
                  $$SourceReferencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({analysisId = false, clientDocumentId = false, fileId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (analysisId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.analysisId,
                            referencedTable: $$SourceReferencesTableReferences
                                ._analysisIdTable(db),
                            referencedColumn: $$SourceReferencesTableReferences
                                ._analysisIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (clientDocumentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.clientDocumentId,
                            referencedTable: $$SourceReferencesTableReferences
                                ._clientDocumentIdTable(db),
                            referencedColumn: $$SourceReferencesTableReferences
                                ._clientDocumentIdTable(db)
                                .clientDocumentId,
                          ) as T;
                        }
                        if (fileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.fileId,
                            referencedTable: $$SourceReferencesTableReferences
                                ._fileIdTable(db),
                            referencedColumn: $$SourceReferencesTableReferences
                                ._fileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$SourceReferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceReferencesTable,
      SourceReference,
      $$SourceReferencesTableFilterComposer,
      $$SourceReferencesTableOrderingComposer,
      $$SourceReferencesTableAnnotationComposer,
      $$SourceReferencesTableCreateCompanionBuilder,
      $$SourceReferencesTableUpdateCompanionBuilder,
      (SourceReference, $$SourceReferencesTableReferences),
      SourceReference,
      PrefetchHooks Function({
        bool analysisId,
        bool clientDocumentId,
        bool fileId,
      })
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  Value<String?> clientDocumentId,
  Value<String?> caseId,
  required String title,
  Value<DateTime?> dueAt,
  required String status,
  required String provenance,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String?> clientDocumentId,
  Value<String?> caseId,
  Value<String> title,
  Value<DateTime?> dueAt,
  Value<String> status,
  Value<String> provenance,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DocumentsTable _clientDocumentIdTable(_$AppDatabase db) => db
      .documents
      .createAlias('tasks__client_document_id__documents__client_document_id');

  $$DocumentsTableProcessedTableManager? get clientDocumentId {
    final $_column = $_itemColumn<String>('client_document_id');
    if ($_column == null) return null;
    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.clientDocumentId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CasesTable _caseIdTable(_$AppDatabase db) =>
      db.cases.createAlias('tasks__case_id__cases__id');

  $$CasesTableProcessedTableManager? get caseId {
    final $_column = $_itemColumn<String>('case_id');
    if ($_column == null) return null;
    final manager = $$CasesTableTableManager(
      $_db,
      $_db.cases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get clientDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CasesTableFilterComposer get caseId {
    final $$CasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableFilterComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get clientDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CasesTableOrderingComposer get caseId {
    final $$CasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableOrderingComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get clientDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CasesTableAnnotationComposer get caseId {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({bool clientDocumentId, bool caseId})
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> clientDocumentId = const Value.absent(),
                Value<String?> caseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                clientDocumentId: clientDocumentId,
                caseId: caseId,
                title: title,
                dueAt: dueAt,
                status: status,
                provenance: provenance,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> clientDocumentId = const Value.absent(),
                Value<String?> caseId = const Value.absent(),
                required String title,
                Value<DateTime?> dueAt = const Value.absent(),
                required String status,
                required String provenance,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                clientDocumentId: clientDocumentId,
                caseId: caseId,
                title: title,
                dueAt: dueAt,
                status: status,
                provenance: provenance,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, Task>(table),
                  $$TasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientDocumentId = false, caseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientDocumentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clientDocumentId,
                        referencedTable: $$TasksTableReferences
                            ._clientDocumentIdTable(db),
                        referencedColumn: $$TasksTableReferences
                            ._clientDocumentIdTable(db)
                            .clientDocumentId,
                      ) as T;
                    }
                    if (caseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.caseId,
                        referencedTable: $$TasksTableReferences._caseIdTable(
                          db,
                        ),
                        referencedColumn: $$TasksTableReferences
                            ._caseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({bool clientDocumentId, bool caseId})
    >;
typedef $$DeadlinesTableCreateCompanionBuilder = DeadlinesCompanion Function({
  required String id,
  required String clientDocumentId,
  required String label,
  required DateTime dueAt,
  Value<int> rowid,
});
typedef $$DeadlinesTableUpdateCompanionBuilder = DeadlinesCompanion Function({
  Value<String> id,
  Value<String> clientDocumentId,
  Value<String> label,
  Value<DateTime> dueAt,
  Value<int> rowid,
});

final class $$DeadlinesTableReferences
    extends BaseReferences<_$AppDatabase, $DeadlinesTable, Deadline> {
  $$DeadlinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DocumentsTable _clientDocumentIdTable(_$AppDatabase db) =>
      db.documents.createAlias(
        'deadlines__client_document_id__documents__client_document_id',
      );

  $$DocumentsTableProcessedTableManager get clientDocumentId {
    final $_column = $_itemColumn<String>('client_document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.clientDocumentId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeadlinesTableFilterComposer
    extends Composer<_$AppDatabase, $DeadlinesTable> {
  $$DeadlinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get clientDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeadlinesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeadlinesTable> {
  $$DeadlinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get clientDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeadlinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeadlinesTable> {
  $$DeadlinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get clientDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeadlinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeadlinesTable,
          Deadline,
          $$DeadlinesTableFilterComposer,
          $$DeadlinesTableOrderingComposer,
          $$DeadlinesTableAnnotationComposer,
          $$DeadlinesTableCreateCompanionBuilder,
          $$DeadlinesTableUpdateCompanionBuilder,
          (Deadline, $$DeadlinesTableReferences),
          Deadline,
          PrefetchHooks Function({bool clientDocumentId})
        > {
  $$DeadlinesTableTableManager(_$AppDatabase db, $DeadlinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeadlinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeadlinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeadlinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientDocumentId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeadlinesCompanion(
                id: id,
                clientDocumentId: clientDocumentId,
                label: label,
                dueAt: dueAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientDocumentId,
                required String label,
                required DateTime dueAt,
                Value<int> rowid = const Value.absent(),
              }) => DeadlinesCompanion.insert(
                id: id,
                clientDocumentId: clientDocumentId,
                label: label,
                dueAt: dueAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeadlinesTable, Deadline>(table),
                  $$DeadlinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientDocumentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientDocumentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clientDocumentId,
                        referencedTable: $$DeadlinesTableReferences
                            ._clientDocumentIdTable(db),
                        referencedColumn: $$DeadlinesTableReferences
                            ._clientDocumentIdTable(db)
                            .clientDocumentId,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DeadlinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeadlinesTable,
      Deadline,
      $$DeadlinesTableFilterComposer,
      $$DeadlinesTableOrderingComposer,
      $$DeadlinesTableAnnotationComposer,
      $$DeadlinesTableCreateCompanionBuilder,
      $$DeadlinesTableUpdateCompanionBuilder,
      (Deadline, $$DeadlinesTableReferences),
      Deadline,
      PrefetchHooks Function({bool clientDocumentId})
    >;
typedef $$AppointmentsTableCreateCompanionBuilder =
    AppointmentsCompanion Function({
      required String id,
      required String clientDocumentId,
      required String label,
      required DateTime startsAt,
      Value<int> rowid,
    });
typedef $$AppointmentsTableUpdateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<String> id,
      Value<String> clientDocumentId,
      Value<String> label,
      Value<DateTime> startsAt,
      Value<int> rowid,
    });

final class $$AppointmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AppointmentsTable, Appointment> {
  $$AppointmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DocumentsTable _clientDocumentIdTable(_$AppDatabase db) =>
      db.documents.createAlias(
        'appointments__client_document_id__documents__client_document_id',
      );

  $$DocumentsTableProcessedTableManager get clientDocumentId {
    final $_column = $_itemColumn<String>('client_document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.clientDocumentId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppointmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get clientDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get clientDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get clientDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppointmentsTable,
          Appointment,
          $$AppointmentsTableFilterComposer,
          $$AppointmentsTableOrderingComposer,
          $$AppointmentsTableAnnotationComposer,
          $$AppointmentsTableCreateCompanionBuilder,
          $$AppointmentsTableUpdateCompanionBuilder,
          (Appointment, $$AppointmentsTableReferences),
          Appointment,
          PrefetchHooks Function({bool clientDocumentId})
        > {
  $$AppointmentsTableTableManager(_$AppDatabase db, $AppointmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppointmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientDocumentId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppointmentsCompanion(
                id: id,
                clientDocumentId: clientDocumentId,
                label: label,
                startsAt: startsAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientDocumentId,
                required String label,
                required DateTime startsAt,
                Value<int> rowid = const Value.absent(),
              }) => AppointmentsCompanion.insert(
                id: id,
                clientDocumentId: clientDocumentId,
                label: label,
                startsAt: startsAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppointmentsTable, Appointment>(table),
                  $$AppointmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientDocumentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientDocumentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clientDocumentId,
                        referencedTable: $$AppointmentsTableReferences
                            ._clientDocumentIdTable(db),
                        referencedColumn: $$AppointmentsTableReferences
                            ._clientDocumentIdTable(db)
                            .clientDocumentId,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AppointmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppointmentsTable,
      Appointment,
      $$AppointmentsTableFilterComposer,
      $$AppointmentsTableOrderingComposer,
      $$AppointmentsTableAnnotationComposer,
      $$AppointmentsTableCreateCompanionBuilder,
      $$AppointmentsTableUpdateCompanionBuilder,
      (Appointment, $$AppointmentsTableReferences),
      Appointment,
      PrefetchHooks Function({bool clientDocumentId})
    >;
typedef $$AmountsTableCreateCompanionBuilder = AmountsCompanion Function({
  required String id,
  required String clientDocumentId,
  required int valueInCents,
  required String currency,
  required String direction,
  Value<int> rowid,
});
typedef $$AmountsTableUpdateCompanionBuilder = AmountsCompanion Function({
  Value<String> id,
  Value<String> clientDocumentId,
  Value<int> valueInCents,
  Value<String> currency,
  Value<String> direction,
  Value<int> rowid,
});

final class $$AmountsTableReferences
    extends BaseReferences<_$AppDatabase, $AmountsTable, Amount> {
  $$AmountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DocumentsTable _clientDocumentIdTable(_$AppDatabase db) =>
      db.documents.createAlias(
        'amounts__client_document_id__documents__client_document_id',
      );

  $$DocumentsTableProcessedTableManager get clientDocumentId {
    final $_column = $_itemColumn<String>('client_document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.clientDocumentId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AmountsTableFilterComposer
    extends Composer<_$AppDatabase, $AmountsTable> {
  $$AmountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valueInCents => $composableBuilder(
    column: $table.valueInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get clientDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AmountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AmountsTable> {
  $$AmountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valueInCents => $composableBuilder(
    column: $table.valueInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get clientDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AmountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AmountsTable> {
  $$AmountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get valueInCents => $composableBuilder(
    column: $table.valueInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get clientDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AmountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AmountsTable,
          Amount,
          $$AmountsTableFilterComposer,
          $$AmountsTableOrderingComposer,
          $$AmountsTableAnnotationComposer,
          $$AmountsTableCreateCompanionBuilder,
          $$AmountsTableUpdateCompanionBuilder,
          (Amount, $$AmountsTableReferences),
          Amount,
          PrefetchHooks Function({bool clientDocumentId})
        > {
  $$AmountsTableTableManager(_$AppDatabase db, $AmountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AmountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AmountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AmountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientDocumentId = const Value.absent(),
                Value<int> valueInCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AmountsCompanion(
                id: id,
                clientDocumentId: clientDocumentId,
                valueInCents: valueInCents,
                currency: currency,
                direction: direction,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientDocumentId,
                required int valueInCents,
                required String currency,
                required String direction,
                Value<int> rowid = const Value.absent(),
              }) => AmountsCompanion.insert(
                id: id,
                clientDocumentId: clientDocumentId,
                valueInCents: valueInCents,
                currency: currency,
                direction: direction,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AmountsTable, Amount>(table),
                  $$AmountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientDocumentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientDocumentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clientDocumentId,
                        referencedTable: $$AmountsTableReferences
                            ._clientDocumentIdTable(db),
                        referencedColumn: $$AmountsTableReferences
                            ._clientDocumentIdTable(db)
                            .clientDocumentId,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AmountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AmountsTable,
      Amount,
      $$AmountsTableFilterComposer,
      $$AmountsTableOrderingComposer,
      $$AmountsTableAnnotationComposer,
      $$AmountsTableCreateCompanionBuilder,
      $$AmountsTableUpdateCompanionBuilder,
      (Amount, $$AmountsTableReferences),
      Amount,
      PrefetchHooks Function({bool clientDocumentId})
    >;
typedef $$RequiredDocumentsTableCreateCompanionBuilder =
    RequiredDocumentsCompanion Function({
      required String id,
      required String clientDocumentId,
      required String description,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$RequiredDocumentsTableUpdateCompanionBuilder =
    RequiredDocumentsCompanion Function({
      Value<String> id,
      Value<String> clientDocumentId,
      Value<String> description,
      Value<String> status,
      Value<int> rowid,
    });

final class $$RequiredDocumentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RequiredDocumentsTable,
          RequiredDocument
        > {
  $$RequiredDocumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DocumentsTable _clientDocumentIdTable(_$AppDatabase db) =>
      db.documents.createAlias(
        'required_documents__client_document_id__documents__client_document_id',
      );

  $$DocumentsTableProcessedTableManager get clientDocumentId {
    final $_column = $_itemColumn<String>('client_document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.clientDocumentId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RequiredDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $RequiredDocumentsTable> {
  $$RequiredDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get clientDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequiredDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $RequiredDocumentsTable> {
  $$RequiredDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get clientDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequiredDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequiredDocumentsTable> {
  $$RequiredDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get clientDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequiredDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RequiredDocumentsTable,
          RequiredDocument,
          $$RequiredDocumentsTableFilterComposer,
          $$RequiredDocumentsTableOrderingComposer,
          $$RequiredDocumentsTableAnnotationComposer,
          $$RequiredDocumentsTableCreateCompanionBuilder,
          $$RequiredDocumentsTableUpdateCompanionBuilder,
          (RequiredDocument, $$RequiredDocumentsTableReferences),
          RequiredDocument,
          PrefetchHooks Function({bool clientDocumentId})
        > {
  $$RequiredDocumentsTableTableManager(
    _$AppDatabase db,
    $RequiredDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequiredDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RequiredDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RequiredDocumentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientDocumentId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RequiredDocumentsCompanion(
                id: id,
                clientDocumentId: clientDocumentId,
                description: description,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientDocumentId,
                required String description,
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RequiredDocumentsCompanion.insert(
                id: id,
                clientDocumentId: clientDocumentId,
                description: description,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RequiredDocumentsTable, RequiredDocument>(table),
                  $$RequiredDocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientDocumentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientDocumentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clientDocumentId,
                        referencedTable: $$RequiredDocumentsTableReferences
                            ._clientDocumentIdTable(db),
                        referencedColumn: $$RequiredDocumentsTableReferences
                            ._clientDocumentIdTable(db)
                            .clientDocumentId,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RequiredDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RequiredDocumentsTable,
      RequiredDocument,
      $$RequiredDocumentsTableFilterComposer,
      $$RequiredDocumentsTableOrderingComposer,
      $$RequiredDocumentsTableAnnotationComposer,
      $$RequiredDocumentsTableCreateCompanionBuilder,
      $$RequiredDocumentsTableUpdateCompanionBuilder,
      (RequiredDocument, $$RequiredDocumentsTableReferences),
      RequiredDocument,
      PrefetchHooks Function({bool clientDocumentId})
    >;
typedef $$AnalysisOperationsTableCreateCompanionBuilder =
    AnalysisOperationsCompanion Function({
      required String operationId,
      required String clientDocumentId,
      required String state,
      Value<String?> lastFailureCode,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AnalysisOperationsTableUpdateCompanionBuilder =
    AnalysisOperationsCompanion Function({
      Value<String> operationId,
      Value<String> clientDocumentId,
      Value<String> state,
      Value<String?> lastFailureCode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$AnalysisOperationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnalysisOperationsTable,
          AnalysisOperation
        > {
  $$AnalysisOperationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DocumentsTable _clientDocumentIdTable(
    _$AppDatabase db,
  ) => db.documents.createAlias(
    'analysis_operations__client_document_id__documents__client_document_id',
  );

  $$DocumentsTableProcessedTableManager get clientDocumentId {
    final $_column = $_itemColumn<String>('client_document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.clientDocumentId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnalysisOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisOperationsTable> {
  $$AnalysisOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastFailureCode => $composableBuilder(
    column: $table.lastFailureCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get clientDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisOperationsTable> {
  $$AnalysisOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastFailureCode => $composableBuilder(
    column: $table.lastFailureCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get clientDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisOperationsTable> {
  $$AnalysisOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get lastFailureCode => $composableBuilder(
    column: $table.lastFailureCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get clientDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.clientDocumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisOperationsTable,
          AnalysisOperation,
          $$AnalysisOperationsTableFilterComposer,
          $$AnalysisOperationsTableOrderingComposer,
          $$AnalysisOperationsTableAnnotationComposer,
          $$AnalysisOperationsTableCreateCompanionBuilder,
          $$AnalysisOperationsTableUpdateCompanionBuilder,
          (AnalysisOperation, $$AnalysisOperationsTableReferences),
          AnalysisOperation,
          PrefetchHooks Function({bool clientDocumentId})
        > {
  $$AnalysisOperationsTableTableManager(
    _$AppDatabase db,
    $AnalysisOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalysisOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalysisOperationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<String> clientDocumentId = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> lastFailureCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisOperationsCompanion(
                operationId: operationId,
                clientDocumentId: clientDocumentId,
                state: state,
                lastFailureCode: lastFailureCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required String clientDocumentId,
                required String state,
                Value<String?> lastFailureCode = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AnalysisOperationsCompanion.insert(
                operationId: operationId,
                clientDocumentId: clientDocumentId,
                state: state,
                lastFailureCode: lastFailureCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnalysisOperationsTable, AnalysisOperation>(
                    table,
                  ),
                  $$AnalysisOperationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientDocumentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientDocumentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clientDocumentId,
                        referencedTable: $$AnalysisOperationsTableReferences
                            ._clientDocumentIdTable(db),
                        referencedColumn: $$AnalysisOperationsTableReferences
                            ._clientDocumentIdTable(db)
                            .clientDocumentId,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnalysisOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisOperationsTable,
      AnalysisOperation,
      $$AnalysisOperationsTableFilterComposer,
      $$AnalysisOperationsTableOrderingComposer,
      $$AnalysisOperationsTableAnnotationComposer,
      $$AnalysisOperationsTableCreateCompanionBuilder,
      $$AnalysisOperationsTableUpdateCompanionBuilder,
      (AnalysisOperation, $$AnalysisOperationsTableReferences),
      AnalysisOperation,
      PrefetchHooks Function({bool clientDocumentId})
    >;
typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSetting,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSetting,
            BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
          ),
          UserSetting,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserSettingsTable, UserSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserSettingsTable,
                    UserSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSetting,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSetting,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
      ),
      UserSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OrganizationsTableTableManager get organizations =>
      $$OrganizationsTableTableManager(_db, _db.organizations);
  $$CasesTableTableManager get cases =>
      $$CasesTableTableManager(_db, _db.cases);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$DocumentFilesTableTableManager get documentFiles =>
      $$DocumentFilesTableTableManager(_db, _db.documentFiles);
  $$AnalysesTableTableManager get analyses =>
      $$AnalysesTableTableManager(_db, _db.analyses);
  $$AnalysisQualityReasonsTableTableManager get analysisQualityReasons =>
      $$AnalysisQualityReasonsTableTableManager(
        _db,
        _db.analysisQualityReasons,
      );
  $$AnalysisNextActionsTableTableManager get analysisNextActions =>
      $$AnalysisNextActionsTableTableManager(_db, _db.analysisNextActions);
  $$AnalysisUncertaintiesTableTableManager get analysisUncertainties =>
      $$AnalysisUncertaintiesTableTableManager(_db, _db.analysisUncertainties);
  $$AnalysisPracticalStatesTableTableManager get analysisPracticalStates =>
      $$AnalysisPracticalStatesTableTableManager(
        _db,
        _db.analysisPracticalStates,
      );
  $$AnalysisDeadlinesTableTableManager get analysisDeadlines =>
      $$AnalysisDeadlinesTableTableManager(_db, _db.analysisDeadlines);
  $$AnalysisAppointmentsTableTableManager get analysisAppointments =>
      $$AnalysisAppointmentsTableTableManager(_db, _db.analysisAppointments);
  $$AnalysisAmountsTableTableManager get analysisAmounts =>
      $$AnalysisAmountsTableTableManager(_db, _db.analysisAmounts);
  $$AnalysisRequiredDocumentsTableTableManager get analysisRequiredDocuments =>
      $$AnalysisRequiredDocumentsTableTableManager(
        _db,
        _db.analysisRequiredDocuments,
      );
  $$AnalysisSuggestedTasksTableTableManager get analysisSuggestedTasks =>
      $$AnalysisSuggestedTasksTableTableManager(
        _db,
        _db.analysisSuggestedTasks,
      );
  $$SourceReferencesTableTableManager get sourceReferences =>
      $$SourceReferencesTableTableManager(_db, _db.sourceReferences);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$DeadlinesTableTableManager get deadlines =>
      $$DeadlinesTableTableManager(_db, _db.deadlines);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db, _db.appointments);
  $$AmountsTableTableManager get amounts =>
      $$AmountsTableTableManager(_db, _db.amounts);
  $$RequiredDocumentsTableTableManager get requiredDocuments =>
      $$RequiredDocumentsTableTableManager(_db, _db.requiredDocuments);
  $$AnalysisOperationsTableTableManager get analysisOperations =>
      $$AnalysisOperationsTableTableManager(_db, _db.analysisOperations);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
}
