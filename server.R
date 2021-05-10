

#shinyserver start point----
 shinyServer(function(input, output,session) {
    #00-基础框设置-------------
    #读取用户列表
    user_base <- getUsers(conn_be,app_id)
    
    
    
    credentials <- callModule(shinyauthr::login, "login", 
                              data = user_base,
                              user_col = Fuser,
                              pwd_col = Fpassword,
                              hashed = TRUE,
                              algo = "md5",
                              log_out = reactive(logout_init()))
    
    
    
    logout_init <- callModule(shinyauthr::logout, "logout", reactive(credentials()$user_auth))
    
    observe({
       if(credentials()$user_auth) {
          shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
       } else {
          shinyjs::addClass(selector = "body", class = "sidebar-collapse")
       }
    })
    
    user_info <- reactive({credentials()$info})
    
    #显示用户信息
    output$show_user <- renderUI({
       req(credentials()$user_auth)
       
       dropdownButton(
          fluidRow(  box(
             title = NULL, status = "primary", width = 12,solidHeader = FALSE,
             collapsible = FALSE,collapsed = FALSE,background = 'black',
             #2.01.01工具栏选项--------
             
             
             actionLink('cu_updatePwd',label ='修改密码',icon = icon('gear') ),
             br(),
             br(),
             actionLink('cu_UserInfo',label = '用户信息',icon = icon('address-card')),
             br(),
             br(),
             actionLink(inputId = "closeCuMenu",
                        label = "关闭菜单",icon =icon('window-close' ))
             
             
          )) 
          ,
          circle = FALSE, status = "primary", icon = icon("user"), width = "100px",
          tooltip = FALSE,label = user_info()$Fuser,right = TRUE,inputId = 'UserDropDownMenu'
       )
       #
       
       
    })
    
    observeEvent(input$closeCuMenu,{
       toggleDropdownButton(inputId = "UserDropDownMenu")
    }
    )
    
    #修改密码
    observeEvent(input$cu_updatePwd,{
       req(credentials()$user_auth)
       
       showModal(modalDialog(title = paste0("修改",user_info()$Fuser,"登录密码"),
                             
                             mdl_password('cu_originalPwd',label = '输入原密码'),
                             mdl_password('cu_setNewPwd',label = '输入新密码'),
                             mdl_password('cu_RepNewPwd',label = '重复新密码'),
                             
                             footer = column(shiny::modalButton('取消'),
                                             shiny::actionButton('cu_savePassword', '保存'),
                                             width=12),
                             size = 'm'
       ))
    })
    
    #处理密码修改
    
    var_originalPwd <-var_password('cu_originalPwd')
    var_setNewPwd <- var_password('cu_setNewPwd')
    var_RepNewPwd <- var_password('cu_RepNewPwd')
    
    observeEvent(input$cu_savePassword,{
       req(credentials()$user_auth)
       #获取用户参数并进行加密处理
       var_originalPwd <- password_md5(var_originalPwd())
       var_setNewPwd <-password_md5(var_setNewPwd())
       var_RepNewPwd <- password_md5(var_RepNewPwd())
       check_originalPwd <- password_checkOriginal(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_originalPwd)
       check_newPwd <- password_equal(var_setNewPwd,var_RepNewPwd)
       if(check_originalPwd){
          #原始密码正确
          #进一步处理
          if(check_newPwd){
             password_setNew(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_setNewPwd)
             pop_notice('新密码设置成功:)') 
             shiny::removeModal()
             
          }else{
             pop_notice('两次输入的密码不一致，请重试:(') 
          }
          
          
       }else{
          pop_notice('原始密码不对，请重试:(')
       }
       
       
       
       
       
    }
    )
    
    
    
    #查看用户信息
    
    #修改密码
    observeEvent(input$cu_UserInfo,{
       req(credentials()$user_auth)
       
       user_detail <-function(fkey){
          res <-tsui::userQueryField(conn = conn_be,app_id = app_id,user =user_info()$Fuser,key = fkey)
          return(res)
       } 
       
       
       showModal(modalDialog(title = paste0("查看",user_info()$Fuser,"用户信息"),
                             
                             textInput('cu_info_name',label = '姓名:',value =user_info()$Fname ),
                             textInput('cu_info_role',label = '角色:',value =user_info()$Fpermissions ),
                             textInput('cu_info_email',label = '邮箱:',value =user_detail('Femail') ),
                             textInput('cu_info_phone',label = '手机:',value =user_detail('Fphone') ),
                             textInput('cu_info_rpa',label = 'RPA账号:',value =user_detail('Frpa') ),
                             textInput('cu_info_dept',label = '部门:',value =user_detail('Fdepartment') ),
                             textInput('cu_info_company',label = '公司:',value =user_detail('Fcompany') ),
                             
                             
                             footer = column(shiny::modalButton('确认(不保存修改)'),
                                             
                                             width=12),
                             size = 'm'
       ))
    })
    
    
    
    #针对用户信息进行处理
    
    sidebarMenu <- reactive({
       
       res <- setSideBarMenu(conn_rds('rdbe'),app_id,user_info()$Fpermissions)
       return(res)
    })
    
    
    #针对侧边栏进行控制
    output$show_sidebarMenu <- renderUI({
       if(credentials()$user_auth){
          return(sidebarMenu())
       } else{
          return(NULL) 
       }
       
       
    })
    
    #针对工作区进行控制
    output$show_workAreaSetting <- renderUI({
       if(credentials()$user_auth){
          return(workAreaSetting)
       } else{
          return(NULL) 
       }
       
       
    })
    
    

    #4.条码配货模块相关代码------- 
     file_ext_barcode <- var_file('file_ext_barcode')
    # 
    #   res <- res[,c('订单号',	'物料号'	,'二维码','备注')];
    #   
    #   if(len(ext_so) >0){
    #     res <- res[res$`订单号` == ext_so & !is.na(res$`订单号`),]
    #     print(res)
    #   }else(
    #     print(res)
    #   )
    #   res <- res[order(res$`二维码`,decreasing = rule_ext_sorted()),]
    #   return(res);
    #   
    # })
    # 
    # data_ext_barcode_pre <- reactive({
    #   res <-data_ext_barcode()
    #   # res <- head(res)
    #   return(res)
    #   
    # })
    # 
    # data_ext_barcode_db<- reactive({
    #   res <-data_ext_barcode()
    #   names(res) <-c('FSoNo','FChartNo','FBarcode','FNote')
    #   res$FNote <- tsdo::na_replace(res$FNote,'')
    #   res$FNote <- as.character(res$FNote)
    #   res$FSoNo <- as.character(res$FSoNo)
    #   #增值对订单号~有处理
    #   res$FChartNo <- lcrdspkg::soSplit(res$FChartNo)
    #   # res <- head(res)
    #   return(res)
    #   
    # })
    # 
    # data_ext_barcode_cn <- reactive({
    #   res <- data_ext_barcode_db()
    #   names(res) <-c('订单号','物料号(图号)','二维码','备注')
    #   return(res)
    #   
    # })
    # 
    #预览外部订单信息--------
    var_txt_FCalcNo <- var_text('txt_FCalcNo')
    observeEvent(input$btn_ext_barcode,{
      run_dataTable2('preview_ext_barcode',{
        lcrdspkg::extBarcode_read(file=file_ext_barcode(),FCalcNo = input$txt_FCalcNo,lang = 'cn' )
        
      })
    })
    
    var_barcode <- var_text('mo_chartNo')
    var_inner_sort <- var_ListChoose1('rule_inner_sorted')
    data_ext_barcode_db <-eventReactive(input$btn_ext_barcode,{
      res <-lcrdspkg::extBarcode_read(file=file_ext_barcode(),FCalcNo = input$txt_FCalcNo,lang = 'en' )
      res$FCalcNo <- as.integer(res$FCalcNo)
      return(res)
    })
    
    #处理上传事项
    observeEvent(input$btn_ext_barcode_upload1,{
      print(1)
      print(data_ext_barcode_db())
      print(2)
      
      tsda::upload_data(conn_bom,'takewiki_ext_barcode',data_ext_barcode_db())
      print(3)
      pop_notice('已上传服务器')
      print(4)
    })
    
    
    #内部条码标签
    data_inner_barcode <-reactive({
      data <-query_barcode_chartNo(fchartNo = var_barcode())
      #完善一下规则从1.6版本只显示图号，不显示其他信息
      return(data)
    })
    #完善相关数据-----
    #不再显示订单------
    #暂时不用，内部条件不再需要上传
    # data_inner_barcode_db <- reactive({
    #   data <- data_inner_barcode()
    #   names(data) <-c('FBarcode','FChartNo','FMoNo')
    #     ncount <- nrow(data)
    #     if(ncount >0){
    #      
    #      
    #       return(data)
    #     }else{
    #       pop_notice(paste0("图号",var_barcode(),"没有对应的生产任务单及条码信息，请确认"))
    #       return(data)
    #       
    #     }
    #    
    #   
    # })
    
    #查询相关数据
    observeEvent(input$btn_inner_barcode,{
      
      data <- data_inner_barcode()
      run_dataTable2('preview_inner_barcode',data = data)
      #处理下载事宜
      run_download_xlsx('btn_inner_barcodeDL',data = data,filename = '内部条码数据下载.xlsx')
    })
    
    
    
    #处理内部条码上传逻辑
    observeEvent(input$btn_inner_barcode_upload,{
      
      
      
      tsda::upload_data(conn,'takewiki_inner_barcode',data_inner_barcode_db())
      pop_notice('已上传服务器')
      #code here 
      
    })
    
    
    #处理智能匹配的内容
    
    data_barcode_match_db <- reactive({
      res <-barcode_match_preview2(conn,var_ext_so())
      return(res)
    })
    data_barcode_match_preview <- reactive({
      res <- data_barcode_match_db();
      #names(res) <-c('销售订单号','图号','外部二维码','内部二维码')
      return(res)
    })
    
    observeEvent(input$match_do,{
      #code here
      barcode_allocate_auto(conn,var_ext_so())
      pop_notice('智能匹配已完成！')
      
    })
    
    observeEvent(input$match_preview,{
      run_dataTable2('preview_match_barcode', data_barcode_match_preview())
      run_download_xlsx('match_dl',data = data_barcode_match_preview(),filename = '配货单.xlsx')
      
    })
    
    #人工修改
    books <- getBooks(var_ext_so())
    print(books)
    dtedit2(input, output,
            name = 'books',
            thedata = books,
            edit.cols = c('FBarcode_ext','FBarcode_inner'),
            edit.label.cols = c('外部二维码','内部二维码'),
            input.types = c(FBarcode_inner='textAreaInput'),
            #input.choices = list(fname = unique(unlist(books$fname))),
            view.cols = c('FSoNo','FChartNo','FBarcode_ext','FBarcode_inner'),
            view.captions = c('销售订单号','图号','外部二维码','内部二维码'),
            show.delete = F,
            show.update = T,
            show.insert = F,
            show.copy = F,
            callback.update = books.update.callback,
            callback.insert = books.insert.callback,
            callback.delete = books.delete.callback)
    
    
    
    #6.用户管理-----
    var_usr_file <- var_file('usr_file')
    
    
    data_user_add <- eventReactive(input$usr_preview,{
      
      res <-tsui::readUserFile(file = var_usr_file())
      return(res)
    })
    
    data_userName_New <- reactive({
      data <-data_user_add()
      res <- data$Fuser
      return(res)
    })
    
    observeEvent(input$usr_preview,{
      
      run_dataTable2('usr_info',data_user_add())
      
    })
    #批量新增按纽
    observeEvent(input$usr_upload,{
      
      newUser_flag <- caaspkg::getNewUsers(conn = conn_be,app_id = app_id,users = data_userName_New())
      print(newUser_flag)
      users_all <- data_user_add()
      users_filtered <- users_all[newUser_flag,]
      ncount <- nrow(users_filtered)
      if(ncount >0){
        tsui::userRight_upload(app_id = app_id,data = users_filtered)
        
        
        tsui::userInfo_upload(data = users_filtered,app_id = app_id)
        
        pop_notice(paste0('上传',ncount,"条用户记录！"))
        
      }else{
        pop_notice("上述用户已全部在系统中,请确认！")
        
      }
      
      
      
      
    })
    
   
   
   #处理BOM管理----
    
    
    #预览页签
    observeEvent(input$bq_sheet_preview,{
      
      file <- file_bom()
      data <- lcrdspkg::lc_bom_sheetName(file)
      data2 <- data.frame(`页签名称` = data,stringsAsFactors = F)
      run_dataTable2('bq_sheet_dataPreview',data2)
      
      
    })
    
    #跳转到G翻转表
    observeEvent(input$bq_toGtab,{
      updateTabsetPanel(session, "tabset_bomQuery",
                        selected = "G番表")
    })
    
    #格式化G翻转表
    file_bom <- var_file('bq_file')
    #选定的页答
    var_include_sheet <- var_text('bq_sheet_select')
    
    observeEvent(input$bq_formatG,{
      file <- file_bom()
      
      include_sheetNames <- var_include_sheet()
      print(include_sheetNames)
      if(is.null(include_sheetNames)){
        include_sheetNames <-NA
      }
      print(include_sheetNames)
      if(tsdo::len(include_sheetNames) == 0){
        include_sheetNames <-NA
      }
      
      print(include_sheetNames)
      lcrdspkg::Gtab_batchWrite_db(conn=conn_bom,file = file,include_sheetNames = include_sheetNames,show_progress = TRUE)
      
      pop_notice('G番表完成处理')
    })
    
    
    #处理下载数据--
    var_gtab_chartNo <- var_text('bq_Gtab_chartNo_input')
    
    data_gtab_dl <- eventReactive(input$bq_Gtab_chartNo_preview,{
      
      FchartNo <-var_gtab_chartNo()
      res <-lcrdspkg::Gtab_selectDB_byChartNo2(conn = conn_bom,FchartNo =FchartNo )
      return(res)
    })
    
    observeEvent(input$bq_Gtab_chartNo_preview,{
      
      data <- data_gtab_dl()
      FchartNo <-var_gtab_chartNo()
      filename <- paste0(FchartNo,"_G番表.xlsx")
      run_dataTable2('bq_Gtab_chartNo_dataShow',data = data)
      run_download_xlsx('bq_Gtab_chartNo_dl',data = data,filename = filename)
      
    })
    
    
    
    
    
    #跳转到L番表
    observeEvent(input$bq_goLtab,{
      updateTabsetPanel(session, "tabset_bomQuery",
                        selected = "L番表")
      
    })
    
    observeEvent(input$bq_formatL,{
      file <- file_bom()
      
      include_sheetNames <- var_include_sheet()
      print(include_sheetNames)
      if(is.null(include_sheetNames)){
        include_sheetNames <-NA
      }
      if(tsdo::len(include_sheetNames) == 0){
        include_sheetNames <-NA
      }
      print(include_sheetNames)
      lcrdspkg::Ltab_batchWrite_db(conn = conn_bom,file = file,include_sheetNames = include_sheetNames,show_progress = TRUE)
      pop_notice('L番表完成处理')
      
    })
    
    #处理L翻转表数据
    var_ltab_chartNo <- var_text('bq_Ltab_chartNo_input')
    
    data_ltab_dl <- eventReactive(input$bq_Ltab_chartNo_preview,{
      
      FchartNo <-var_ltab_chartNo()
      res <-lcrdspkg::Ltab_select_db2(conn=conn_bom,FchartNo = FchartNo)
      return(res)
    })
    
    observeEvent(input$bq_Ltab_chartNo_preview,{
      
      data <- data_ltab_dl()
      FchartNo <-var_ltab_chartNo()
      filename <- paste0(FchartNo,"_L番表.xlsx")
      run_dataTable2('bq_Ltab_chartNo_dataShow',data = data)
      run_download_xlsx('bq_Ltab_chartNo_dl',data = data,filename = filename)
      
    })
    
    
    #跳转到BOM运算
    
    observeEvent(input$bq_goCalcBom,{
      updateTabsetPanel(session, "tabset_bomQuery",
                        selected = "BOM运算")
      
      
      
    })
    #实现BOM运算逻辑
    observeEvent(input$bq_calcBom,{
      
      lcrdspkg::dm_dealAll2(conn=conn_bom,show_process = TRUE)
      pop_notice('BOM运算已完成')
      
      
      
    })
    
    #配置BOM速查---
    
    var_FchartNo <- var_text('bq_spare_partNo')
    var_FGtab <- var_text('bq_spare_GNo')
    var_FLtab <- var_text('bq_spare_LNo')
    db_bom_spare <- eventReactive(input$bq_spare_preview,{
      FchartNo <- var_FchartNo()
      FGtab <- var_FGtab()
      FLtab <- var_FLtab()
      
      res<- lcrdspkg::dm_selectDB_detail2(conn=conn_bom,FchartNo = FchartNo,FParamG = FGtab,FParamL = FLtab)
      return(res)
      
    })
    
    observeEvent(input$bq_spare_preview,{
      data <- db_bom_spare()
      
      run_dataTable2('bq_spare_dataShow',data = data)
      pop_notice('配件查询已完成')
      run_download_xlsx('bq_spare_download',data = data,filename = '配件BOM查询下载.xlsx')
    })
    
    #处理DM数据--
    var_file_dm <- var_file('bq_dm_file')
    #处理相关数据
    
    data_dm_detail <- eventReactive(input$bq_DM_preview,{
      file <- var_file_dm()
      print(file)
      sheetName <- input$bq_dm_sheetName
      print(sheetName)
      #res <- lcrdspkg::dm_queryAll(file = file,sheet = sheetName,conn = conn_bom)
      res <- lcrdspkg::dmList_Expand_Multi(file=file,sheet = sheetName,conn=conn_bom)
      #print(res)
      return(res)
    })
    
    observeEvent(input$bq_DM_preview,{
      print('A')
      data <- data_dm_detail()
      print(data)
      run_dataTable2('bq_DM_dataShow',data = data)
      run_download_xlsx('bq_DM_download',data = data,filename = 'DM清单明细.xlsx')
      
      
    })


    #DM单单个查询-------
    #var_dm1_dmno <- var_text('dm1_dmno')
    observeEvent(input$dm1_preview,{
      FDmNo = input$dm1_dmno
      print(FDmNo)
      data <-try(lcrdspkg::dmQuery1_readDB_cn(conn=conn_bom,FDmNo = FDmNo))
      run_dataTable2('dm1_dataShow',data = data)
      file_name <- paste0(FDmNo,"_DM清单明细查询.xlsx")
      run_download_xlsx(id = 'dm1_dl',data = data,filename = file_name)
    })
    
    
    #下载DM配件混合查询模板-----
     run_download_xlsx(id = 'dmbombo_tpl_dl',data = get_dmcombo_tpl(),filename = 'DM配件混合查询模板.xlsx')
    
    # DM配件混合查询
    var_dmcombo_file_input <- var_file("dmcombo_file_input")
    
    observeEvent(input$dmcombo_data_preview,{
      file <-var_dmcombo_file_input()
      sheetName <- input$dmcombo_sheetName
      data <- lcrdspkg::dmQuery_Batch_file(file = file,sheet = sheetName,conn = conn_bom)
      run_dataTable2('dmcombo_data_dataShow',data = data)
      file_name <- paste0("DM配件混合查询_",as.character(Sys.Date()),".xlsx")
      run_download_xlsx('dmcombo_data_dl',data = data,filename = file_name)
      
    })
    

    #针对物料匹配表进行处理---
   
    run_download_xlsx(id = 'map_tpl_dl',data = get_chartMtrlMap_tpl(),filename = '图号物料匹配表模板.xlsx')
    
    # DM配件混合查询
    var_map_file_input <- var_file("map_file_input")
    
    observeEvent(input$map_data_preview,{
      file <-var_map_file_input()
      sheetName <- input$map_sheetName
      data <- lcrdspkg::read_chartMtrlMapping(conn = conn_bom,file = file,sheet=sheetName)
      run_dataTable2('map_data_dataShow',data = data)
      pop_notice('已上传服务器！')
      
    })
    
    #下载模板
    run_download_xlsx('bom_split_tml_dl',data=get_bom_split_tpl(),filename = 'BOM拆分模板.xlsx')
    
    #上传服务器
    var_bom_split_file <- var_file('bom_split_file')
    observeEvent(input$bom_split_upload,{
      file <- var_bom_split_file()
      data <- readxl::read_excel(path = file,sheet = 'BOM拆分')
      FChartNo <- data$`图号`  
      res <- try(lcrdspkg::bom_split(mtrl_multiple_G = FChartNo))
      ncount <- nrow(res)
      if(ncount >0){
        info <- res
        #上传数据
        lcrdspkg::bom_split_upload(conn = conn_bom,data = info)
        names(info) <-c('序号','主图号','分录号','子图号')
        #上传数据
        rownames(info) <- NULL
      }else{
        info <- data.frame(`反馈结果`='没有查到任何数据',stringsAsFactors = F)
      }
      run_dataTable2('bom_split_dataShow',data = info)
      #提示信息
      pop_notice('数据已上传服务器!')
      file_res_name <- paste0("BOM拆分结果_",as.character(Sys.Date()),".xlsx")
      run_download_xlsx(id = 'bom_split_res_dl',data = info,filename = file_res_name)

      
      
    })
    
    #查询数据
    observeEvent(input$bom_split_query_btn,{
      
      data <- lcrdspkg::bom_split_query(conn=conn_bom,FBillNo = input$bom_split_query_txt)
      
      run_dataTable2('bom_split_query_dataShow',data = data)
      #下载
      file_res_name <- paste0("BOM拆分查询结果_",as.character(Sys.Date()),".xlsx")
      run_download_xlsx(id = 'bom_split_query_dl',data = data,filename = file_res_name)
    })
    
    #添加条码功能模板
    run_download_xlsx(id = 'ext_barCode_tpl_dl',data = get_extBarCode_tpl(),filename = '外部订单模板.xlsx')
    #订单备注信息处理
    run_download_xlsx(id = 'ext_soNote_tpl_dl',data = lcrdspkg::soNote_data_tpl(),filename = '技术订单备注上传模板.xlsx')
    run_download_xlsx(id = 'ext_soNote_tpl_dl2',data = lcrdspkg::soNote_data_tpl(),filename = '生产订单备注上传模板.xlsx')
    var_file_so_note <- var_file('file_so_note')
    var_file_so_note2 <- var_file('file_so_note2')
    observeEvent(input$btn_soNote_preview,{
      file = var_file_so_note()
      data_preview <- lcrdspkg::soNote_read(file = file)
      run_dataTable2(id = 'preview_soNote_dataView',data = data_preview)
      
      
    })
    
    #订单备注修改预览--------
    observeEvent(input$btn_soNote_preview2,{
      file = var_file_so_note2()
      data_preview <- lcrdspkg::soNote_read(file = file)
      run_dataTable2(id = 'preview_soNote_dataView2',data = data_preview)
      
      
    })
    
    #技术订单备注上传
    
    observeEvent(input$btn_soNote_upload,{
      file = var_file_so_note()
      # 上传到RDS服务器
      lcrdspkg::soNote_uploadDB(file = file,table_name = 't_lcrds_soNote',conn = conn_bom)
      pop_notice('订单备注已上传服务器')
      
      
    })
    #订单备注修改上传-----
    #生产订单备注上传----
    observeEvent(input$btn_soNote_upload2,{
      file = var_file_so_note2()
      # 上传到RDS服务器
      lcrdspkg::soNote_uploadDB(file = file,table_name = 't_lcrds_soNote2',conn = conn_bom)
      pop_notice('订单备注已上传服务器')
      
      
    })
    
    #处理运算单号----------
    observeEvent(input$btn_barCalc_getNumber,{
      calcNo <- as.character(  lcrdspkg::extBarcode_newId())
      updateTextInput(session = session,inputId = 'txt_FCalcNo',label = '条码配货运算单号(唯一运算批次号)',value = calcNo)
    })
    
    #处理订单备注批量查询-----
    var_btn_SOInfo_Date1 <- var_text('btn_SOInfo_Date1')
    var_btn_SOInfo_Date2 <- var_text('btn_SOInfo_Date2')
    
    observeEvent(input$btn_SOInfo_QueryRange,{
      FSoNo1 <- var_btn_SOInfo_Date1()
      FSoNo2 <-var_btn_SOInfo_Date2()
      data <- lcrdspkg::soNote_view_query(FSoNo1 = FSoNo1,FSoNo2 = FSoNo2)
      run_dataTable2('soNote_view_QueryView',data = data)
      #下载数据----
      run_download_xlsx('btn_SOInfo_QueryRange',data = data,filename = '订单备注批量下载.xlsx')
      
    })
    
    #条码隔离区下载模块-----
    #修复模板数据，提供模板数据数据
    #来源于RDS
    run_download_xlsx(id = 'file_SOInfo_seal_Tpl',data = lcrdspkg::barcode_ban_tpl(),filename = '条码隔离区下载模板.xlsx')
    #处理隔离区条码信息------
    var_file_SOInfo_seal <- var_file('file_SOInfo_seal')
    #添加到隔离区-------
    observeEvent(input$btn_seal_PutIn,{
      file <- var_file_SOInfo_seal()
      try(lcrdspkg::barCode_ban_add(file = file,conn = conn))
      pop_notice('添加到隔离区执行完成！')
      
    })
    #移动出隔离区---
    observeEvent(input$btn_seal_PushOut,{
      file <- var_file_SOInfo_seal()
      try(lcrdspkg::barCode_ban_rm(file=file,conn=conn))
      pop_notice('移动出隔离区执行完成！')
      
      
      
      
    })
    
    #工事番号排序合并-------
    
    var_lcmo_file_id <- var_file('lcmo_file_id')
    var_lcmo_itemCategory_Key <- var_text('lcmo_itemCategory_Key')
    observeEvent(input$lcmo_deal_button,{
      #处理代码:
      file_name <-var_lcmo_file_id()
      key_word <- var_lcmo_itemCategory_Key()
      data <- lcmopkg::mo_combine(file_name = file_name,key_word = key_word)
      #处理好的数据进行显示
      run_dataTable2('lcmo_data_dataShow',data = data)
      dl_name <- paste0('工事番号处理结果_',as.character(Sys.Date()),'.xlsx')
      #处理下载
      run_download_xlsx(id = 'lcmo_data_dl',data = data,filename = dl_name)
      
      
      
      
      
    })
    
    
})
