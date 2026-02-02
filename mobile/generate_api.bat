@echo off
npx @openapitools/openapi-generator-cli generate -i http://localhost:3003/api-json -g dart-dio -o lib/api --additional-properties=pubVersion=3.0.0,dartSdkVersion=3.9,languageVersion=3.9
echo API generation complete. Run 'flutter pub run build_runner build' to generate models.