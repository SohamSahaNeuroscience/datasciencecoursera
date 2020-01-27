x<-data.frame("var1"= sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
x<-x[sample(1:5),]; x$var2[c(1,3)]=NA
