library(shiny)
library(ggplot2)
library(dplyr)

df <- data.frame()
for (i in 1985:2018){
  i_char <- as.character(i)
  file_path <- paste("/Users/panzichen/EDAV_Class/Final_Data/",i_char,".csv", sep = "")
  Data <- read.csv(file = file_path)
  Data['Year'] <- i
  df=rbind(df,Data)
}

df_all<-data.frame()

for (i in 1985:2018){
  dftest<-subset(df,Year==i)
  df_all=rbind(df_all,dftest)
}

df_hw<- read.csv(file = "/Users/panzichen/EDAV_Class/HW/nba-players-stats/Players.csv")
df_hw$Player=sub("\\*.*", "", df_hw$Player)
df_hw$X <- NULL
df_hw<-unique(df_hw)
df_all$Player=sub("\\\\.*", "", df_all$Player)
df_all$Player=sub("\\*.*", "", df_all$Player)
df_all<-merge(x = df_all, y = df_hw,by = "Player", all.x = TRUE)

data_select <- df_all %>% select(Year, Player, Tm, G, Pos, FG., X3PA, X3P., X2PA, X2P., FTA, FT., ORB, DRB, TRB, AST, STL, BLK, PF, PTS, height, 
                                 weight, collage, born, birth_city, birth_state)
names(data_select) <- c("Year", "Player", "Team", "Games", "Position", "FG_Percent", "Three_Point_Attempt", "Three_Point_Percent", 
                        "Two_Point_Attempt", "Two_Point_Percent", "FT_Attempt", "FT_Percent", "Offensive_Rebounds", "Defensive_Rebounds", "Total_Rebounds", 
                        "Assist", "Steal", "Block", "Foul", "Points", "height", "weight", "college", "born", "birth_city", "birth_state")
data_select$Year <- factor(data_select$Year)

function(input, output) {
  
  dataset <- data_select
  
  output$plot <- renderPlot({
    
    p <- ggplot(dataset, aes_string(x=input$x, y=input$y)) + geom_point()
    
    if (input$color != 'None')
      p <- p + aes_string(color=input$color)
    
    facets <- paste(input$facet_row, '~', input$facet_col)
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)
    
    if (input$smooth)
      p <- p + geom_smooth()
    
    print(p)
    
  }, height=700)
  
}