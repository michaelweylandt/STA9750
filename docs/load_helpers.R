library(yaml)
variables <- read_yaml("https://raw.githubusercontent.com/michaelweylandt/STA9750/refs/heads/main/_variables.yml")
course_repo  <- variables$course$repo
course_short <- variables$course$short

mp_submission_create <- function(N, github_id){
  library(rvest)
  library(glue)
  library(tidyverse)
  library(httr2)
  library(gh)
  
  if(missing(N)){
    N <- menu(title="Which Mini-Project would you like to submit on GitHub?", 
              choices=c(0, 1, 2, 3, 4))
  }
    
  mp_url <- glue("https://michael-weylandt.com/STA9750/miniprojects/mini0{N}.html")
  
  mp_text <- read_html(mp_url) |> html_element("#submission-text") |> html_text()
  
  if(missing(github_id)){
    github_id <- readline("What is your GitHub ID? ")
  }
  
  title <- glue("{course_short} {github_id} MiniProject #0{N}")
  
  body <- mp_text |> str_replace("<GITHUB_ID>", github_id)
  
  r <- request("https://github.com/") |>
         req_url_path_append("michaelweylandt") |>
         req_url_path_append(course_repo) |>
         req_url_path_append("issues/new") |>
         req_url_query(title=title, 
                       body=body) 
  
  browseURL(r$url)
}

