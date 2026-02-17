library(yaml)
variables <- read_yaml("https://raw.githubusercontent.com/michaelweylandt/STA9750/refs/heads/main/_variables.yml")
course_repo  <- variables$course$repo
course_short <- variables$course$short

mp_start <- function(N, github_id){
    if(!require("yaml")) install.packages("yaml"); library(yaml)
    if(!require("gh")) install.packages("gh"); library(gh)
    if(!require("tidyverse")) install.packages("tidyverse"); library(tidyverse)
    if(!require("rvest")) install.packages("rvest"); library(rvest)
    if(!require("glue")) install.packages("glue"); library(glue)
    if(!require("httr2")) install.packages("httr2"); library(httr2)
    
    if(missing(N)){
        N <- menu(title="Which Mini-Project would you like to submit on GitHub?", 
                  choices=c(1, 2, 3, 4))
    }
    
    `%not.in%` <- Negate(`%in%`)
    
    if(N %not.in% c(1, 2, 3, 4)){
        stop("Mini-Project Number not Recognized")
    }
    
    
    fname <- glue("mp0{N}.qmd")
    
    
    if(file.exists(fname)){
        stop(paste0("A ", sQuote(fname), " file already exists in this directory."))
    }
    
    
    mp_url <- glue("https://michael-weylandt.com/STA9750/mini/mini0{N}.html")
    
    if(missing(github_id)){
        github_id <- readline("What is your GitHub ID? ")
    }
    
    variables <- read_yaml("https://raw.githubusercontent.com/michaelweylandt/STA9750/refs/heads/main/_variables.yml")
    course_repo  <- variables$course$repo
    course_short <- variables$course$short
    
    if(!endsWith(getwd(), course_repo)){
        stop(paste("This command should be run in your", course_repo, "directory only."))
    }
    
    mp_skeleton_url <- "https://michael-weylandt.com/STA9750/mp_template.qmd"
    mp_instructions_url <- glue("https://raw.githubusercontent.com/michaelweylandt/STA9750/refs/heads/main/mini/mini0{N}.qmd")
    
    mp_instructions <- readLines(mp_instructions_url)
    
    dash_lines <- which(str_equal(mp_instructions, "---"))
    
    mp_header <- mp_instructions[(dash_lines[1] + 1):(dash_lines[2]-1)]
    
    mp_variables <- yaml.load(mp_header)
    
    mp_skeleton <- mp_skeleton_url |> 
        readLines() |> 
        str_replace_all(fixed("{GITHUB_ID}"), github_id) |>
        str_replace_all(fixed("{N}"), N) |>
        str_replace_all(fixed("{MP_TITLE}"), mp_variables$mp_title) |>
        str_replace_all(fixed("{MP_SKILLS}"), mp_variables$mp_skills |> str_split(", ")  |> pluck(1) |> paste(collapse = "/")) |>
        str_replace_all(fixed("{MP_DATA}"), mp_variables$mp_application |> str_split(", ")  |> pluck(1) |> paste(collapse = "/"))
    
    writeLines(mp_skeleton, fname)
    
    if("tools:rstudio" %in% search()){
        cat("Opening miniproject file")
        invisible(rstudioapi::documentOpen(fname))
    } else {
        cat("You can now open", sQuote(fname), "and begin the mini-project.")
    }
}

mp_submission_ready <- function(N, github_id){
    if(!require("yaml")) install.packages("yaml"); library(yaml)
    if(!require("gh")) install.packages("gh"); library(gh)
    if(!require("tidyverse")) install.packages("tidyverse"); library(tidyverse)
    if(!require("rvest")) install.packages("rvest"); library(rvest)
    if(!require("glue")) install.packages("glue"); library(glue)
    if(!require("httr2")) install.packages("httr2"); library(httr2)  
    
    if(missing(N)){
        N <- menu(title="Which Mini-Project would you like to check was properly submitted on GitHub?", 
                  choices=c(0, 1, 2, 3, 4))
    }
    
    mp_url <- glue("https://michael-weylandt.com/STA9750/mini/mini0{N}.html")
    
    mp_text <- read_html(mp_url) |> html_element("#submission-text") |> html_text()
    
    if(missing(github_id)){
        github_id <- readline("What is your GitHub ID? ")
    }
    
    variables <- read_yaml("https://raw.githubusercontent.com/michaelweylandt/STA9750/refs/heads/main/_variables.yml")
    course_repo  <- variables$course$repo
    course_short <- variables$course$short
    
    BASE_URL <- glue("https://{github_id}.github.io/{course_repo}/")
    
    page_resp <- request(BASE_URL) |>
        req_url_path_append(glue("mp0{N}.html")) |>
        req_error(is_error = \(r) FALSE) |> 
        req_perform()

    if(resp_is_error(page_resp)){
        stop(glue("I was unable to access your submission at {page_resp$url}. Please make sure that your content has been successfully uploaded to GitHub."))
    }
    
    cat(glue("I was able to access your submission at {page_resp$url}, now checking JS and CSS files."), "\n")
    
    SUPPORT_FILES <- page_resp |> resp_body_html() |> html_elements("link") |> html_attr("href")
    
    SUPPORT_STATUS <- map_lgl(SUPPORT_FILES, function(s){
        supp_resp_error <- request(BASE_URL) |> 
            req_url_path_append(s) |>
            req_error(is_error = \(r) FALSE) |>
            req_perform() |>
            resp_is_error()
        
        if(supp_resp_error){
            cat(glue("- I could not find the file {s} that your site attempts to load.\n  Please make sure docs/{s} has been uploaded via Git to your GitHub.\n"))
            cat("\n")
        }
        !supp_resp_error
    }) 
    
    if(!all(SUPPORT_STATUS)){
        stop("Necessary support files could not be verified. Please visually inspect all elements of your site before submission.")
        browseURL(page_resp$url)
    }

    IMAGE_FILES <- page_resp |> resp_body_html() |> html_elements("img") |> html_attr("src")
    
    IMAGE_STATUS <- map_lgl(IMAGE_FILES, function(s){
        img_resp_error <- request(BASE_URL) |> 
            req_url_path_append(s) |>
            req_error(is_error = \(r) FALSE) |>
            req_perform() |>
            resp_is_error()
        
        if(img_resp_error){
            cat(glue("- I could not find the image file {s} that your site attempts to load.\n  Please make sure docs/{s} has been uploaded via Git to your GitHub.\n"))
            cat("\n")
        }
        !img_resp_error
    }) 
    
    if(!all(IMAGE_STATUS)){
        stop("Necessary image files could not be verified. Please visually inspect all elements of your site before submission.")
        browseURL(page_resp$url)
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
        
        stop("Miniproject not ready for submission.")
    }
    
    cat("Congratulations! Your mini-project appears to be ready for submission!\n")
    cat("Visually verify it one more time before submission.\n")
    cat("Then run the following command to submit on GitHub.\n")
    cat("\n")
    cat(glue('source("https://michael-weylandt.com/STA9750/load_helpers.R"); mp_submission_create(N={N}, github_id="{github_id}")'), "\n")
    cat("Then upload a PDF of your submission to Brightspace.\n")
    invisible(TRUE)
}

