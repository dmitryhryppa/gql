import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";
import "package:path/path.dart" as p;

import "package:gql_code_builder/src/built_class.dart";
import "package:gql_code_builder/src/common.dart";
import "package:gql_code_builder/source.dart";

List<Class> buildOperationVarClasses(
  SourceNode docSource,
  SourceNode schemaSource,
) =>
    docSource.document.definitions
        .whereType<OperationDefinitionNode>()
        .map(
          (op) => _buildOperationVarClass(
            op,
            schemaSource,
          ),
        )
        .toList();

Class _buildOperationVarClass(
  OperationDefinitionNode node,
  SourceNode schemaSource,
) =>
    builtClass(
      name: "${node.name.value}Vars",
      getters: node.variableDefinitions.map<Method>(
        (node) => buildGetter(
          nameNode: node.variable.name,
          typeNode: node.type,
          schemaSource: schemaSource,
        ),
      ),
      serializersUrl: "${p.dirname(schemaSource.url)}/serializers.gql.dart",
    );
