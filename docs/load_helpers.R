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
  
  browseURL(r$URL)
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
  
  if(resp$status_code != 200){
    cat("Something appears to be incorrect at the URL: ", 
        submitted_url, 
        "\n Please confirm that it is working as expected and try again.")
    browseURL(submitted_url)
    stop("MINIPROJECT NOT SUBMITTED SUCCESSFULLY.")
  }
  
  cat("Congratulations! Your mini-project appears to have been submitted correctly!\n")
  invisible(TRUE)
}
