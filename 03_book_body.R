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
                                  )),
                         tabPanel("新三菱订单格式转化器2023转2022版", 
                                  tagList(
                                    fluidRow(
                                      column(4,     box(
                                        title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                        mdl_file(id = 'lcmo_formatter_file_name',label = '请选择新三菱订单2023版XLSX'),
                                        tsui::uiTemplate(templateName = '新三菱订单模板2023转2022'),
                                        tags$h4('请输入EXCEL页签'),
                                        mdl_text2(id = 'lcmo_formatter_sheet_name',label = '请输入页签名',value = '2023新模板表'),
                                        actionBttn(inputId = 'lcmo_formatter_do',label = '格式转换'),
                                        mdl_download_button('lcmo_formatter_dl','下载处理结果')
                                        
                                        
                                      )),
                                      column(8,box(
                                        title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                        div(style = 'overflow-x: scroll', mdl_dataTable('lcmo_formatter_dv','新三菱订单数据'))
                                      )))
                                  )),
                         
                         tabPanel("工事番号合并", 
                                  tagList(
                                    fluidRow(
                                      column(4,     box(
                                        title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                        mdl_file(id = 'lcmo_file_id',label = '请选择数据源XLSX'),
                                        tsui::uiTemplate(templateName = '新三菱订单2022模板'),
                                        tags$h4('品名可以输入轿顶站|配电箱'),
                                        mdl_text2(id = 'lcmo_itemCategory_Key',label = '请输入品名',value = '轿顶站'),
                                        actionBttn(inputId = 'lcmo_deal_button',label = '排序合并'),
                                        mdl_download_button('lcmo_data_dl','下载处理结果')
                                        
                                        
                                      )),
                                      column(8,box(
                                        title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                        div(style = 'overflow-x: scroll', mdl_dataTable('lcmo_data_dataShow','BOM页签数据'))
                                      )))
                                  ))
                       ))
                       
                     )
)