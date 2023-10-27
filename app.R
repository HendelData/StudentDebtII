library(shiny)
library(svDialogs)
library(DT)

#GET SAVED COLLEGE SCORECARD DATA
sc_display <- read.csv("./scdata.csv")
colnames(sc_display) <- c("Institution","Major","Avg Debt","Avg Payment","Salary 1 Yr","Salary 4 Yr","Projected Salary 10 Yr")

#CREATE LIST OF MAJORS FOR DROP-DOWN BOX
major_list <- sc_display[!duplicated(sc_display$Major), ]
major_list <- sort(major_list[,2])

#UI
ui <- fluidPage(
  titlePanel("Student Debt and Future Income by Undergraduate Major"),
  
  #CREATE A ROW FOR THE SELECTION BOXES
  fluidRow(
    column(12,
           selectInput(inputId = "major",
                       label = "Major:",
                       choices = major_list)
    )
  ),
  
  #NEW ROW FOR THE TABLE
  DT::dataTableOutput("table")
)


#SERVER
server <- function(input, output) {
  
  #FORMAT THE DATA
  output$table <- DT::renderDataTable(DT::datatable(rownames=FALSE, {
    sc_display <- sc_display[order(-sc_display$`Salary 1 Yr`),]
    sc_display$`Avg Debt` <- paste0("$", formatC(sc_display$`Avg Debt`, big.mark=",", format="d", digits=0))
    sc_display$`Avg Payment` <- paste0("$", formatC(sc_display$`Avg Payment`, big.mark=",", format="d", digits=0))
    sc_display$`Salary 1 Yr` <- paste0("$", formatC(sc_display$`Salary 1 Yr`, big.mark=",", format="d", digits=0))
    sc_display$`Salary 4 Yr` <- paste0("$", formatC(sc_display$`Salary 4 Yr`, big.mark=",", format="d", digits=0))
    sc_display$`Projected Salary 10 Yr` <- paste0("$", formatC(sc_display$`Projected Salary 10 Yr`, big.mark=",", format="d", digits=0))

    sc_display <- sc_display[sc_display$Major==input$major,]
    sc_table <- sc_display[,-2]
    sc_table
  }))
}

#CREATE SHINY APP
shinyApp(server=server, ui=ui)