mp_submission_verify <- function(N, github_id){
  library(rvest)
  library(glue)
  library(tidyverse)
  library(httr2)
  library(gh)
    
  if(missing(N)){
    N <- menu(title="Which Mini-Project would you like to check was properly submitted on GitHub?", 
              choices=c(0, 1, 2, 3, 4))
  }
  
  mp_url <- glue("https://michael-weylandt.com/STA9750/miniprojects/mini0{N}.html")
  
  mp_text <- read_html(mp_url) |> html_element("#submission-text") |> html_text()
  
  if(missing(github_id)){
    github_id <- readline("What is your GitHub ID? ")
  }
  
  title <- glue("{course_short} {github_id} MiniProject #0{N}")
  
  body <- mp_text |> str_replace("<GITHUB_ID>", github_id) |> str_squish()
  
  page <- 1
  
  issues <- list()
  
  while((length(issues) %% 100) == 0){
      new_issues <- gh("/repos/michaelweylandt/{repo}/issues?state=all&per_page=100&page={page}", 
               repo=course_repo, 
               page=page)
      
      issues <- c(issues, new_issues)
      page <- page + 1
  }
  
  issue_names <- vapply(issues, function(x) str_squish(x$title), "")
  
  name_match <- which(issue_names == title)
  case_insensitive_match <- which(tolower(issue_names) == tolower(title))
        
  if((length(name_match) == 0) & (length(case_insensitive_match) == 0)){
    cat("I could not find a unique issue with the title:\n", 
        "    ", sQuote(title),"\n",
        "The issues I found had the following titles:\n",
        paste(c("", issue_names), collapse="\n - "), "\n",
        "If something on that list looks correct, please check",
        "capitalization and punctuation.\n")
    stop("MINIPROJECT NOT SUBMITTED CORRECTLY.")
  } else if((length(name_match) == 0) & (length(case_insensitive_match) >= 0)) {
      cat("I have found a partial match (differing by case only).\n",
          "- Searching for: ", title, , "\n", 
          "- Found: ", issue_names[case_insensitive_match], ".\n",
          "Attempting to proceed with partial match issue")
      name_match <- case_insensitive_match
  } else if(length(name_match) > 1){
    cat("I found multiple issues with the title:\n", 
        "    ", sQuote(title),"\n",
        "Please change the names of issues so that there is only", 
        "issue with the desired name. (Note that closing an issue is",
        "not sufficient.)\n")
          
    stop("MINIPROJECT NOT SUBMITTED CORRECTLY.")
  }
  
  issue <- issues[[name_match]]
  
  issue_num <- issue$number
  issue_url <- issue$html_url
  issue_body <- issue$body |> str_squish()
  
  cat("Identified Issue #", issue_num, "at", issue_url, "as possible candidate.\n")
  
  if(issue$state != "open"){
    cat("Issue does not appear to be in 'open' status. Please",
        "confirm the issue is open and try again.\n")
    stop("MINIPROJECT NOT SUBMITTED CORRECTLY.")
  }
  
  if(!str_equal(issue_body, body, ignore_case = TRUE)){
    cat("Issue does not appear to exactly match the correct body text.",
        "This is not necessarily an issue since the expected link is present",
        "but you may want to confirm all relevant",
        "information is included.\n")
  }
  
  # This isn't quite general enough, but I think it covers everything
  # we'll see in this course. 
  URL_REGEX <- "http[A-Za-z0-9:/\\-\\.]*"
    
  urls <- str_match_all(paste(issue_body, "\n Thanks!\n", sep=""), 
                        URL_REGEX)[[1]] |> unique()
  expected_url <- str_extract(body, URL_REGEX)
  
  if(length(urls) > 1){
    cat("The following URLs were found in the issue text:",
        paste(c("", urls), collapse="\n - "), 
        "Only one URL was expected; please remove any extras.\n")
    stop("MINIPROJECT NOT SUBMITTED CORRECTLY.")
  }
 
  submitted_url <- urls[1]
  
  if(!str_equal(submitted_url, expected_url, ignore_case = TRUE)){
    cat("The submitted URL does not match the Mini-Project instructions.\n", 
        "Expected:\n - ", expected_url, "\n", 
        "Submitted:\n - ", submitted_url, "\n", 
        "Please correct any differences and try again.\n")
        stop("MINIPROJECT NOT SUBMITTED CORRECTLY.")
  }
  
  resp <- request(submitted_url) |> 
      req_error(is_error = \(r) FALSE) |>
      req_perform()
  
  if(resp_is_error(resp)){
    cat("Something appears to be incorrect at the URL: ", 
        submitted_url, 
        "\n Please confirm that it is working as expected and try again.")
    browseURL(submitted_url)
    stop("MINIPROJECT NOT SUBMITTED SUCCESSFULLY.")
  }
  
  if(N == 0){
    raw_url <- glue("https://raw.githubusercontent.com/{github_id}/{course_repo}/refs/heads/main/index.qmd")
  } else {
    raw_url <- glue("https://raw.githubusercontent.com/{github_id}/{course_repo}/refs/heads/main/mp0{N}.qmd")
  }
  
  resp_raw <- request(raw_url) |> 
      req_error(is_error = \(r) FALSE) |>
      req_perform()
  
  if(resp_is_error(resp_raw)){
      ## Try again with 'master' instead of 'main' branch
      raw_url_master <- str_replace(raw_url, "main", "master")
      resp_raw <- request(raw_url_master) |> 
      req_error(is_error = \(r) FALSE) |>
      req_perform()
  }
  
  if(resp_is_error(resp_raw)){
      cat("I cannot find the source qmd document at", raw_url, "or", 
          raw_url_master, ".\n",
          "Please confirm it was correctly submitted and try again.\n",
          "This document is needed for automated code quality checks.\n")
      
    stop("MINIPROJECT NOT SUBMITTED SUCCESSFULLY.")
  }
  
  cat("Congratulations! Your mini-project appears to have been submitted correctly!\n")
  invisible(TRUE)
}

mp_feedback_locate <- function(N, github_id){
    library(rvest)
    library(glue)
    library(tidyverse)
    library(httr2)
    library(gh)
    
    if(missing(N)){
        N <- menu(title="Which Mini-Project's Peer Feedback cycle is it currently?", 
                  choices=c(0, 1, 2, 3, 4))
    }
    
    if(missing(github_id)){
        github_id <- readline("What is your GitHub ID? ")
    }
    
    page <- 1
    issues <- list()
  
    while((length(issues) %% 100) == 0){
        new_issues <- gh("/repos/michaelweylandt/{repo}/issues?state=all&per_page=100&page={page}", 
                 repo=course_repo, 
                 page=page)
      
        issues <- c(issues, new_issues)
        page <- page + 1
    }
    
    pf_urls <- issues |> 
        keep(~ str_detect(.x$title, glue("#0{N}"))) |>
        keep(~ !str_equal(.x$user$login, github_id, ignore_case=TRUE)) |>
        map(~data.frame(html=.x$html_url, comments=.x$comments_url)) |>
        keep(~any(str_detect(map_chr(gh(.x$comments), "body"), github_id))) |>
        map("html") |>
        list_c()
    
    cat(glue("I have found several MP#0{N} issues that may be assigned to you.\n"),
             "Please review the following:\n")
    for(pf in pf_urls){
        cat(" - ", pf, "\n")
    }
    
    to_browser <- menu(title="Would you like me to open these in your web browser?", 
                       choices=c("Yes", "No"))
    
    if(to_browser == 1){
        for(pf in pf_urls){
            browseURL(pf)
        }
    }
    invisible(TRUE)
}

