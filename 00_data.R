

app_title <-'菱川电器数据处理平台5.8';

# store data into rdbe in the rds database
app_id <- 'lcrds'

#设置数据库链接---

conn_be <- conn_rds('rdbe')

#lcrdspkg::Gtab_batchWrite_db(file="DM线束 BOM-V3-611-final.xlsx")

#设置链接---

conn_bom <- conn_rds('lcrds')






#测试环境-------
#测试环境1
#conn <- conn_rds('lcdb')
#测试环境2
 # conn <- conn_rds('LCERP2')
# 正式环境------
cfg_lc <- tsda::conn_config(config_file = "cfg/conn_lc.R")

conn <- tsda::conn_open(conn_config_info = cfg_lc)
sql <- 'select top 10 * from takewiki_mo_barcode '
#mydata <- sql_select(conn,sql)
#View(mydata)


query_barcode <- function(fbillno ='0219070193',order_asc = TRUE){
  if (order_asc){
    str_a <-'asc'
  }else{
    str_a <-'desc'
  }
  sql <- paste0("select * from  takewiki_mo_barcode
where FBillNo ='",fbillno,"'
order by  FBarcode  ",str_a)
  r <- tsda::sql_select(conn,sql)
  return(r)
  
}

# 内部条码标签查询-----
query_barcode_chartNo <- function(fchartNo ='P207012C134G01'){
    #删除不需要的字段
    
  
  sql <- paste0("select FBarcode as '二维码',FChartNumber '图号',FBillNo as '生产任务单号',FSoInfoNote as '订单信息备注' from  takewiki_mo_barcode
where FChartNumber ='",fchartNo,"'  order by  FBarcode  ")
  print(sql)
  r <- tsda::sql_select(conn,sql)
  return(r)

}


#查询外部条码----
#针对外部条码进行处理
#增加了两个字段，不知道是否会有影响
get_extBarCode_bySo <- function(conn_bom){
  sql <-paste0("SELECT  [FSoNo] 
      ,[FChartNo]
      ,[FBarcode]
	  ,FNote_Tech  as FNote    
      ,[FFlag_112] as FFlag
   
  FROM [lcrds].[dbo].[v_lcrds_soNoteQuery]
  where FCalcNo
in
(select max(FCalcNo) as FCalcNo_Max from takewiki_ext_barcode)")
  res <- tsda::sql_select(conn,sql)
  return(res)
}


# get_extBarCode_bySo <- function(conn,fbillno='bbc'){
#   sql <-paste0("select FSoNo ,FChartNo,FBarcode from takewiki_ext_barcode
# where FSoNo ='",fbillno,"'")
#   res <- tsda::sql_select(conn,sql)
#   return(res)
# }

#查询内部条码------
get_innerBarCode_bySo <- function(conn,fbillno='bbc'){
  sql <-paste0("select FSoNo ,FChartNo,FBarcode from takewiki_inner_barcode
where FSoNo ='",fbillno,"'")
  res <- tsda::sql_select(conn,sql)
  return(res)
  
}


alloc_barcode <- function(data_ext,data_inner){
  ncount_ext <- nrow(data_ext);
  ncount_inner <- nrow(data_inner);
  #按图事情进行分解
  data_ext_split <- split(data_ext, data_ext$FChartNo);
  #检查外部条码可以分解为图号数量
  ncount_chartNo <- length(data_ext_split);
  r <-lapply(1:ncount_chartNo, function(i){
    data_ext_chartNo <-data_ext_split[[i]];
    chartNoItem <- unique(data_ext_chartNo$FChartNo);
    data_inner_chartNo <-data_inner[data_inner$FChartNo == chartNoItem ,'FBarcode',drop=FALSE];
    ncount_data_inner_chartNo <- nrow(data_inner_chartNo);
    if(ncount_data_inner_chartNo >0){
      #print(class(data_ext_chartNo))
      #print(class(data_inner_chartNo))
      res <- tsdo::allocate(data_ext_chartNo,data_inner_chartNo)
      #res <- as.data.frame(res)
      #print(class(res))
      return(res)
    }else{
      
    }
    
    
  })
  #print(r)
  res <- do.call('rbind',r)
  names(res)<-c('FSoNo','FChartNo','FBarcode_ext','FBarcode_inner')
  return(res)
  
}

#自动分配的函数处理自动分配
barcode_allocate_auto <-function(conn_bom,conn){
  data_ext <-get_extBarCode_bySo(conn_bom);
  data_inner <-get_innerBarCode_bySo(conn);
  res <- alloc_barcode(data_ext,data_inner);
  if(nrow(res) >0){
    tsda::upload_data(conn,'takewiki_barcode_allocate_auto',res)
  }
}

#显示预览数据

barcode_match_preview2 <- function(conn,fbillno='bbc'){
  sql <- paste0("select  
FBarcode_ext as 外部客户标签,
FBarcode_inner as 内部标签,
FNumber as 物料代码,
FName as 品名,
FModel as 规格,
b.FBatchNo as 批次,
b.FQty   as 数量 ,
'' as 是否换标 from  takewiki_barcode_allocate_auto a
inner join takewiki_mo_barcode b
on a.FBarcode_inner = b.FBarcode
where a.FSoNo = '",fbillno,"'")
  r <- tsda::sql_select(conn,sql)
  return(r)
}




barcode_match_preview <- function(conn,fbillno='bbc'){
  sql <- paste0("select * from takewiki_barcode_allocate_auto
where FSoNo = '",fbillno,"'")
  r <- tsda::sql_select(conn,sql)
  return(r)
}



#修改配货单
getBooks <- function(fbillno='bbc') {
  res <- barcode_match_preview(conn,)
}



##### Callback functions.
books.insert.callback <- function(data, row ,table='t_test',f=getBooks,id_var='fid') {
  sql_header <- sql_gen_insert(conn,table)
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-nrow(fieldList)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Insert <-fieldList[i,'FFieldName']
    type <-fieldList[i,'FTypeName']
    if(col_Insert == id_var){
      res[i] <-paste0(' ',getMax_id(conn,table,id_var),' ')
    }else{
      res[i] <- format_to_sqlInsert(type)(data[row,col_Insert])
    }
    
  }
  sql_body <- paste0(res,collapse = ',')
  query <-paste0(sql_header,sql_body,")")
  
  print(query) # For debugging
  tsda::sql_update(conn, query)
  return(f())
}

books.update.callback <- function(data, olddata, row,
                                  table='takewiki_barcode_allocate_auto',
                                  f=getBooks,
                                  edit.cols = c('FBarcode_ext','FBarcode_inner'),
                                  id_var='FBarcode_ext',
                                  fbillno='bbc') 
{
  sql_header <- sql_gen_update(table);
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-length(edit.cols)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Update <-edit.cols[i]
    #col_Insert <-fieldList[fieldList$,'FFieldName']
    type <-fieldList[fieldList$FFieldName == col_Update,'FTypeName']
    res[i] <- paste0(' ',col_Update,' = ',format_to_sqlUpdate(type)(data[row,col_Update]))
    
    
  }
  sql_body <- paste0(res,collapse = ',')
  sql_tail <-paste0(' where ',id_var," = '",data[row,id_var],"'")
  query <- paste0(sql_header,sql_body,sql_tail)
  
  print(query) # For debugging
  tsda::sql_update(conn, query)
  return(f(fbillno))
}

books.delete.callback <- function(data, row ,table ='takewiki_barcode_allocate_auto',f=getBooks,id_var='FBarcode_ext',fbillno='bbc') {
  sql_header <- sql_gen_delete(table);
  sql_tail <-paste0('  ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_tail)
  
  #query <- paste0("DELETE FROM  ",table,"  WHERE id = ", data[row,]$id)
  print(query)
  tsda::sql_update(conn, query)
  return(f(fbillno))
}



#模板数据

get_dmcombo_tpl <- function(){

 res <- readxl::read_excel("www/DM配件混合查询.xlsx", 
                            sheet = "DM配件混合查询")
 res <- list(res)
 names(res) <-"DM配件混合查询"
 return(res)
  #View(dmcombo_tpl)
}

#图号与物料对照表

get_chartMtrlMap_tpl <- function() {
  res  <- readxl::read_excel("www/图号物料匹配表.xlsx", 
                                 sheet = "图号物料匹配表")
  res <- list(res)
  names(res) <-"图号物料匹配表"
  return(res)
  
}


# 生产订单拆分模板
get_bom_split_tpl <- function(){
  data <- data.frame(`序号` = 1:2,`图号`=c('P203031A112G08G02G01G21G34G10G06G44G31','P203031A112G08G02G01G21G34G10G06G44G32'),stringsAsFactors = F)
  res <- list(data)
  names(res) <-'BOM拆分'
  return(res)
  
}



get_extBarCode_tpl <- function(){
  #library(readxl)
  so_smec_tpl <- readxl::read_excel("www/so_smec_tpl.xlsx", 
                            sheet = "外部条码")
  res <-list(so_smec_tpl)
  names(res) <-'外部条码'
  return(res)
}

