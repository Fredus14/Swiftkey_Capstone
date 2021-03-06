require(shiny)
require(markdown)

shinyUI(
    navbarPage("Coursera NLP Capstone", inverse = FALSE, collapsible = FALSE, 
               tabPanel("Prediction", 
                        fluidRow(
                            sidebarPanel(width=3,
                                         h5("Text Input:"),
                                         textInput("entry", 
                                                   "After initial loading (which takes about 8 seconds) this app will predict the next word in the sentence enterd below:",
                                                   "Thanks for stopping by"),
                                         # submitButton('Predict'),
                                         ## sliderInput("max", 
                                                     ## h5("Maximum Number of Words:"), 
                                                     ## min = 10,  max = 200,  value = 100),
                                         br(),
                                         ## actionButton("update", "Update Word Cloud"),
                                         hr(),
                                         helpText(h5("Help Instruction:")),
                                         helpText("To predict the nesxt word in the sentence:"),
                                         helpText("1. Type your sentence in the text field", style="color:#428ee8"),
                                         helpText("2. The value will be passed to the model while you are typing.", style="color:#428ee8"),
                                         helpText("3. Obtain the predictions below.", style="color:#428ee8"),
                                         hr(),
                                         helpText(h5("Note:")),
                                         helpText("
                                                  After the app is 100% loaded you will see the prediction
                                                  for the default sentence example \"Thanks for stopping by\"
                                                  on the right side."),
                                         hr(),
                                         h6("This App is built for:"),
                                         a("Coursera Data Science Capstone", href="https://www.coursera.org/course/dsscapstone"),
                                         p("class started on 9 March 2015"),
                                         hr(),
                                         ##h6("For more information about Ben Apple:"),
                                         ##a(img(src = "GitHub-Mark.png", height = 30, width = 30),href="https://github.com/bengapple/Swiftkey_Capstone"),
                                         ##a(img(src = "linkedin.png", height = 26, width = 26),href="https://www.linkedin.com/in/ivanliu1989"),
                                         ##a(img(src = "gmail.jpeg", height = 30, width = 30),href="mailto: ivan.liuyanfeng@gmail.com"),
                                         br()
                                         ),
                            mainPanel(
                                column(5,
                                       h3("Word Prediction"),hr(),
                                       h5('The sentence you just typed:'),                             
                                       wellPanel(span(h4(textOutput('sent')),style = "color:#428ee8")),
                                       hr(),
                                       h5('Single Word Prediction:'),
                                       wellPanel(span(h4(textOutput('top1')),style = "color:#e86042")),
                                       hr(),
                                       h5('Other Possible Single Word Predictions:'),
                                       wellPanel(span(h5(textOutput('top2')),style = "color:#2b8c1b"),
                                                 span(h5(textOutput('top3')),style = "color:#2b8c1b"),
                                                 span(h5(textOutput('top4')),style = "color:#2b8c1b"),
                                                 span(h5(textOutput('top5')),style = "color:#2b8c1b")),
                                       hr(),
                                       
                                       p()
                                ),
                                column(5,
                                       h3(" "),
                                       
                                       # plotOutput("wordCloud"), # wordcloud
                                       br()
                                 )
                                )
                            )
               ),
               tabPanel("Model/Algorithm",
                        sidebarLayout(
                            sidebarPanel(width=3,
                                         helpText(h5("Help Instruction:")),
                                         helpText("Please switch the panels on the right side to figure out:"),
                                         helpText("1. How is the word being predicted?", style="color:#428ee8"),
                                         helpText("2. How does this App work?", style="color:#428ee8"),
                                         helpText("3. Key concepts / techniques implemented in model", style="color:#428ee8"),
                                         hr(),
                                         helpText(h5("Note:")),
                                         helpText("For more information, you can go to", code("Documents tab"), "in the navi bar
                                                  to read relevant intrim report and final report of this data product."),
                                         hr(),
                                         h6("This App is built for:"),
                                         a("Coursera Data Science Capstone", href="https://www.coursera.org/course/dsscapstone"),
                                         p("class started on 9 March 2015"),
                                         hr(),
                                         ##h6("For more information about Ben Apple:"),
                                         ##a(img(src = "GitHub-Mark.png", height = 30, width = 30),href="https://github.com/bengapple/Swiftkey_Capstone"),
                                         ##a(img(src = "linkedin.png", height = 26, width = 26),href="https://www.linkedin.com/in/ivanliu1989"),
                                         ##a(img(src = "gmail.jpeg", height = 30, width = 30),href="mailto: ivan.liuyanfeng@gmail.com"),
                                         br(),hr()
                                         ),
                            mainPanel(
                                tabsetPanel(type="tabs",
                                            tabPanel("Predictive Model",                                                      
                                                     h3("Predictive Model Establishment"),hr(),
                                                     h4("Clean the training dataset"),
                                                     p("The dataset was cleaned using the tokenization and ngramify
                                                       functions. They are able to help users tokenize and ngramify
                                                       the text data in an automatic way and allow user to split large datasets into a number of
                                                       user defined small ones in order to reduce the processing time and avoid the 
                                                       memory limits inherent to R"),
                                                     p("The raw text datasets are about 580M in total- en_US.blogs.txt-210M,
                                                       en_US.news.txt-206M, and en_US.twitter.txt-167M"),
                                                     p("After the preprocessing to the datasets including cleaning, tokenizing and ngramifing, 
                                                       the three raw datasets are combined and then 1-4 grams frequency matrix are built. 
                                                       The total size of new dataset is reduced to 36M."),
                                                     hr(),
                                                     h4("Build the model"),
                                                     p(a("Simple Good-Turing", href = "https://class.coursera.org/nlp/lecture/32"),
                                                       'and Back off techniques were used for estimating the probabilities corresponding to the observed frequencies, 
                                                       and the joint probability of all unobserved species. The last three words of users\' input sentence will be extracted first and used
                                                       for seach in 4-grams matrix. If none result is return, then we will move back to 3-grams, and then 2-grams and 1-gram.
                                                       the final predictions will be chosen accordingly by the frequency and n-grams of the model.' ),                                                         
                                                     hr(),
                                                     ## h4("A glance of model table"),
                                                     ## dataTableOutput('modelTable'),
                                                     br(),
                                                     br()
                                                     ),
                                            
                                            tabPanel("App Workflow",                                                       
                                                     h3("Shiny App Prediction Algorithm"),
                                                     hr(),
                                                     img(src="work_flow_shiny.png", height = 262, width = 800),
                                                     hr(),
                                                     h4("Preprocess"),
                                                     p("1. Obtain the data from the input box."),
                                                     p("2. Cleaning for the data sentence. Numbers, punctuations,
                                                       extra spaces will be removed, and all words are converted to lowercase."),
                                                     hr(),
                                                     h4("Tokenize"),
                                                     p("After preprocessing, the sentence will be truncated from the last 3 words.
                                                       , If there are less than 3 words, all the words will be used."),
                                                     hr(),
                                                     h4("Search pattern"),
                                                     p("Search the pattern from the n-gram model 
                                                       The algormithm will search the pattern from 
                                                       the 3-grams frequency matrix, and then return the Top 5 frequent predictions.However, 
                                                       if there is no result, it will automatically search the 2-grams, 
                                                       and if it still no result, it will search the 1-gram matrix."),
                                                     hr(),
                                                     h4("Predict the next single word"),
                                                     p("The next possible single word will be returned and displayed. 
                                                       In addition, the top 5 possible words also could be found. The average predicting time for
                                                       one input is usually 0.000 ~ 0.003s.")
                                                     ),
                                            
                                            tabPanel("Key Concepts",                                                      
                                                     h3("Key Concepts/Terminology"),hr(),
                                                     h4("1. Tokenization() function"),
                                                     p("Tokenization(), function based on the tm R Packagepackage
                                                       for data cleanning process, it mainly provides users with reproducible functionalities such as:,
                                                       Simple Transformation, Lowercase Transformation, the removal of Numbers and 
                                                       Punctuations and removeing Stop Words and perfoming Profanity Filtering with only one command."),
                                                     hr(),
                                                     h4("2. ngramify() function"),
                                                     p("ngramify(), function tackle the memory limits problem when generating
                                                       ngrams model from database. It provides users with a reproducible functionality to split raw datasets into a bunch of
                                                       user defined number of small ones and transform them into n-grams model."),
                                                     hr(),
                                                     h4("3. N-grams language model"),
                                                     p("An n-gram model is a type of probabilistic language model for predicting the next item in such a sequence in the form of 
                                                       a (n - 1) –order Markov model"),
                                                     p("In this model, we are using 1-4 grams for prediction purpose, they are refering to unigram,
                                                       bigram, trigram, and quatrgram respectively."),
                                                     hr(),
                                                     h4("4. Computing probabilities"),
                                                     p("To compute the probabilities of each token,",a("Markov chain", href="http://en.wikipedia.org/wiki/Markov_chain"),"is introduced and implemented
                                                       in our model."),
                                                     p("A Markov chain is a sequence of random variables X1, X2, X3, ... with the Markov property, namely that, 
                                                       given the present state, the future and past states are independent. Formally,"),
                                                     img(src = "markov.png", height = 20),
                                                     hr(),
                                                     h4("5. Smoothing"),
                                                     p("Smoothing techniques are main used to cope with unseen n-grams in text modelling.",
                                                       a("Katz's back-off model", href="http://en.wikipedia.org/wiki/Katz%27s_back-off_model"),"is introduced in our model."),
                                                     p("Katz back-off is a generative n-gram language model that estimates the conditional probability of a word given its history 
                                                       in the n-gram. It accomplishes this estimation by \"backing-off\" to models with smaller histories under certain conditions. 
                                                       By doing so, the model with the most reliable information about a given history is used to provide the better results."),
                                                     p("The equation for Katz's back-off model is:"),
                                                     img(src = "backoff.png"),
                                                     br(),hr()
                                                     )
                                                     )
                                                     )
                                                     )
                                                     ),
               navbarMenu("Documents",
                          tabPanel("Interim Report",
                                   sidebarLayout(
                                       sidebarPanel(width=3,
                                                    helpText(h5("Note:")),
                                                    helpText("This document is taken from the MidPoint report for the Capstone and explains some of the data attributes that have been identified 
                                                             and briefly summarizes the plans for creating the prediction algorithm and Shiny app in a way that
                                                             would be understandable to a non-data scientist manager. It includes:"),
                                                    helpText("1. A basic report of summary statistics about the data sets.", style="color:#428ee8"),
                                                    helpText("2. Interesting findings that author amassed so far.", style="color:#428ee8"),
                                                    helpText("3. Plans for creating a prediction algorithm and Shiny app", style="color:#428ee8"),
                                                    hr(),
                                                    h6("This App is built for:"),
                                                    a("Coursera Data Science Capstone", href="https://www.coursera.org/course/dsscapstone"),
                                                    p("class started on 9 March 2015"),
                                                    hr(),
                                                    ##h6("For more information about Ben Apple:"),
                                                    ##a(img(src = "GitHub-Mark.png", height = 30, width = 30),href="https://github.com/bengapple/Swiftkey_Capstone"),
                                                    ##a(img(src = "linkedin.png", height = 26, width = 26),href="https://www.linkedin.com/in/ivanliu1989"),
                                                    ##a(img(src = "gmail.jpeg", height = 30, width = 30),href="mailto: ivan.liuyanfeng@gmail.com"),
                                                    br()),
                                       mainPanel(
                                           includeMarkdown('milestonerpt.md')
                                       )
                                       )
                                   ),
                          tabPanel("Final Report",
                                   sidebarLayout(
                                       sidebarPanel(width=3,
                                                    helpText(h5("Note:")),
                                                    helpText("This document is a slide deck consisting of 5 slides created with", 
                                                             a("R Studio Presenter", href="https://support.rstudio.com/hc/en-us/articles/200486468-Authoring-R-Presentations"),
                                                             "pitching the algorithm and app for the sake of presenting to management or an investor. It includes:"),
                                                    helpText("1. A description of the algorithm used to make the prediction", style="color:#428ee8"),
                                                    helpText("2. Description of app and instructions of how it functions", style="color:#428ee8"),
                                                    helpText("3. Description of the experience of using this app", style="color:#428ee8"),
                                                    hr(),
                                                    h6("This App is built for:"),
                                                    a("Coursera Data Science Capstone", href="https://www.coursera.org/course/dsscapstone"),
                                                    p("class started on 9 March 2015"),
                                                    hr(),
                                                    ##h6("For more information about Ben Apple:"),
                                                    ##a(img(src = "GitHub-Mark.png", height = 30, width = 30),href="https://github.com/bengapple/Swiftkey_Capstone"),
                                                    ##a(img(src = "linkedin.png", height = 26, width = 26),href="https://www.linkedin.com/in/ivanliu1989"),
                                                    ##a(img(src = "gmail.jpeg", height = 30, width = 30),href="mailto: ivan.liuyanfeng@gmail.com"),
                                                    br()),
                                       mainPanel(width=9,
                                                  ## column(8,
                                                        ## a(img(src = "slides_1.png"),href="http://rpubs.com/bengapple/71376"),hr(),
                                                        ## a(img(src = "slides_2.png"),href="http://rpubs.com/bengapple/71376"),hr(),
                                                        ## a(img(src = "slides_3.png"),href="http://rpubs.com/bengapple/71376"),hr(),
                                                        ## a(img(src = "slides_4.png"),href="http://rpubs.com/bengapple/71376"),hr(),
                                                        ## a(img(src = "slides_5.png"),href="http://rpubs.com/bengapple/71376"),hr()
                                                 ## ),
                                                 column(4,
                                                        ## h5("Please use the slides", code("navigation bar"), 
                                                        ##   "on the right-bottom corner of the page."),
                                                        ## hr(),
                                                        h5("To browse the released version of the slide presentation,
                                                         please visit the RPubs link below."),
                                                        a("Capstone Presentation", href="http://rpubs.com/bengapple/71376")
                                                 )
                                       )
                                   )
                          )
               )
               )
    )
