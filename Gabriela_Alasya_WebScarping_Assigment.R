# Load packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(rvest, tidyverse)

# STEP 1: Load from LIVE site
page <- read_html("https://www.american.edu/cas/mathstat/faculty/")

# STEP 2: Grab all h1 blocks (the faculty names are in h1s)
faculty_blocks <- page %>% html_elements("h1") 

# STEP 3: Scrape information
names <- faculty_blocks %>%
  html_text2() %>%
  str_remove("\\|.*$") %>%
  str_trim()

emails <- faculty_blocks %>%
  html_element(xpath = "following::a[starts-with(@href, 'mailto:')][1]") %>%
  html_attr("href") %>%
  str_remove("^mailto:")

phones <- faculty_blocks %>%
  html_element(xpath = "following::a[starts-with(@href, 'tel:')][1]") %>%
  html_attr("href") %>%
  str_remove("^tel:")

# STEP 4: Combine into tibble
faculty_info <- tibble(
  name = names,
  email = emails,
  phone = phones)

# STEP 5: Save
write_csv(faculty_info, "faculty.csv")

# (Optional) View the table
View(faculty_info)