mp_feedback_submit <- function(N, peer_id){
  library(rvest)
  library(glue)
  library(tidyverse)
  library(httr2)
  library(gh)
  library(clipr)
    
  if(missing(N)){
    N <- menu(title="Which Mini-Project's Peer Feedback would you like to check was properly submitted on GitHub?", 
              choices=c(0, 1, 2, 3, 4))
  }

  if(missing(peer_id)){
    peer_id <- readline("What is your Peer's GitHub ID? ")
  }
    
  title <- glue("{course_short} {peer_id} MiniProject #0{N}")

  page <- 1
  
  issues <- list()
  
  while((length(issues) %% 100) == 0){
      new_issues <- gh("/repos/michaelweylandt/{repo}/issues?state=all&per_page=100&page={page}", 
               repo=course_repo, 
               page=page)
      
      issues <- c(issues, new_issues)
      page <- page + 1
  }
  
  issue_names <- vapply(issues, function(x) str_squish(x$title), "")
  
  name_match <- which(issue_names == title)
  
  if(length(name_match) != 1){
      cat("I could not find a unique issue with the title:\n", 
          "    ", sQuote(title),"\n",
          "I'm afraid I can't verify whether the peer feedback was submitted properly\n", 
          "but the issue likely lies with the submittor, not with your feedback.")
          stop("PEER FEEDBACK NOT VERIFIED.")
  } 
  
  issue <- issues[[name_match]]
  
  issue_url <- issue$html_url
 
  template_url <- "https://michael-weylandt.com/STA9750/miniprojects.html"
  
  template_text <- read_html(template_url) |> 
    html_element("#peer-feedback-template") |> 
    html_text() |>
    str_trim() 
  
  template_categories <- c(
      "Written Communication", 
      "Project Skeleton", 
      "Formatting & Display", 
      "Code Quality", 
      "Data Preparation", 
      "Extra Credit"
  )
  
  for(category in template_categories){
      has_score <- FALSE
      
      while(!has_score){
          score <- readline(glue("On a scale of 0 to 10, how many points does {peer_id} deserve for {category}? "))
          
          score <- as.integer(score)
          
          if(!is.na(score) & (score >= 0) & (score <= 10)){
              has_score <- TRUE
          }
      }
      
      has_score <- FALSE
      
      text <- readline(glue("Why did you give {peer_id} {score} points for {category}? "))
      
      template_text <- template_text |>
          str_replace("NN", as.character(score)) |>
          str_replace("TEXT TEXT TEXT", as.character(text))
  }
  
  write_clip(template_text)
  
  readline(paste0(
    "After you hit Enter / Return, you will be taken to a GitHub page.\n",
    "Paste from the clipboard into the comment box at the bottom to\n",
    "pre-populate your peer feedback. Then hit 'Comment' to finish your\n",
    "submission. "))
  
  browseURL(issue_url)
  
  cat(glue("You can now use `mp_feedback_verify({N}, peer_id={peer_id})`\n",
      "to confirm your submission was properly formatted.\n"))
}


