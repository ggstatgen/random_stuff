#!/bin/bash


#script to run the platypus variant caller using the cluster
#Running Platypus
#===================
#
#The easiest way to run Platypus is as follows:
#
#python Platypus.py callVariants --bamFiles=LIST_OF_BAMS --refFile=REF.fa --output=Calls.vcf
#
#
#You can see a list of all the possible input options by running the following comand:
#
#python Platypus.py callVariants --help
#
#However, in most cases the default parameter values should be fine, and you will only need to specify the --bamFiles
#and --refFile and --output arguments. By default, if you do not specify a region or regions or interest, Platypus will
#run through all the data in your BAM files. The --regions argument can be used to specify regions of interest.

#3. Running in Variant-Calling Mode
#==================================
#
#The standard way of running Platypus is to use it to detect variants in one or more BAM files. Variants are detected by
#comparing the BAM reads with a reference sequence. This can be done using the following command:
#
#python Platypus.py callVariants --bamFiles=DATA.bam --regions=chr20 --output=test.vcf --refFile=GENOME.fa
#
#where the input BAM files, and the genome reference must be indexed using samtools, or a program that produces compatible
#index files.

if [ ! $# == 1 ]; then
        echo "Usage: `basename $0` <PATH>"
        echo "PATH - path for the bam files (e.g. /home/me/files)"
        exit
fi

PDATA=$1;
PCODE="/net/isi-scratch/giuseppe/tools/Platypus_0.5.2";
REFERENCE="/net/isi-scratch/giuseppe/indexes/Hsap/hg19/hg19.fa";

#create output dir
POUT=${PDATA}/d_Platypus_combo;
mkdir ${POUT};

SPACE=",";
for FILE in ${PDATA}/*.bam;
        do
        INPUT+=${FILE}${SPACE};
done

SCRIPT=Platypus_combo.sh;
echo '#!/bin/bash' >>${POUT}/${SCRIPT};
echo '' >>${POUT}/${SCRIPT};
echo "source activate" >>${POUT}/${SCRIPT};
echo "python ${PCODE}/Platypus.py callVariants --bamFiles=${INPUT} --refFile=${REFERENCE} --output=${POUT}/combo_calls.vcf" >>${POUT}/${SCRIPT};

#nice -5 qsub -e ${POUT}/Platypus_combo.err -o ${POUT}/Platypus_combo.out -q newnodes.q ${POUT}/${SCRIPT};
#rm ${POUT}/${SCRIPT};
