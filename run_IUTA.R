#!/usr/bin/Rscript

# Rscript run_IUTA.R -h
# Rscript run_IUTA.R --gtf test_data/mm10_kg_sample_IUTA.gtf --bam1 test_data/sample_1.bam,test_data/sample_2.bam,test_data/sample_3.bam --bam2 test_data/sample_4.bam,test_data/sample_5.bam,test_data/sample_6.bam --fld empirical --test.type SKK,CQ,KY --output test_data/new_ouput_test2  --groups 4,5 --gene.id Pcmtd1
# Rscript run_IUTA.R --gtf test_data/mm10_kg_sample_IUTA.gtf --bam1 test_data/sample_1.bam,test_data/sample_2.bam,test_data/sample_3.bam --bam2 test_data/sample_4.bam,test_data/sample_5.bam,test_data/sample_6.bam --test.type SKK,CQ,KY --output test_data/new_ouput_test2  --groups 4,5 --gene.id Pcmtd1
# Rscript run_IUTA.R --gtf test_data/mm10_kg_sample_IUTA.gtf --bam1 test_data/sample_1.bam,test_data/sample_2.bam,test_data/sample_3.bam --bam2 test_data/sample_4.bam,test_data/sample_5.bam,test_data/sample_6.bam --fld normal --test.type SKK,CQ,KY --output test_data/new_ouput_test2  --groups 4,5 --gene.id Pcmtd1

# Install dependencies
library("Rsamtools")
library("IUTA")
#install.packages("getopt")
library("getopt")

args<-commandArgs(TRUE)

#############################################################
## Section 0: Command-line preparations and getopt parsing ##
#############################################################

options<-matrix(c(	'gtf',	'i',	1,	"character",
		  			'bam1',	'ba1',	1,	"character",
		  			'bam2',	'ba2',	1,	"character",
		  			'fld',	'fld',	1,	"character",
		  			'test.type', 'testtype', 1, "character",
		  			'groups', 'grp', 1, "character",
		  			'gene.id',	'g',	1, "character",
		  			'output', 'o', 1,	"character",
		  			'help', 'h', 0,      "logical"),
		  				ncol=4,byrow=TRUE)

ret.opts<-getopt(options,args)

if ( !is.null(ret.opts$help) ) {
  cat(getopt(options, usage=TRUE));
  q(status=1);
}

transcript.info <- ret.opts$gtf
bam.list1 <- ret.opts$bam1
bam.list2 <- ret.opts$bam2
FLD <- ret.opts$fld
test.type <- ret.opts$test.type
output.dir <- ret.opts$output
gene.name <- ret.opts$gene.id
group.name <- ret.opts$groups


# bam lists
bam.list1 <- unlist(strsplit(ret.opts$bam1, ","))
bam.list2 <- unlist(strsplit(ret.opts$bam2, ","))

# FLD
if(is.null(ret.opts$fld))
{
	FLD <- "empirical"
} else
{
	FLD <- ret.opts$fld
}

# test type
if(is.null(ret.opts$testtype))
{
	test.type <- "SKK"
} else
{
	test.type <- ret.opts$test.type
}

if(length(test.type)>1)
{
	test.type <- unlist(strsplit(ret.opts$test.type, ","))
}


# Group
group.name <- unlist(strsplit(ret.opts$groups, ","))


# Main function
IUTA(bam.list1, bam.list2, transcript.info, rep.info.1 = rep(1, length(bam.list1)), rep.info.2 = rep(1, length(bam.list2)), FLD = FLD, test.type = test.type,
    output.dir = output.dir, output.na = TRUE, genes.interested = "all")

# Estimate output 
estimates <- paste(output.dir,"estimates.txt",sep="/")

# pie_compare is a function of IUTA library. 
pie_compare(gene.name, n1=3, geometry="Euclidean", adjust.weight = 1e-2, output.file =paste("Pieplot_", gene.name, ".pdf", sep = ""), group.name=group.name, estimates, output.screen=FALSE)

# bar_comapre 
bar_compare(gene.name, n1=3, estimates, legend.pos="topleft", output.screen=FALSE)