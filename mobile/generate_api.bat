@echo off
npx @openapitools/openapi-generator-cli generate -i http://localhost:3003/api-json -g dart-dio -o lib/api
echo API generation complete. Run 'flutter pub run build_runner build' to generate models.