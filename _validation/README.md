### Schematron validation

1. make a directory for your validations, e.g. `mkdir _validation/myschema`
2. make a subdir `tests` and fill it with pre-cooked Schematron `xslt` documents
3. run `./validate.sh myschema myDoc.xml`

For an example of cooking Schematron `.sch` documents into `xslt` documents,
see the `_validation/mcp20` directory.
