#物料管理-----
menu_book <- tabItem(tabName = "book",
                     fluidRow(
                       column(12,   tabBox(
                         title = "BOM同步工作台",width = 12,
                         # The id lets us use input$tabset1 on the server to find the current tab
                         id = "tabset_bomSync", height = "600px",
                         tabPanel("上传图号及物料匹配表", 
                                  tagList(
                                    fluidRow(
                                      column(4,     box(
                                        title = "选择数据", width = NULL, solidHeader = TRUE, status = "primary",
                                        mdl_download_button('map_tpl_dl','没有模板?请下载图号物料匹配表模板'),
                                        mdl_file(id = 'map_file_input',label = '请选择图号物料匹配表.xlsx文件'),
                                        textInput(inputId = 'map_sheetName',label = '页签名称',value = '图号物料匹配表'),
                                        
                                        actionBttn('map_data_preview','上传至服务器')
                                        #,
                                        #mdl_download_button('dmcombo_data_dl','下载DM清单查询结果')
                                        
                                      )),
                                      column(8,box(
                                        title = "选择数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                        div(style = 'overflow-x: scroll', mdl_dataTable('map_data_dataShow','BOM页签数据'))
                                      )))
                                  )),
                        
                       
                         tabPanel("物料导出到ERP", 
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