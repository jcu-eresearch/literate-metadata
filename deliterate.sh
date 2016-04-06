#!/usr/bin/env bash
#
# install commonmark:  npm install -g commonmark
#

MD_CONVERT_COMMAND="commonmark"
HTML_HEADER="./_includes/header.html"
HTML_FOOTER="./_includes/footer.html"

if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "deliterate - takes literate Markdown doc, renders to html, also extracts code."
  echo "Specify input file as first argument.  Outputs HTML and XML."
  echo "Example: ./deliterate.sh mcp/annotated-mcp.md"
  echo "         (reads mcp/annotated-mcp.md, creates mcp/filename.md.html and mcp/filename.md.xml)"
  exit 1
fi

# use sed to...
#    keep lines that start  |   remove the four   >   save to
#      with four spaces,    |   leading spaces    >  output file.
sed -n -e "/^    /p" < "$1" | sed -e "s/^    //"  >  "$1.xml"

echo "wrote: $1.xml"

# also render markdown to html -- cat the header and footer in as well
cat "$HTML_HEADER" > "$1.html"
"$MD_CONVERT_COMMAND" < "$1" >> "$1.html"
cat "$HTML_FOOTER" >> "$1.html"

echo "wrote: $1.html"
