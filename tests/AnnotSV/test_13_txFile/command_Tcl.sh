#!/bin/bash -x

set -eo pipefail

cut="$ANNOTSV/tests/AnnotSV/scripts/cutWithColumnNames.tcl"


################################
# Check the "-txFile" option
################################

# INFO: Transcript annotation comes from $ANNOTSV/share/AnnotSV/Annotations_Human/Genes/GRCh37/genes.RefSeq.sorted.bed


## Check 1: the CDK11B gene (with a BED input file)
###################################################

# grep CDK11B $ANNOTSV/share/AnnotSV/Annotations_Human/Genes/GRCh37/genes.RefSeq.sorted.bed
# 1       1570602 1590465 -       CDK11B  NM_001291345    1571125 1588935 1570602,1571298,1571694,1572043,1572258,1572442,1572769,1573123,1573861,1575637,1576408,1577022,1577266,1577746,1580486,1586824,1588824,1590374,     1571218,1571488,1571843,1572160,1572366,1572564,1572875,1573245,1573952,1575813,1576474,1577181,1577362,1577869,1580625,1586938,1588948,1590465,
# 1       1570602 1590465 -       CDK11B  NM_001787       1571125 1588935 1570602,1571298,1571694,1572043,1572258,1572442,1572769,1573123,1573861,1575637,1576408,1577022,1577266,1577707,1580486,1586818,1588824,1590374,     1571218,1571488,1571843,1572160,1572366,1572564,1572875,1573245,1573952,1575813,1576474,1577181,1577362,1577869,1580625,1586938,1588948,1590465,
# 1       1570602 1590465 -       CDK11B  NM_033486       1571125 1588935 1570602,1571298,1571694,1572043,1572258,1572442,1572769,1573123,1573861,1575637,1576408,1577022,1577266,1577746,1580486,1586818,1588824,1590374,     1571218,1571488,1571843,1572160,1572366,1572564,1572875,1573245,1573952,1575813,1576474,1577181,1577362,1577869,1580625,1586938,1588948,1590465,
# 1       1570602 1590465 -       CDK11B  NM_033487       1571125 1577348 1570602,1571298,1571694,1572043,1572258,1572442,1572769,1573123,1573861,1575637,1576408,1577022,1577266,1586817,1588824,1590374,        1571218,1571488,1571843,1572160,1572366,1572564,1572875,1573245,1573952,1575813,1576474,1577181,1577365,1586938,1588948,1590465,
# 1       1570602 1590465 -       CDK11B  NM_033489       1571125 1588714 1570602,1571298,1571694,1572043,1572258,1572442,1572769,1573123,1573861,1575637,1576408,1577022,1577266,1577746,1580486,1586818,1588705,1588824,1590374,     1571218,1571488,1571843,1572160,1572366,1572564,1572875,1573245,1573952,1575813,1576474,1577181,1577362,1577869,1580625,1586938,1588752,1588948,1590465,
# 1       1570602 1590465 -       CDK11B  NM_033490       1571125 1577849 1570602,1571298,1571694,1572043,1572258,1572442,1572769,1573123,1573861,1575637,1576408,1577022,1577266,1577746,1586817,1588824,1590374,    1571218,1571488,1571843,1572160,1572366,1572564,1572875,1573245,1573952,1575813,1576474,1577181,1577362,1577871,1586938,1588948,1590465,

# By default, the CDK11B gene is annotated with the "NM_001787" transcript (and not the "NM_033486")
rm -f "./output/test.check1_tcl.annotated.tsv"
$ANNOTSV/bin/AnnotSV -SVinputFile "./input/test.check1.bed" -outputFile "./output/test.check1_tcl.annotated.tsv" -svtBEDcol 5 -genomeBuild GRCh37
annotations=`$cut "./output/test.check1_tcl.annotated.tsv" "Gene_name;Tx" | grep "CDK11B"`
if [ `echo $annotations | grep -c "NM_001787"` != 0 ]
then
        echo "Ok"
else
        echo "error 1: the CDK11B gene is not annotated with the NM_001787 transcript"
        exit 1
fi


# Changing of the transcript default:
# => "NM_033486" transcript is given in the "txFile.check1.txt" file
rm -f "./output/test.check1.WithTx_tcl.annotated.tsv"
$ANNOTSV/bin/AnnotSV -SVinputFile "./input/test.check1.bed" -outputFile "./output/test.check1.WithTx_tcl.annotated.tsv" -svtBEDcol 5 -txFile "./input/txFile.check1.txt" -genomeBuild GRCh37
annotations=`$cut "./output/test.check1.WithTx_tcl.annotated.tsv" "Gene_name;Tx" | grep "CDK11B"`
#=> Now, the CDK11B gene is annotated with "NM_033486"
if [ `echo $annotations | grep -c "NM_033486"` != 0 ]
then
        echo "Ok"
