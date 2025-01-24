# format
format:
	find . -not -path './.git/*' -not -path './packages/tayyab_intl/*' -not -path '*/.dart_tool/*' -name "*.dart" ! -name "*.g.dart" ! -name "*.gr.dart" ! -name "*.mocks.dart" ! -name "*_test.dart" ! -name '*.swagger.*' ! -name '*.config.dart' ! -name '*.chopper.dart' ! -name '*.freezed.dart' | tr '\n' ' ' | xargs dart format --line-length=100
