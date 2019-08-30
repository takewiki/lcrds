menu_row <- tabItem(tabName = "row",
                    fluidRow(
                      column(width = 4,
                             box(
                               title = "row", width = NULL, solidHeader = TRUE, status = "primary",
                               "Box content"
                             ),
                             box(
                               title = "Title 1", width = NULL, solidHeader = TRUE, status = "primary",
                               "Box content"
                             ),
                             box(
                               title = "Title 1", width = NULL, solidHeader = TRUE, status = "primary",
                               "Box content"
                             )
                      ),
                      
                      column(width = 4,
                             box(
                               title = "Title 1", width = NULL, solidHeader = TRUE, status = "primary",
                               "Box content"
                             ),
                             box(
                               title = "Title 1", width = NULL, solidHeader = TRUE, status = "primary",
                               "Box content"
                             ),
                             box(
                               title = "Title 1", width = NULL, solidHeader = TRUE, status = "primary",
                               "Box content"
                             )
                      ),
                      
                      column(width=4,
                             box(
                               title = "Title 1", width = NULL, solidHeader = TRUE, status = "primary",
                               "Box content"
                             ),
                             box(
                               title = "Title 1", width = NULL, solidHeader = TRUE, status = "primary",
                               "Box content"
                             ),
                             box(
                               title = "Title 1", width = NULL, solidHeader = TRUE, status = "primary",
                               "Box content"
                             )
                      )
                    )
)