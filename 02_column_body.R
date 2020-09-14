menu_column <- tabItem(tabName = "column",
                       fluidRow(
                         column(12,   tabBox(
                           title = "BOM核价工作台",width = 12,
                           # The id lets us use input$tabset1 on the server to find the current tab
                           id = "tabset_bomCost", height = "600px",
                           tabPanel("DM配件混合查询", 
                                    tagList(
                                      fluidRow(
                                        column(4,     box(
                                          title = "选择数据", width = NULL, solidHeader = TRUE, status = "primary",
                                          mdl_download_button('dmbombo_tpl_dl','没有模板?请下载DM配件查询模板'),
                                          mdl_file(id = 'dmcombo_file_input',label = '请选择DM配件混合查询.xlsx文件'),
                                          textInput(inputId = 'dmcombo_sheetName',label = '页签名称',value = 'DM配件混合查询'),
                                          
                                          actionBttn('dmcombo_data_preview','批查查询'),
                                          mdl_download_button('dmcombo_data_dl','下载DM清单查询结果')
                                          
                                          
                                        )),
                                        column(8,box(
                                          title = "选择数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                          div(style = 'overflow-x: scroll', mdl_dataTable('dmcombo_data_dataShow','BOM页签数据'))
                                        )))
                                    )),
                           tabPanel("采购价格查询", 
                                    tagList(
                                      fluidRow(
                                        column(4,     box(
                                          title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                          actionBttn('bq_getWgPrice','获取外购物料价格')
                                          
                                        )),
                                        column(8,box(
                                          title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                          'data here'
                                        )))
                                    )),
                           tabPanel("采购价格维护", 
                                    tagList(
                                      fluidRow(
                                        column(4,     box(
                                          title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                          mdl_file('bq_wg_file','选择需要上传的采购物料'),
                                          actionBttn('bq_wg_filter','修改外购物料价格'),
                                          actionBttn('bq_wg_apply','应用价格')
                                          
                                    
                                          
                                          
                                        )),
                                        column(8,box(
                                          title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                          'data here'
                                        )))
                                    )),
                           tabPanel("DM核价明细表", 
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
                           tabPanel("DM核价汇总表", 
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