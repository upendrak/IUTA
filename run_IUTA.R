#!/usr/bin/Rscript

## Example command line invocation
# Rscript run_IUTA.R -h (just to look at the help function)
# Rscript run_IUTA.R --gtf test_data/mm10_kg_sample_IUTA.gtf --bam1 test_data/sample_1.bam,test_data/sample_2.bam,test_data/sample_3.bam --bam2 test_data/sample_4.bam,test_data/sample_5.bam,test_data/sample_6.bam --fld empirical --test.type SKK,CQ,KY --output test_data/new_ouput_test2  --groups 4,5 --gene.id Pcmtd1
# Rscript run_IUTA.R --gtf test_data/mm10_kg_sample_IUTA.gtf --bam1 test_data/sample_1.bam,test_data/sample_2.bam,test_data/sample_3.bam --bam2 test_data/sample_4.bam,test_data/sample_5.bam,test_data/sample_6.bam --test.type SKK,CQ,KY --output test_data/new_ouput_test2  --groups 4,5 --gene.id Pcmtd1
# Rscript run_IUTA.R --gtf test_data/mm10_kg_sample_IUTA.gtf --bam1 test_data/sample_1.bam,test_data/sample_2.bam,test_data/sample_3.bam --bam2 test_data/sample_4.bam,test_data/sample_5.bam,test_data/sample_6.bam --fld normal --test.type SKK,CQ,KY --output test_data/new_ouput_test2  --groups 4,5 --gene.id Pcmtd1
# Rscript run_IUTA.R --gtf test_data/mm10_kg_sample_IUTA.gtf --bam1 test_data/sample_1.bam,test_data/sample_2.bam,test_data/sample_3.bam --bam2 test_data/sample_4.bam,test_data/sample_5.bam,test_data/sample_6.bam --fld normal --output test_data/new_ouput_test2  --groups 4,5 --gene.id Pcmtd1
# Rscript run_IUTA.R --gtf test_data/mm10_kg_sample_IUTA.gtf --bam1 test_data/sample_1.bam,test_data/sample_2.bam,test_data/sample_3.bam --bam2 test_data/sample_4.bam,test_data/sample_5.bam,test_data/sample_6.bam --fld normal --test.type SKK,CQ,KY --output test_data/new_ouput_test2

# Install dependencies
library("Rsamtools")
library("IUTA")
library("getopt")

args<-commandArgs(TRUE)

#############################################################
## Command-line preparations and getopt parsing ##
#############################################################

options<-matrix(c(	'gtf',	'i',	1,	"character",
		  			'bam1',	'ba1',	1,	"character",
		  			'bam2',	'ba2',	1,	"character",
		  			'fld',	'fld',	1,	"character",
		  			'test.type', 'testtype', 1, "character",
					'n', 'numsamp', 1, "integer",
		  			'groups', 'grp', 2, "character",
		  			'gene.id',	'g',	2, "character",
					'leg.pos', 'posn', 2, "character",
		  			'output', 'o', 1,	"character",
		  			'help', 'h', 0,      "logical"),
		  				ncol=4,byrow=TRUE)

ret.opts<-getopt(options,args)

if ( !is.null(ret.opts$help) ) {
  cat(getopt(options, usage=TRUE));
  q(status=1);
}

# Assignments
transcript.info <- ret.opts$gtf
bam.list1 <- ret.opts$bam1
bam.list2 <- ret.opts$bam2
#FLD <- ret.opts$fld
#test.type <- ret.opts$test.type
output.dir <- ret.opts$output

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

# Legend position
if(is.null(ret.opts$leg.pos))
{
	legend.pos <- "topleft"
} else
{
	legend.pos <- ret.opts$leg.pos
}


# Main function
IUTA(bam.list1, bam.list2, transcript.info, rep.info.1 = rep(1, length(bam.list1)), rep.info.2 = rep(1, length(bam.list2)), FLD = FLD, test.type = test.type,
    output.dir = output.dir, output.na = TRUE, genes.interested = "all")

# Estimate output 
estimates <- paste(output.dir,"estimates.txt",sep="/")

# Read the estimates file
data <- read.table(estimates, h = T)
genes <- data[,1]
gene.uni <- unique(genes)

# pie_compare and bar_compare
source('/pie_plot.R')

if(!is.null(ret.opts$gene.id))
{
	numb <- ret.opts$n
	gene.name <- ret.opts$gene.id
	group.name <- ret.opts$groups
	group.name <- unlist(strsplit(ret.opts$groups, ","))

	# pie chart
	pie_compare(gene.name, n1 = numb, geometry = "Euclidean", adjust.weight = 1e-2, output.file = paste("Pieplot_", gene.name, ".pdf", sep = ""), group.name = group.name, estimates, output.screen=FALSE)
	
	# bar chart
	bar_compare(gene.name, n1 = numb, output.file = paste("Barplot_", gene.name, ".pdf", sep = ""), group.name = group.name, legend.pos = legend.pos, estimates, output.screen=FALSE)
} else
{
	for (gene in gene.uni) {

	numb <- ret.opts$n
        group.name <- ret.opts$groups
        group.name <- unlist(strsplit(ret.opts$groups, ","))

	# pie chart
	pie_compare(gene, n1 = numb, geometry = "Euclidean", adjust.weight = 1e-2, output.file = paste("Pieplot_", gene, ".pdf", sep = ""), group.name = group.name, estimates, output.screen=FALSE)
	# bar chart
	bar_compare(gene, n1 = numb, output.file = paste("Barplot_", gene, ".pdf", sep = ""), group.name = group.name, legend.pos = legend.pos, estimates, output.screen=FALSE)
	system("tar -zcvf Pie_plots.tar.gz *pdf && rm Pieplot_*.pdf")
	system("tar -zcvf Bar_plots.tar.gz *pdf && rm Barplot_*.pdf")
 } 
}
