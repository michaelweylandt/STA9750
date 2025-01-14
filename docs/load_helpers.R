library(yaml)
variables <- read_yaml("https://raw.githubusercontent.com/michaelweylandt/STA9750/refs/heads/main/_variables.yml")
course_repo  <- variables$course$repo
course_short <- variables$course$short

mp_submission_create <- function(N, github_id){
  library(rvest); library(glue); library(tidyverse); library(httr2); library(gh)
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
         req_url_path_append(github_id) |>
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
  
  issues <- gh("/repos/{owner}/{repo}/issues?state=all", 
               owner=github_id, 
               repo=course_repo)
  
  issue_names <- vapply(issues, function(x) str_squish(x$title), "")
  
  name_match <- which(issue_names == title)
  
  if(length(name_match) == 0){
      cat("I could not find an issue with the title:\n", 
          "    ", sQuote(title),"\n",
          "The issues I found had the following titles:\n",
          paste(c("", issue_names), collapse="\n - "), "\n",
          "If something on that list looks correct, please check",
          "capitalization and punctuation.\n")
          stop("MINIPROJECT NOT SUBMITTED CORRECTLY.")
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
  
  cat("Identified Issue #", issue_num, "at", issue_url, "as possible candidate.")
  
  if(issue$state != "open"){
     cat("Issue does not appear to be in 'open' status. Please",
         "confirm the issue is open and try again.\n")
     stop("MINIPROJECT NOT SUBMITTED CORRECTLY.")
  }
  
  if(issue_body != body){
    cat("Issue does not appear to have the correct body text. This is not",
        "necessarily an issue, but you may want to confirm all relevant",
        "information is included.\n")
  }
  
  urls <- str_match_all(paste(issue_body, "\n Thanks!\n", sep=""), "http.*")[[1]]
  expected_url <- str_extract(body, "http.*")
  
  if(length(urls) > 1){
    cat("The following URLs were found in the issue text:",
        paste(c("", urls), collapse="\n - "), 
        "Only one URL was expected; please remove any extras.\n")
    stop("MINIPROJECT NOT SUBMITTED CORRECTLY.")
  }
 
  submitted_url <- urls[1]
  
  if(submitted_url != expected_url){
    cat("The submitted URL does not match the Mini-Project instructions.\n", 
        "Expected:\n - ", expected_url, "\n", 
        "Submitted:\n - ", submitted_url, "\n", 
        "Please correct any differences and try again.\n")
        stop("MINIPROJECT NOT SUBMITTED CORRECTLY.")
  }
  
  resp <- request(submitted_url) |> req_perform()
  
  if(resp_is_error(resp)){
    cat("Something appears to be incorrect at the URL: ", 
        submitted_url, 
        "\n Please confirm that it is working as expected and try again.")
    browseURL(submitted_url)
    stop("MINIPROJECT NOT SUBMITTED SUCCESSFULLY.")
  }
  
  raw_url <- glue("https://raw.githubusercontent.com/{github_id}/{course_repo}/refs/heads/main/mp0{N}.qmd")
  
  resp_raw <- request(raw_url) |> req_perform()
  
  if(resp_is_error(resp_raw)){
      cat("I cannot find the source qmd document at", raw_url, ".\n",
          "Please confirm it was correctly submitted and try again.\n",
          "This document is needed for automated code quality checks.")
      
    stop("MINIPROJECT NOT SUBMITTED SUCCESSFULLY.")
  }
  
  cat("Congratulations! Your mini-project appears to have been submitted correctly!\n")
  invisible(TRUE)
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
  
  title <- glue("{course_short} {github_id} MiniProject #0{N}")

  issues <- gh("/repos/{owner}/{repo}/issues?state=all", 
               owner=peer_id, 
               repo=course_repo)
  
  issue_names <- vapply(issues, function(x) str_squish(x$title), "")
  
  name_match <- which(issue_names == title)
  
  if(length(name_match) != 0){
      cat("I could not find an issue with the title:\n", 
          "    ", sQuote(title),"\n",
          "I'm afraid I can't verify whether the peer feedback was submitted properly.\n")
          stop("PEER FEEDBACK NOT VERIFIED.")
  } 
  
  issue <- issues[[name_match]]
  
  issue_url <- issue$html_url
  issue_comment_url <- issue$comment_url
  
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
  
  comment_body <- comment$body
  
  cat("I have found your comment, with the following text:")
  
  cat(comment_body)
  
  comment_body  <- comment_body |> str_squish()
  template_text <- template_text |> str_squish()
  
  matches <- str_match_all(comment_body, template_text)[[1]][-1]
  
  if(anyNA(matches)){
    cat("I couldn't match the template to your comment. Please modify and try again.")
    stop("PEER FEEDBACK NOT VERIFIED.")
  }
  
  cat(glue("Congratulations! Your peer feedback on {peer_id}'s MP #0{N} appears properly formatted. Thank you for your contributions to {course_short}"))
  
  invisible(TRUE)
  
}

count_words <- function(url){
    library(rvest); library(stringi)
    # Note that this includes code inside an inline block, but omits
    # full-sized code blocks
    read_html(url) |>
        html_elements("main p") |>
        html_text() |>
        stri_count_words() |>
        sum()
}

lint_submission <- function(N, peer_id){
  library(rvest); library(glue); library(tidyverse); library(httr2); library(lintr)
  if(missing(N)){
    N <- menu(title="Which Mini-Project submission would you like to lint?", 
              choices=c(0, 1, 2, 3, 4))
  }
    
  if(missing(peer_id)){
    peer_id <- readline("What is your Peer's GitHub ID? ")
  }
    
  raw_url <- glue("https://raw.githubusercontent.com/{peer_id}/{course_repo}/refs/heads/main/mp0{N}.qmd")
  
  cat("Attempting to access qmd source at", raw_url, ".\n")
  
  resp <- request(raw_url) |> req_perform()
  
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
