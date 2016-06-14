bar_compare<-function(gene.name,n1,estimates.file="estimates.txt",output.file=paste("Barplot_",gene.name,".pdf",sep=""),legend.pos="topright",group.name=c("1","2")){
    estimates<-read.delim(estimates.file,stringsAsFactors=FALSE,comment.char="#")
    estimates.gene<-estimates[estimates[,1]==gene.name,,drop=FALSE]

    if (nrow(estimates.gene)==0 | sum(is.na(estimates.gene[1,-(1:2)]))==(ncol(estimates.gene)-2)){
        try("No data for the input gene! \n")
    }
    else{
        isoforms<-estimates.gene[,2]
            usage.data<-t(estimates.gene[,-(1:2)])

        pdf(output.file)
        barplot(usage.data[complete.cases(usage.data),,drop=FALSE],main=paste("Estimated isoform usages for ",gene.name,"\n in ",sum(complete.cases(usage.data)[1:n1]),"+",sum(complete.cases(usage.data)[-(1:n1)])," samples", sep=""),names.arg=isoforms,xlab="Isoform",ylab="Relative abundance",beside=T,col=c(rep("red",n1),rep("green",nrow(usage.data)-n1))[complete.cases(usage.data)],cex.names=max(1.2-length(isoforms)/12,0.1))
        legend(legend.pos,legend=group.name,fill=c("red","green"),cex=0.9)
            dev.off()

        
    }
}