mp_submission_create <- function(N, github_id){
    if(!require("yaml")) install.packages("yaml"); library(yaml)
    if(!require("gh")) install.packages("gh"); library(gh)
    if(!require("tidyverse")) install.packages("tidyverse"); library(tidyverse)
    if(!require("rvest")) install.packages("rvest"); library(rvest)
    if(!require("glue")) install.packages("glue"); library(glue)
    if(!require("httr2")) install.packages("httr2"); library(httr2)
    
    if(missing(N)){
        N <- menu(title="Which Mini-Project would you like to submit on GitHub?", 
                  choices=c(0, 1, 2, 3, 4))
    }
    
    mp_url <- glue("https://michael-weylandt.com/STA9750/mini/mini0{N}.html")
    
    mp_text <- read_html(mp_url) |> html_element("#submission-text") |> html_text()
    
    if(missing(github_id)){
        github_id <- readline("What is your GitHub ID? ")
    }
    
    variables <- read_yaml("https://raw.githubusercontent.com/michaelweylandt/STA9750/refs/heads/main/_variables.yml")
    course_repo  <- variables$course$repo
    course_short <- variables$course$short
    
    title <- glue("{course_short} {github_id} MiniProject #0{N}")
    
    body <- mp_text |> str_replace("YOUR_GITHUB_ID", github_id) |> str_trim()
    
    r <- request("https://github.com/") |>
        req_url_path_append("michaelweylandt") |>
        req_url_path_append(course_repo) |>
        req_url_path_append("issues/new") |>
        req_url_query(title=title, 
                      body=body) 
    
    browseURL(r$url)
}

mp_submission_verify <- function(N, github_id){
    if(!require("yaml")) install.packages("yaml"); library(yaml)
    if(!require("gh")) install.packages("gh"); library(gh)
    if(!require("tidyverse")) install.packages("tidyverse"); library(tidyverse)
    if(!require("rvest")) install.packages("rvest"); library(rvest)
    if(!require("glue")) install.packages("glue"); library(glue)
    if(!require("httr2")) install.packages("httr2"); library(httr2)  
    
    if(missing(N)){
        N <- menu(title="Which Mini-Project would you like to check was properly submitted on GitHub?", 
                  choices=c(0, 1, 2, 3, 4))
    }
    
    mp_url <- glue("https://michael-weylandt.com/STA9750/mini/mini0{N}.html")
    
    mp_text <- read_html(mp_url) |> html_element("#submission-text") |> html_text()
    
    if(missing(github_id)){
        github_id <- readline("What is your GitHub ID? ")
    }
    
    variables <- read_yaml("https://raw.githubusercontent.com/michaelweylandt/STA9750/refs/heads/main/_variables.yml")
    course_repo  <- variables$course$repo
    course_short <- variables$course$short
    
    title <- glue("{course_short} {github_id} MiniProject #0{N}")
    
    body <- mp_text |> str_replace("YOUR_GITHUB_ID", github_id) |> str_squish()
    
    page <- 1
    
    issues <- list()
    
    while((length(issues) %% 100) == 0){
        new_issues <- gh("/repos/michaelweylandt/{repo}/issues?state=all&per_page=100&page={page}", 
                         repo=course_repo, 
                         page=page)
        
        if(length(new_issues) == 0){
            break
        }
        
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
    if(!require("yaml")) install.packages("yaml"); library(yaml)
    if(!require("gh")) install.packages("gh"); library(gh)
    if(!require("tidyverse")) install.packages("tidyverse"); library(tidyverse)
    if(!require("rvest")) install.packages("rvest"); library(rvest)
    if(!require("glue")) install.packages("glue"); library(glue)
    if(!require("lintr")) install.packages("lintr"); library(lintr)
    if(!require("httr2")) install.packages("httr2"); library(httr2)
    
    if(missing(N)){
        N <- menu(title="Which Mini-Project submission would you like to lint?", 
                  choices=c(1, 2, 3, 4))
    }
    
    if(missing(peer_id)){
        peer_id <- readline("What is your Peer's GitHub ID? ")
    }
    
    variables <- read_yaml("https://raw.githubusercontent.com/michaelweylandt/STA9750/refs/heads/main/_variables.yml")
    course_repo  <- variables$course$repo
    course_short <- variables$course$short
    
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