else
        echo "error 1: the CDK11B gene is not annotated with the NM_033486 transcript"
        exit 1
fi


## Check 2: the NAV1 gene (with a VCF input file)
#################################################

# grep NAV1 $ANNOTSV/share/AnnotSV/Annotations_Human/Genes/GRCh37/genes.RefSeq.sorted.bed
# 1       201508254       201796097       +       NAV1    NM_001389615    201592012       201789060       201508254,201557666,201591980,201598531,201617761,201681944,201687517,201749548,201750139,201751303,201752533,201754437,201755556,201758867,201759816,201762919,201763593,201772720,201777080,201777545,201777830,201778291,201778569,201779073,201779650,201780730,201781030,201781592,201782267,201786215,201788964,       201508470,201557777,201592734,201598635,201618553,201682047,201687883,201749687,201750437,201751997,201752980,201754479,201755705,201758920,201759894,201763003,201763705,201772842,201777277,201777738,201777999,201778389,201778665,201779233,201779886,201780885,201781102,201781789,201782386,201786413,201796097,
# 1       201508254       201796097       +       NAV1    NM_001389616    201592012       201789060       201508254,201591980,201598531,201617761,201681944,201687517,201749548,201750139,201751303,201752533,201754437,201755556,201758867,201759681,201759816,201762919,201763593,201772720,201773616,201777080,201777545,201777830,201778291,201778569,201779073,201779650,201780730,201781030,201781592,201782267,201786215,201788964, 201508470,201592734,201598635,201618553,201682047,201687883,201749687,201750437,201751997,201752980,201754479,201755705,201758920,201759705,201759894,201763003,201763705,201772842,201773625,201777277,201777738,201777999,201778389,201778665,201779233,201779886,201780885,201781102,201781789,201782386,201786413,201796097,
# 1       201508254       201796097       +       NAV1    NM_001389617    201592012       201789060       201508254,201557666,201591980,201598531,201617761,201681944,201687517,201749548,201750139,201751303,201752533,201754437,201755556,201757595,201758867,201759681,201759816,201762919,201763593,201772720,201773616,201777080,201777545,201777830,201778291,201778569,201779073,201779650,201780730,201781030,201781592,201782267,201786215,201788964,      201508470,201557777,201592734,201598635,201618553,201682047,201687883,201749687,201750437,201751997,201752980,201754479,201755705,201757766,201758920,201759705,201759894,201763003,201763705,201772842,201773625,201777277,201777738,201777999,201778389,201778665,201779233,201779886,201780885,201781102,201781789,201782386,201786413,201796097,
# 1       201617793       201796097       +       NAV1    NM_020443       201617796       201789060       201617793,201681944,201687517,201749548,201750139,201751303,201752533,201754437,201755556,201757595,201758867,201759681,201759816,201762919,201763593,201772720,201773616,201777080,201777545,201777830,201778291,201778569,201779073,201779650,201780730,201781030,201781592,201782267,201786215,201788964, 201618553,201682047,201687883,201749687,201750437,201751997,201752980,201754479,201755705,201757766,201758920,201759705,201759894,201763003,201763705,201772842,201773625,201777277,201777738,201777999,201778389,201778665,201779233,201779886,201780885,201781102,201781789,201782386,201786413,201796097,
# 1       201709027       201796097       +       NAV1    NM_001167738    201709151       201789060       201709027,201749548,201750139,201751303,201752533,201754437,201755556,201757595,201758867,201759681,201759816,201762919,201763593,201772720,201777080,201777545,201777830,201778291,201778569,201779073,201779650,201780730,201781030,201781592,201782267,201786215,201788964,       201709204,201749687,201750437,201751997,201752980,201754479,201755705,201757766,201758920,201759705,201759894,201763003,201763705,201772842,201777277,201777738,201777999,201778389,201778665,201779233,201779886,201780885,201781102,201781789,201782386,201786413,201796097,
# 1       201709027       201796097       +       NAV1    NM_001389611    201709151       201789060       201709027,201749548,201750139,201751303,201752533,201754437,201755556,201757595,201758867,201759681,201759816,201762919,201763593,201772720,201773616,201777080,201777545,201777830,201778291,201778569,201779073,201779650,201780730,201781030,201781592,201782267,201786215,201788964,     201709204,201749687,201750437,201751997,201752980,201754479,201755705,201757766,201758920,201759705,201759894,201763003,201763705,201772842,201773625,201777277,201777738,201777999,201778389,201778665,201779233,201779886,201780885,201781102,201781789,201782386,201786413,201796097,
# 1       201709027       201796097       +       NAV1    NM_001389612    201709151       201789060       201709027,201749548,201750139,201751303,201752533,201754437,201755556,201757595,201758867,201759816,201762919,201763593,201772720,201777080,201777545,201777830,201778291,201778569,201779073,201779650,201780730,201781030,201781592,201782267,201786215,201788964, 201709204,201749687,201750437,201751997,201752980,201754479,201755705,201757766,201758920,201759894,201763003,201763705,201772842,201777277,201777738,201777999,201778389,201778665,201779233,201779886,201780885,201781102,201781789,201782386,201786413,201796097,
# 1       201709027       201796097       +       NAV1    NM_001389613    201709151       201789060       201709027,201749548,201750139,201751303,201752533,201754437,201755556,201758867,201759681,201759816,201762919,201763593,201772720,201773616,201777080,201777545,201777830,201778291,201778569,201779073,201779650,201780730,201781030,201781592,201782267,201786215,201788964,       201709204,201749687,201750437,201751997,201752980,201754479,201755705,201758920,201759705,201759894,201763003,201763705,201772842,201773625,201777277,201777738,201777999,201778389,201778665,201779233,201779886,201780885,201781102,201781789,201782386,201786413,201796097,
# 1       201709027       201796097       +       NAV1    NM_001389614    201709151       201789060       201709027,201749548,201750139,201751303,201752533,201754437,201755556,201758867,201759816,201762919,201763593,201772720,201777080,201777545,201777830,201778291,201778569,201779073,201779650,201780730,201781030,201781592,201782267,201786215,201788964,   201709204,201749687,201750437,201751997,201752980,201754479,201755705,201758920,201759894,201763003,201763705,201772842,201777277,201777738,201777999,201778389,201778665,201779233,201779886,201780885,201781102,201781789,201782386,201786413,201796097,

