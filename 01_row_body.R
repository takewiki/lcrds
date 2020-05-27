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
                                       'operation here'
                                       
                                     )),
                                     column(8,box(
                                       title = "上传数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                       'data here'
                                     )))
                                 )),
                        tabPanel("G番表", 
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
                        tabPanel("L番表", 
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
                        tabPanel("配件BOM速查", 
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
                        tabPanel("DM清单", 
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