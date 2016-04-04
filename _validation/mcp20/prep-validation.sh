if [ ! $# -eq 0 ]; then
    echo "prep-validation - preps schematron validators from the "
    echo "  ./source-tests directory, dropping prepped xslt "
    echo "  into the ./tests dir."
    echo "  Example: ./prep-validation.sh"
    exit 1
fi

pushd ./source-tests

rm ../tests/*.sch.xsl

mkdir tmp

for F in *.sch
do
    echo -n "preparing $F.."

    ### single pass iso-schematron
    # java -jar ../tools/saxon9he.jar -o:../schematron-cooked/$F.xsl -s:$F ../tools/iso_svrl_for_xslt2.xsl

    ### single pass schematron 1.5
    # java -jar ../tools/saxon9he.jar --suppressXsltNamespaceCheck:on -s:$F -o:../schematron-cooked/$F.xsl ../tools/sch15/schematron-report.xsl
    # java -jar ../tools/saxon9he.jar -s:$F -o:../schematron-cooked/$F.xsl ../tools/sch15/schematron-report.xsl

    ### trying the OSX system transformer with schematron 1.5
    # xsltproc -v -o ../schematron-cooked/$F.xsl ../tools/sch15/schematron-report.xsl $F

    ### three pass iso-schematron
    java -jar ../../_saxon/saxon9he.jar -versionmsg:off -s:$F -o:./tmp/$F_1.sch ../../_schematron/iso_dsdl_include.xsl
    java -jar ../../_saxon/saxon9he.jar -versionmsg:off -s:./tmp/$F_1.sch -o:./tmp/$F_2.sch ../../_schematron/iso_abstract_expand.xsl
    java -jar ../../_saxon/saxon9he.jar -versionmsg:off -s:./tmp/$F_2.sch -o:../tests/$F.xsl ../../_schematron/iso_svrl_for_xslt2.xsl

    echo " done."

done

rm -rf tmp

popd