mp_feedback_verify <- function(N, github_id, peer_id){
  library(rvest)
  library(glue)
  library(tidyverse)
  library(httr2)
  library(gh)
    
  if(missing(N)){
    N <- menu(title="Which Mini-Project's Peer Feedback would you like to check was properly submitted on GitHub?", 
              choices=c(0, 1, 2, 3, 4))
  }
  
  if(missing(github_id)){
    github_id <- readline("What is your GitHub ID? ")
  }

  if(missing(peer_id)){
    peer_id <- readline("What is your Peer's GitHub ID? ")
  }
 
  template_url <- "https://michael-weylandt.com/STA9750/miniprojects.html"
  
  template_text <- read_html(template_url) |> 
    html_element("#peer-feedback-template") |> 
    html_text() |>
    str_trim() |>
    str_replace_all("NN", "(.*)") |>
    str_replace_all("TEXT TEXT TEXT", "(.*)")
  
  title <- glue("{course_short} {peer_id} MiniProject #0{N}")

  page <- 1
  
  issues <- list()
  
  while((length(issues) %% 100) == 0){
      new_issues <- gh("/repos/michaelweylandt/{repo}/issues?state=all&per_page=100&page={page}", 
               repo=course_repo, 
               page=page)
      
      issues <- c(issues, new_issues)
      page <- page + 1
  }
  
  issue_names <- vapply(issues, function(x) str_squish(x$title), "")
  
  name_match <- which(issue_names == title)
  
  if(length(name_match) != 1){
      cat("I could not find a unique issue with the title:\n", 
          "    ", sQuote(title),"\n",
          "I'm afraid I can't verify whether the peer feedback was submitted properly\n", 
          "but the issue likely lies with the submittor, not with your feedback.")
          stop("PEER FEEDBACK NOT VERIFIED.")
  } 
  
  issue <- issues[[name_match]]
  
  issue_url <- issue$html_url
  issue_comment_url <- issue$comments_url
  
  comments <- gh(issue_comment_url)
  
  commenters <- vapply(comments, function(x) x$user$login, "")
  
  comment_num <- which(commenters == github_id)
  
  if(length(comment_num) != 1){
    cat("I cannot identify your comment on the issue at", 
       sQuote(issue_url), ". Please verify that this is the correct link.\n")
       
    if(length(comment_num) == 0){
      cat("You do not appear to have commented on this issue.")
    } else {
      cat("You have left multiple comments on this issue.",
          "Please consolidate your feedback")
    }
    stop("PEER FEEDBACK NOT VERIFIED.")
  }
  
  comment_body <- comments[[comment_num]]$body
  
  cat("I have found your comment, with the following text:\n-----\n")
  
  cat(comment_body)
  
  cat("\n-----\n")
  
  comment_body  <- comment_body |> str_squish()
  template_text <- template_text |> str_squish()
  
  matches <- str_match_all(comment_body, template_text)[[1]][-1]
  
  if(anyNA(matches)){
    cat("I couldn't match the template to your comment. Please modify and try again.")
    stop("PEER FEEDBACK NOT VERIFIED.")
  }
  
  cat(glue("Congratulations! Your peer feedback on {peer_id}'s MP #0{N} appears properly formatted.\nThank you for your contributions to {course_short}!\n"))
  
  invisible(TRUE)
  
}

count_words <- function(url){
    library(rvest)
    library(stringi)
    
    # Note that this includes code inside an inline block, but omits
    # full-sized code blocks
    read_html(url) |>
        html_elements("main p") |>
        html_text() |>
        stri_count_words() |>
        sum()
}

lint_submission <- function(N, peer_id){
  library(rvest)
  library(glue)
  library(tidyverse)
  library(httr2)
  library(lintr)

  if(missing(N)){
    N <- menu(title="Which Mini-Project submission would you like to lint?", 
              choices=c(1, 2, 3, 4))
  }
    
  if(missing(peer_id)){
    peer_id <- readline("What is your Peer's GitHub ID? ")
  }
    
  raw_url <- glue("https://raw.githubusercontent.com/{peer_id}/{course_repo}/refs/heads/main/mp0{N}.qmd")
  
  cat("Attempting to access qmd source at", raw_url, ".\n")
  
  resp <- request(raw_url) |> 
      req_error(is_error = \(r) FALSE) |>
      req_perform()
  
  if(resp_is_error(resp)){
      cat("I could not access the raw qmd document. Attempting to open in browser...\n")
      browseURL(resp)
      return(FALSE)
  } else {
      cat("I was able to access the raw qmd document. Beginning to lint.\n")
      
      tf <- tempfile(pattern=glue("mp0{N}_{peer_id}_lint_document.qmd"))
      
      writeLines(resp_body_string(resp), tf)
      
      lintr::lint(tf)
  }
}


# # Run this to update helper scripts
# knitr::purl("tips.qmd",
#             documentation=0L,
#             output="docs/load_helpers.R")
