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
                                       actionBttn('bq_preview','预览BOM数据')
                                       #,
                                       #actionBttn('bq_upload','上传服务器')
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       mdl_dataTable('bq_dataPreview','BOM数据预览')
                                     )))
                                 )),
                        tabPanel("G番表", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       actionBttn('bq_readGT','读取G番表'),
                                       actionBttn('bq_formatG','格式化G番表'),
                                       actionBttn('bq_G_upload','上传服务器')
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       'data here'
                                     )))
                                 )),
                        tabPanel("L番表", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       actionBttn('bq_readLT','读取L番表'),
                                       actionBttn('bq_formatL','格式化L番表'),
                                       actionBttn('bq_L_upload','上传服务器')
                                       
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
                                       actionBttn('bq_spare_preview','预览配件BOM'),
                                       mdl_download_button('bq_spare_download','下载到Excel')
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       'data here'
                                     )))
                                 )),
                        tabPanel("DM清单", 
                                 tagList(
                                   fluidRow(
                                     column(4,     box(
                                       title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                       mdl_text('bq_DM_billNo','请输入DM单号'),
                                       mdl_text('bq_DM_VerNo','请输入版本号'),
                                       
                                       actionBttn('bq_DM_preview','预览DM-BOM'),
                                       mdl_download_button('bq_DM_download','下载到Excel')
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       'data here'
                                     )))
                                 ))
                      ))
                      
                    )
)
