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

RUN Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite("Rsamtools");'
RUN Rscript -e 'install.packages("getopt");'

RUN wget https://raw.githubusercontent.com/upendrak/IUTA/master/run_IUTA.R
RUN chmod +x /run_IUTA.R && cp /run_IUTA.R /usr/bin

ENTRYPOINT ["run_IUTA.R"]
CMD ["-h"]

# Building and testing
# sudo docker build -t"=ubuntu/IUTA" .
# Running with out any arguments
# sudo docker run ubuntu/IUTA -h
# With test data
# sudo docker run --rm -v $(pwd):/working-dir -w /working-dir ubuntu/IUTA --gtf test_data/mm10_kg_sample_IUTA.gtf --bam1 test_data/sample_1.bam,test_data/sample_2.bam,test_data/sample_3.bam --bam2 test_data/sample_4.bam,test_data/sample_5.bam,test_data/sample_6.bam --fld normal --test.type SKK,CQ,KY --output test_data/new_ouput_test2 --groups 4,5 --gene.id Pcmtd1