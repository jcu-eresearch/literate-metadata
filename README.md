# Literate Metadata

Write your XML metadata records embedded inside friendly, useful,
pragmatic Markdown documentation.

This repo supports authoring a metadata record embedded in a Markdown
document written in a
[Literate](https://en.wikipedia.org/wiki/Literate_programming) style.
The Markdown describes the XML.  Simple processing of the Markdown
document produces two output items; one, a HTML document for viewing
in a web browser, and an XML document which is the MCP metadata
record.

A shell script is provided to do this processing.  You'll need to
install a working markdown processor; try commonmark:

    npm install -g commonmark   # if you have npm already
    brew install commonmark     # if you don't have npm

Usage:

    ./deliterate.sh mcp/annotated-mcp.md
    open mcp/annotated-mcp.md.html

