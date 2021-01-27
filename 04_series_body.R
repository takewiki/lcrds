# 条码配货-----
menu_series<- tabItem(tabName = "series",
                      fluidRow(
                        column(12,   tabBox(
                          title = "配货单列表",width = 12,
                          # The id lets us use input$tabset1 on the server to find the current tab
                          id = "tabset_sd", height = "600px",
                          tabPanel("SMEC外部标签", 
                                   tagList(
                                     fluidRow(
                                       column(4,     box(
                                         title = "外部标签", width = NULL, solidHeader = TRUE, status = "primary",
                                         mdl_file('file_ext_barcode','选择外部标签文件'),
                                         tags$h4('第一次使用,请下载外部订单模板.xlsx'),
                                         mdl_download_button('ext_barCode_tpl_dl',label = '下载外部订单条码模板'),
                                         tags$h4('按先进先出FIFO规则排序'),
                                         #mdl_ListChoose1('rule_ext_sorted','排序规则(外部标签)',list('二维码从小到大(升序)','二维码从大到小(降序)'),list(TRUE,FALSE),selected = TRUE),
                                         #mdl_ListChoose1('rule_ext_sorted2','处理规则',list(' 规则1','规则2'),list(FALSE,TRUE),selected = FALSE),
                                         #mdl_text('filter_ext_so','销售订单号'),
                                         actionButton('btn_barCalc_getNumber','获取条码配货运算单号'),
                                         br(),
                                         textInput('txt_FCalcNo','条码配货运算单号(唯一运算批次号)'),
                                         br(),
                                  
                                         
                                         actionButton('btn_ext_barcode','预览外部标签'),
                                         use_pop(),
                                         tags$h4('由于外部订单号本身唯一，不得重复上传!'),
                                         br(),
                                         actionButton('btn_ext_barcode_upload1','上传服务器')
                                         
                                       )),
                                       column(8,box(
                                         title = "预览外部标签内容", width = NULL, solidHeader = TRUE, status = "primary",
                                         div(style = 'overflow-x: scroll',mdl_dataTable('preview_ext_barcode',label = '预览外部标签内容'))
                                       )))
                                   )),
                          tabPanel("上传订单备注", 
                                   tagList(
                                     fluidRow(
                                       column(4,     box(
                                         title = "订单备注", width = NULL, solidHeader = TRUE, status = "primary",
                                         mdl_file('file_so_note','选择订单备注文件'),
                                         tags$h4('第一次使用,请下载订单备注模板.xlsx'),
                                         mdl_download_button('ext_soNote_tpl_dl',label = '下载模板'),
                                        
                                         actionButton('btn_soNote_preview','预览列表'),
                                         use_pop(),
                                         actionButton('btn_soNote_upload','上传服务器')
                                         
                                       )),
                                       column(8,box(
                                         title = "预览订单备注内容", width = NULL, solidHeader = TRUE, status = "primary",
                                         div(style = 'overflow-x: scroll',mdl_dataTable('preview_soNote_dataView',label = '预览订单备注内容'))
                                       )))
                                   )),

                          tabPanel("修改订单备注", 
                                   tagList(
                                     fluidRow(
                                       column(4,     box(
                                         title = "订单备注", width = NULL, solidHeader = TRUE, status = "primary",
                                         mdl_file('file_so_note2','选择需要修改的订单备注文件'),
                                         tags$h4('第一次使用,请下载外部订单备注模板.xlsx'),
                                         
                                         fluidRow( 
                                           column(12, mdl_download_button('ext_soNote_tpl_dl2',label = '下载模板'),
                                                  
                                                  actionButton('btn_soNote_preview2','预览内容'))
                                          ),
                                         br(),
                                         br(),
                                      
                                         fluidRow(column(12,actionButton('btn_soNote_upload2','上传服务器')) )
                                        
                                        
                                         
                                       ))
                                         
                                       ,
                                       column(8,box(
                                         title = "预览订单备注内容", width = NULL, solidHeader = TRUE, status = "primary",
                                         div(style = 'overflow-x: scroll',mdl_dataTable('preview_soNote_dataView2',label = '预览订单备注内容'))
                                       )))
                                   )),
                          tabPanel("查询订单备注", 
                                   tagList(
                                     fluidRow(
                                       column(4,     box(
                                         title = "订单备注", width = NULL, solidHeader = TRUE, status = "primary",
                                         mdl_text(id = 'btn_SOInfo_Date1','外部订单号从',value = '117583137'),
                                         mdl_text(id = 'btn_SOInfo_Date2','外部订单号到',value = '117583139'),
                                         
                                         actionButton('btn_SOInfo_QueryRange','批量查询'),
                                         mdl_download_button('btn_SOInfo_QueryRange',label = '下载备注')
                                         
                                       )),
                                       column(8,box(
                                         title = "预览订单备注内容", width = NULL, solidHeader = TRUE, status = "primary",
                                         div(style = 'overflow-x: scroll',mdl_dataTable('soNote_view_QueryView',label = '预览订单备注内容'))
                                       )))
                                   )),
                          tabPanel("LC内部标签查询", 
                                   tagList(fluidRow(
                                     column(4, box(
                                       title = "LC内部标签", width = NULL, solidHeader = TRUE, status = "primary",
                                       
                                       mdl_text('mo_chartNo','请输入图号:'),
                                       tags$h4('显示该图号所有的未匹配内部条码及订单备注信息'),
                                       #textInput('mo_fbillno','请输入任务单号',''),
                                       tags$h4('按先进先出FIFO规则排序'),
                                       #mdl_ListChoose1('rule_inner_sorted','排序规则(内部标签)',list('二维码从小到大(升序)','二维码从大到小(降序)'),list(TRUE,FALSE),selected = TRUE),
                                       actionButton('btn_inner_barcode','查询内部标签'),
                                       mdl_download_button('btn_inner_barcodeDL','下载内部标签')
                                       #内部条码仅仅提供查询，不再上传服务器
                                       #,
                                       #actionButton('btn_inner_barcode_upload','上传服务器')
                                     )),
                                     column(8,box(
                                       title = "预览内部标签内容", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll',mdl_dataTable('preview_inner_barcode',label = '预览内部标签内容'))
                                     ))))),
            
                          tabPanel("隔离LC条码", 
                                   tagList(
                                     fluidRow(
                                       column(4,     box(
                                         title = "操作区", width = NULL, solidHeader = TRUE, status = "primary",
                                         mdl_file('file_SOInfo_seal','选择需要隔离的条码信息'),
                                         tags$h4('第一次使用,请下载隔离条码模板.xlsx'),
                                         
                                         fluidRow( 
                                           column(12, mdl_download_button('file_SOInfo_seal_Tpl',label = '下载模板'),
                                                  
                                                  actionButton('btn_SOInfo_sealPreview','预览内容'))
                                         ),
                                         br(),
                                         br(),
                                         actionButton('btn_seal_PutIn','添加到隔离区'),
                                         actionButton('btn_seal_PushOut','移动出隔离区')
                                         
                                       )),
                                       column(8,box(
                                         title = "预览订单备注内容", width = NULL, solidHeader = TRUE, status = "primary",
                                         ''
                                       )))
                                   )),

                          tabPanel("标签智能匹配", 
                                   tagList(fluidRow(
                                     column(4,   box(
                                       title = "匹配规则", width = NULL, solidHeader = TRUE, status = "primary",
                                       
                                       
                                       actionButton('match_do','智能匹配'),
                                       actionButton('match_preview','预览配货单'),
                                       mdl_download_button('match_dl','下载配货单')
                                     )),
                                     column(8, box(
                                       title = "预览配货单内容", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll',mdl_dataTable('preview_match_barcode',label = '预览配货单内容'))
                                     ))))),
                          tabPanel("匹配日志查询", 
                                   tagList(fluidRow(
                                     column(4,   box(
                                       title = "匹配规则", width = NULL, solidHeader = TRUE, status = "primary",
                                       
                                       
                                       actionButton('match_Current_LogQuery','当前日志查询'),
                                       actionButton('match_Last3_LogQuery','最近3次日志查询'),
                                       mdl_download_button('match_log_download','下载日志')
                                     )),
                                     column(8, box(
                                       title = "预览配货单内容", width = NULL, solidHeader = TRUE, status = "primary",
                                       div(style = 'overflow-x: scroll',mdl_dataTable('match_log_dataShow',label = '预览配货单内容'))
                                     ))))),
                          tabPanel("标签人工修改", 
                                   tagList(fluidRow(
                                     column(4,   box(
                                       title = "匹配规则", width = NULL, solidHeader = TRUE, status = "primary",
                                       mdl_download_button('match_dl2','下载配货单')
                                       
                                     )),
                                     column(8, box(
                                       title = "预览配货单内容", width = NULL, solidHeader = TRUE, status = "primary",
                                       h3('预览配货单内容'),
                                       uiOutput('books')
                                     )))))
                        ))
                        
                      )
)
