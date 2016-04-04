if [ $# -eq 0 ] || [ $# -eq 1 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "validate - test the file argument against the specified validation."
    echo "  Usage:   ./validate.sh <schemaName> <xmlFileName>"
    echo
    echo "  The schema named is assumed to be a directory in the ./_validation"
    echo "  dir with appropriate contents.  Errors are saved into the ./_errors"
    echo "  dir (which is emptied first)."
    echo
    echo "  Example:"
    echo "    ./validate.sh mcp20 mcp/annotated-mcp.md.xml"
    exit 1
fi

# jump into the validations dir speficied
pushd "./_validation/$1/tests"

# clean out the errors dir
rm ../../../_errors/*.errors.xml

# now loop through each xsl file, running each one on $2, the user's file
for F in *.xsl; do
    echo "Running tests from $F..."
    java -jar ../../_saxon/saxon9he.jar -versionmsg:off -o:"../../../_errors/$F.errors.xml" -s:"../../../$2" "$F"
    echo
done

# finally, switch back to the original dir
popd
