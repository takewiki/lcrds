menu_row <- tabItem(tabName = "row",
                    fluidRow(
                      column(12,   tabBox(
                        title = "BOM查询工作台",width = 12,
                        # The id lets us use input$tabset1 on the server to find the current tab
                        id = "tabset_bomQuery", height = "600px",
                        tabPanel("上传数据", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       mdl_file('bq_file','请选择需要上传的BOM文件'),
                                       actionButton('bq_sheet_preview',"预览所有页签,已排除DM清单及采购价格"),
                                       
                                       mdl_text('bq_sheet_select','请选择指定页签,使用逗号,分隔如YE604B642,YE604B797,YE602B199,不选表示全部')
                                       
                                       ,
                                       actionBttn('bq_toGtab','跳转到G翻番表')
                                       #,
                                       #actionBttn('bq_upload','上传服务器')
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll', mdl_dataTable('bq_sheet_dataPreview','BOM页签数据'))
                                     )))
                                 )),
                        tabPanel("G番表", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       
                                       actionBttn('bq_formatG','格式化G番表'),
                                       actionBttn('bq_goLtab','跳转到L番表'),
                                       br(),
                                       br(),
                                       mdl_text('bq_Gtab_chartNo_input','请录入主图号'),
                                       actionButton('bq_Gtab_chartNo_preview','查询G番表'),
                                       mdl_download_button('bq_Gtab_chartNo_dl','下载G番表')
                                      
                                       
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll', mdl_dataTable('bq_Gtab_chartNo_dataShow','G表数据'))
                                     )))
                                 )),
                        tabPanel("L番表", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       #actionBttn('bq_readLT','读取L番表'),
                                       actionBttn('bq_formatL','格式化L番表')
                                       ,
                                       actionBttn('bq_goCalcBom','跳转到BOM运算'),
                                       br(),
                                       br(),
                                      
                                       mdl_text('bq_Ltab_chartNo_input','请录入主图号'),
                                       actionButton('bq_Ltab_chartNo_preview','查询L番表'),
                                       mdl_download_button('bq_Ltab_chartNo_dl','下载L番表')
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll', mdl_dataTable('bq_Ltab_chartNo_dataShow','L表数据'))
                                     )))
                                 )),
                        tabPanel("BOM运算", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       tags$h4("BOM运算是只在新的主图号的G番或L番发生更新，需要立即生效时使用"),
                                       tags$h4("方法：在上传数据指定了多个页签，然后执行此功能"),
                                       actionBttn('bq_calcBom','运算BOM,模拟G番L番代入')
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       'data here'
                                     )))
                                 )),
                        tabPanel("配件BOM速查", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       mdl_text('bq_spare_partNo','请输入配件号'),
                                       mdl_text('bq_spare_GNo','请输入G番号'),
                                       mdl_text('bq_spare_LNo','请输入L番号'),
                                       tags$h4("多个L番使用英文逗号,间隔;"),
                                       tags$h4("示例:L07,L08,L13,L27,LS01,LS17;"),
                                       tags$h4("不输入表示全部L番"),
                                    
                                       br(),
                                       actionBttn('bq_spare_preview','预览配件BOM'),
                                       mdl_download_button('bq_spare_download','下载到Excel')
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll', mdl_dataTable('bq_spare_dataShow',label =  '数据显示'))
                                     )))
                                 )),
                        tabPanel("DM批量更新", 
                                 tagList(
                                   fluidRow(
                                     column(3,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       mdl_file('bq_dm_file','请选择DM清单文件'),
                                       textInput(inputId = 'bq_dm_sheetName',label = '请选择DM清单所在页签',value = 'DM清单'),
                                       
                                       actionBttn('bq_DM_preview','预览DM更新明细'),
                                       br(),
                                       br(),
                                       mdl_download_button('bq_DM_download','下载DM更新明细')
                                       
                                     )),
                                     column(9,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll', mdl_dataTable('bq_DM_dataShow','显示DM明细数据'))
                                     )))
                                 )),
                        tabPanel("DM单个查询", 
                                 tagList(
                                   fluidRow(
                                     column(3,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                      
                                       textInput(inputId = 'dm1_dmno',label = '请输入需要查询的DM单号',value = 'DMP235000B1561920'),
                                       
                                       actionBttn('dm1_preview','查询指定DM单明细'),
                                       br(),
                                       br(),
                                       mdl_download_button('dm1_dl','下载DM单明细')
                                       
                                     )),
                                     column(9,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll', mdl_dataTable('dm1_dataShow','显示DM明细数据'))
                                     )))
                                 )),
                        
                        
                        tabPanel("BOM拆分上传", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       mdl_file(id = 'bom_split_file',
                                                label ='请上传销售订单上组合G番的物料列表.xlsx' ),
                                       tags$h4("第一次使用,请下载上传模板"),
                                       mdl_download_button(id = 'bom_split_tml_dl',label = '下载模板'),
                                       br(),
                                       actionBttn(inputId = 'bom_split_upload',label = '上传服务器'),
                                       mdl_download_button(id = 'bom_split_res_dl',label = '下载BOM拆分结果')
                                       
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll', mdl_dataTable('bom_split_dataShow','显示明细数据'))
                                     )))
                                 )),
                        tabPanel("BOM拆分查询", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       textInput(inputId = 'bom_split_query_txt',label = '请输入查询主图号多G番',value = ''),
                                       tags$h4('主图号为空表示全部'),
                                       actionButton(inputId = 'bom_split_query_btn',label = '查询'),

                                       mdl_download_button(id ='bom_split_query_dl' ,label = '下载')
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll', mdl_dataTable('bom_split_query_dataShow','显示明细数据'))
                                     )))
                                 )),
                        tabPanel("BOM导出到ERP", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       'operation here'
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       'data here'
                                     )))
                                 )),
                    
                        
                        tabPanel("BOM同步日志", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       'operation here'
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       'data here'
                                     )))
                                 ))
                      ))
                      
                    )
)
