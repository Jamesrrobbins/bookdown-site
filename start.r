#install.packages("blogdown")
library(blogdown)
#if (!requireNamespace("remotes")) install.packages("remotes")
 #remotes::install_github("rstudio/blogdown")
#new_site(theme = "wowchemy/starter-academic")
blogdown::serve_site() 
blogdown::check_gitignore()
blogdown::check_content()

#testing committ