# By default, the NAV1 gene is annotated with the "NM_001389615" transcript (and not the "NM_001167738")
rm -f "./output/test.check2_tcl.annotated.tsv"
$ANNOTSV/bin/AnnotSV -SVinputFile "./input/test.check2.vcf" -outputFile "./output/test.check2_tcl.annotated.tsv" -genomeBuild GRCh37
annotations=`$cut "./output/test.check2_tcl.annotated.tsv" "Gene_name;Tx" | grep "NAV1"`
if [ `echo $annotations | grep -c "NM_001389615"` != 0 ]
then
        echo "Ok"
else
        echo "error 1: the NAV1 gene is not annotated with the NM_001389615 transcript"
        exit 1
fi


# Changing of the transcript default:
# => "NM_001167738" transcript is given in the "txfile.check2.txt" file
rm -f "./output/test.check2.WithTx_tcl.annotated.tsv"
$ANNOTSV/bin/AnnotSV -SVinputFile "./input/test.check2.vcf" -outputFile "./output/test.check2.WithTx_tcl.annotated.tsv" -txFile "./input/txFile.check2.txt" -genomeBuild GRCh37
annotations=`$cut "./output/test.check2.WithTx_tcl.annotated.tsv" "Gene_name;Tx" | grep "NAV1"`
#=> Now, the NAV1 gene is annotated with "NM_001167738"
if [ `echo $annotations | grep -c "NM_001167738"` != 0 ]
then
        echo "Ok"
else
        echo "error 1: the NAV1 gene is not annotated with the NM_001167738 transcript"
        exit 1
fi



############################
# Check the "-tx" option
############################

## Check 3
##########

# By default, tx="RefSeq"
# Check with tx="ENSEMBL"
rm -f "./output/test.check3_tcl.annotated.tsv"
$ANNOTSV/bin/AnnotSV -SVinputFile "./input/test.check1.bed" -outputFile "./output/test.check3_tcl.annotated.tsv" -svtBEDcol 5 -tx "ENSEMBL" -genomeBuild GRCh37
annotations=`$cut "./output/test.check3_tcl.annotated.tsv" "Gene_name;Tx" | grep "CDK11B"`
if [ `echo $annotations | grep -c "ENST00000407249"` != 0 ]
then
        echo "Ok"
else
        echo "error 1: the CDK11B gene is not annotated with the ENST00000407249 transcript"
        exit 1
fi


# Changing of the transcript default:
# => "ENST00000341832" transcript is given in the "txfile.check3.txt" file
rm -f "./output/test.check3.WithTx_tcl.annotated.tsv"
$ANNOTSV/bin/AnnotSV -SVinputFile "./input/test.check1.bed" -outputFile "./output/test.check3.WithTx_tcl.annotated.tsv" -txFile "./input/txFile.check3.txt" -svtBEDcol 5 -tx "ENSEMBL" -genomeBuild GRCh37
annotations=`$cut "./output/test.check3.WithTx_tcl.annotated.tsv" "Gene_name;Tx" | grep "CDK11B"`
#=> Now, the CDK11B gene is annotated with "ENST00000341832"
if [ `echo $annotations | grep -c "ENST00000341832"` != 0 ]
then
        echo "Ok"
else
        echo "error 1: the CDK11B gene is not annotated with the ENST00000341832 transcript"
        exit 1
fi




echo "ok - Finished"







