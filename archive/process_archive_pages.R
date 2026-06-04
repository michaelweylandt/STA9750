library(tidyverse)
library(rvest)
library(xml2)

is_revealjs <- function(fname){
    readLines(fname) |> str_detect("Reveal.initialize") |> any()
}

is_redirect <- function(fname){
    (read_html(fname) |> html_element("title") |> html_text2()) == "Redirect"
}

add_archive_link <- function(fname){
    script <- read_html("archive/archive_js_stub.html")
    bar <- read_html("archive/archive_announcement_bar.html")

    page <- read_html(fname)

    has_link_already <- page |> html_element("#exit-archive-link")

    if(!is.na(has_link_already)) return()

    footer <- page |> html_element("footer")
    header <- page |> html_element("header")
    xml_add_sibling(footer, script, .where = "before")
    xml_add_sibling(header, bar, .where="after")

    write_html(page, fname)
}

modify_navbar <- function(fname){
    page <- read_html(fname)

    navlinks <- page |> html_elements(".nav-link:not(.dropdown-toggle)")

    for(a in navlinks){
        old_link <- a |> html_attr("href")
        new_link <- old_link |> str_remove(fixed("../../"))
        xml_set_attr(a, "href", new_link)
    }

    write_html(page, fname)
}

fs::dir_ls("docs/archive/AY-2025-SPRING",
           type="file",
           recurse=TRUE,
           glob="*html") |>
    discard(is_revealjs) |>
    discard(is_redirect) |>
    walk(add_archive_link) |>
    walk(modify_navbar)
