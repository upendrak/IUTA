FROM r-base:latest
MAINTAINER Upendra Devisetty <upendra@cyverse.org>
LABEL Description "This Dockerfile is for IUTA"

# Run updates
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget -y
RUN apt-get install r-base-dev -y
RUN apt-get install libxml2 -y
RUN apt-get install libxml2-dev -y

RUN wget http://www.niehs.nih.gov/resources/files/IUTA_1.0.tar.gz
RUN tar zxvf IUTA_1.0.tar.gz

RUN Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite("Rsamtools");'
RUN Rscript -e 'install.packages("/IUTA_1.0.tar.gz", repos = NULL, type="source");'
RUN Rscript -e 'install.packages("getopt");'

# Add Custom Pie_compare, Pie_plot and Bar_compare functions inside IUTA-1.0 container
ADD pie_compare.R /
ADD pie_plot.R /
ADD bar_compare.R /

# Add wrapper script
ADD run_IUTA.R /
RUN chmod +x /run_IUTA.R && cp /run_IUTA.R /usr/bin

ENTRYPOINT ["run_IUTA.R"]
CMD ["-h"]

# Building and testing
# docker build -t"=rbase/iuta" .
# Running with out any arguments
# sudo docker run rbase/iuta -h
# With test data (with one geneid) 
# docker run --rm -v $(pwd):/working-dir -w /working-dir rbase/iuta --gtf mm10_kg_sample_IUTA.gtf --bam1 sample_1.bam --bam2 sample_4.bam --fld empirical --test.type SKK,CQ,KY --n 1 --output IUTA_test_1 --groups 4,5 --gene.id Pcmtd1 --leg.pos topright
# With no gene id (all genes compressed)
# docker run --rm -v $(pwd):/working-dir -w /working-dir rbase/iuta --gtf mm10_kg_sample_IUTA.gtf --bam1 sample_1.bam --bam2 sample_4.bam --fld empirical --test.type SKK,CQ,KY --n 1 --output IUTA_test_1 --groups 4,5 --leg.pos topright
