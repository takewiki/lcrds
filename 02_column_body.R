menu_column <- tabItem(tabName = "column",
                       fluidRow(
                         column(12,   tabBox(
                           title = "BOM核价工作台",width = 12,
                           # The id lets us use input$tabset1 on the server to find the current tab
                           id = "tabset_bomCost", height = "600px",
                           tabPanel("选择数据", 
                                    tagList(
                                      fluidRow(
                                        column(4,     box(
                                          title = "选择数据", width = NULL, solidHeader = TRUE, status = "primary",
                                          'operation here'
                                          
                                        )),
                                        column(8,box(
                                          title = "选择数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                          'data here'
                                        )))
                                    )),
                           tabPanel("采购价格查询", 
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
                           tabPanel("采购价格维护", 
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