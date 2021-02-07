del.outlayers.trip_duration<-function(data,dataframe,trip_duration_hrs){
  ###ELIMINAR OUTLAYERS

  cn_exp <-data
  
  #Quitamos los outlayes y hacemos un gr?fico de caja de bigotes
  
  i = 0
  out_cns = 1
  out_cns_list = c()
  
  while (is.na(out_cns)==FALSE){
    
    i=i+1
    out_cns=boxplot.default(cn_exp, main="Boxplot: datos listos",horizontal = T)$out[1]
    out_cns_list[i]=out_cns
    
    if (is.na(out_cns) == TRUE){
      db_cn_clean<-filter(dataframe, trip_duration_hrs < out_cns_list[i-1])
      return(db_cn_clean)
      break()
    }
    
    cn_exp = cn_exp[cn_exp<out_cns]
    
  }
}
