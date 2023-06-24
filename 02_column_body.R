# BOM核价-------
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
                           tabPanel("价格来源1-采购发票价", 
                                    tagList(
                                      fluidRow(
                                        column(4,     box(
                                          title = "上传数据", width = NULL, solidHeader = TRUE, status = "primary",
                                          actionBttn('btn_purchase_ErpSyncDms','同步ERP最新采购单价至中台DMS'),
                                          shiny::h4('按图号查询最新采购单价,不输入表示全部'),
                                          tsui::mdl_text2(id = 'txt_purchasePrice_chartNo',label = '按图号查询',value = ''),
                                          actionBttn('btn_purchasePrice_DmsQuery','查询外购物料最新采购单价'),
                                          tsui::mdl_download_button(id = 'dl_purchsePrice',label = '下载采购单价')
                                          
                                          
                                        )),
                                        column(8,box(
                                          title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                          tsui::uiScrollX(tsui::mdl_dataTable(id = 'dt_purchasePrice_view'))
                                        )))
                                    )),
                           mdllcUI::lcUI(),
                           mdllcUI::priceModelUI(),
                           mdllcUI::dmCalcUI(),
                           mdllcUI::priceDetailUI(),
                           mdllcUI::priceSummaryUI()
                           
                        
                          
                         ))
                         
                       )
)