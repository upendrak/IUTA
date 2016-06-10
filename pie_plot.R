pie_plot<-function(mean.IU,isoforms,gene.name,output.file,group,output.screen){
	n.isoform<-length(isoforms)
	color.pie<-as.vector(t(sapply(seq(1,0.1,length.out=n.isoform/5),function(i)rainbow(5,s=i))))

	if (nrow(mean.IU)==2){
		pdf(output.file,width=17)

		par(mar=c(0,0,0,0),oma=c(0,0,10,0),bg="seashell")
		layout(matrix(1:3,nrow=1),widths=c(2,1,2))
		pie(mean.IU[1,],col=color.pie,labels=ifelse(round(mean.IU[1,],3)<0.005,NA,paste(round(mean.IU[1,],3)*100,"%",sep="")),cex=max(0.5,1.71-0.121*sqrt(n.isoform)),radius=0.9)
		mtext(group[1],cex=2)
		plot.new()
		legend("center",legend=isoforms,title="Isoform",fill=color.pie,bty="n",cex=max(0.2,3.25-sqrt(n.isoform)*0.25),ncol=ifelse(n.isoform>10,2,1))
		pie(mean.IU[2,],col=color.pie,labels=ifelse(round(mean.IU[2,],3)<0.005,NA,paste(round(mean.IU[2,],3)*100,"%",sep="")),cex=max(0.5,1.71-0.121*sqrt(n.isoform)),radius=0.9)
		mtext(group[2],cex=2)
		mtext(paste("Pie charts for gene ",gene.name,sep=""),outer=TRUE,cex=2.5,line=5,font=2)

		dev.off()

		if (output.screen){
	                par(mar=c(0,0,0,0),oma=c(0,0,10,0),bg="seashell")
        	        layout(matrix(1:3,nrow=1),widths=c(2,1,2))
                	pie(mean.IU[1,],col=color.pie,labels=ifelse(round(mean.IU[1,],3)<0.005,NA,paste(round(mean.IU[1,],3)*100,"%",sep="")),cex=max(0.5,1.71-0.121*sqrt(n.isoform)),radius=0.9)
	                mtext(group[1],cex=2)
        	        plot.new()
	                legend("center",legend=isoforms,title="Isoform",fill=color.pie,bty="n",cex=max(0.5,3.25-sqrt(n.isoform)*0.25),ncol=ifelse(n.isoform>5,2,1))
        	        pie(mean.IU[2,],col=color.pie,labels=ifelse(round(mean.IU[2,],3)<0.005,NA,paste(round(mean.IU[2,],3)*100,"%",sep="")),cex=max(0.5,1.71-0.121*sqrt(n.isoform)),radius=0.9)
	                mtext(group[2],cex=2)
        	        mtext(paste("Pie charts for gene ",gene.name,sep=""),outer=TRUE,cex=2.5,line=5,font=2)
		}
	}
	else{
		pdf(output.file,width=10)

		par(mar=c(0,0,0,0),oma=c(0,0,10,0),bg="seashell")
		layout(matrix(1:2,nrow=1),widths=c(7,3))
		pie(mean.IU[1,],col=color.pie,labels=ifelse(round(mean.IU[1,],3)<0.005,NA,paste(round(mean.IU[1,],3)*100,"%",sep="")),cex=max(0.5,1.71-0.121*sqrt(n.isoform)),radius=0.9)
		mtext(group,cex=2)
	        plot.new()
        	legend("center",legend=isoforms,title="Isoform",fill=color.pie,bty="n",cex=max(0.5,3.25-sqrt(n.isoform)*0.25),ncol=ifelse(n.isoform>5,2,1))
		mtext(paste("Pie chart for gene ",gene.name,sep=""),outer=TRUE,cex=2.5,line=5,font=2)
		
		dev.off()
		
		if (output.screen){
	                par(mar=c(0,0,0,0),oma=c(0,0,10,0),bg="seashell")
        	        layout(matrix(1:2,nrow=1),widths=c(7,3))
	                pie(mean.IU[1,],col=color.pie,labels=ifelse(round(mean.IU[1,],3)<0.005,NA,paste(round(mean.IU[1,],3)*100,"%",sep="")),cex=max(0.5,1.71-0.121*sqrt(n.isoform)),radius=0.9)
        	        mtext(group,cex=2)
	                plot.new()
        	        legend("center",legend=isoforms,title="Isoform",fill=color.pie,bty="n",cex=max(0.5,3.25-sqrt(n.isoform)*0.25),ncol=ifelse(n.isoform>5,2,1))
                	mtext(paste("Pie chart for gene ",gene.name,sep=""),outer=TRUE,cex=2.5,line=5,font=2)
		}
	}
}
