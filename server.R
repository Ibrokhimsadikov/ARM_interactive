
shinyServer(function(input, output) {
  
  rules_cool<-reactive({
    
    rule12 <- apriori(transactions, parameter = list(support = as.numeric(input$sup), confidence = as.numeric(input$conf), minlen=2, maxlen=5))
    rules_table<-data.table(lhs=labels(lhs(rule12)), rhs=(labels(rhs(rule12))), quality(rule12))
    
  })
  
  output$rules = DT:: renderDataTable({
    
    
    
    rules_cool()
    
  })
  
  ## Download data to csv ########################
  
  output$downloadData <- downloadHandler(
    filename = function() {
      #paste("test.csv", sep="")
    },
    
    content = function(file) {
      write.csv(rules_cool(), file)
    }
  )
  
  ###VisNETWORK
  
  output$network <- renderVisNetwork({
    subrules2 <- head(sort(rules1, by="confidence"),input$xcol)
    ig <- plot( subrules2, method="graph", control=list(type="items") )
    ig_df <- get.data.frame( ig, what = "both" )
    nodesv <- data.frame(
      id = ig_df$vertices$name
      ,value = ig_df$vertices$support # could change to lift or confidence
      ,title = ifelse(ig_df$vertices$label == "",ig_df$vertices$name, ig_df$vertices$label)
      ,ig_df$vertices
    ) 
    edgesV = ig_df$edges
    visNetwork(nodes = nodesv, edges = edgesV, main = "Most Significant Assossiation Rules") %>%
      visNodes(size = 10) %>%
      visLegend() %>%
      visEdges(smooth = FALSE) %>%
      visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
      visInteraction(navigationButtons = TRUE) %>%
      visEdges(arrows = 'from') %>%
      visPhysics(
        solver = "barnesHut",
        maxVelocity = 35,
        forceAtlas2Based = list(gravitationalConstant = -6000)
      ) 
  })
  
})