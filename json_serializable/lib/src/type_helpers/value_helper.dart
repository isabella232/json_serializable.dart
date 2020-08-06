// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/type.dart';

import '../helper_core.dart';
import '../shared_checkers.dart';
import '../type_helper.dart';
import '../utils.dart';

class ValueHelper extends TypeHelper {
  const ValueHelper();

  @override
  String serialize(
    DartType targetType,
    String expression,
    TypeHelperContext context,
  ) {
    if (isObjectOrDynamic(targetType) ||
        simpleJsonTypeChecker.isAssignableFromType(targetType)) {
      return expression;
    }

    return null;
  }

  @override
  String deserialize(
    DartType targetType,
    String expression,
    TypeHelperContext context,
    bool defaultProvided,
  ) {
    final targetTypeNullable = defaultProvided || targetType.isNullableType;

    if (targetType.isDartCoreObject && !targetTypeNullable) {
      return '$expression as Object';
    } else if (isObjectOrDynamic(targetType)) {
      // just return it as-is. We'll hope it's safe.
      return expression;
    } else if (targetType.isDartCoreDouble) {
      final question = targetTypeNullable ? '?' : '';
      return '($expression as num$question)$question.toDouble()';
    } else if (simpleJsonTypeChecker.isAssignableFromType(targetType)) {
      final typeCode = typeToCode(targetType, forceNullable: defaultProvided);
      return '$expression as $typeCode';
    }

    return null;
  }
}
