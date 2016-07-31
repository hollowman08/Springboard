library(dplyr)
library(tidyr)
library(data.table)

## Loading CSV file
refine <- read.csv("refine_original.csv")

## Standardizing company names using string distance
library(stringdist)
codes <- c("phillips", "akzo", "van houten", "unilever")
company <- refine$company
strdist <- adist(company, codes)
colnames(strdist) <- codes
rownames(strdist) <- company
a <- amatch(company, codes, maxDist = 4)
refine_df <- data.frame(rawtext = company, company_name = codes[a])

## Add standardized columns to original data
refine1 <- cbind(refine, refine_df)
refine_tbl <- tbl_df(refine1)

## Split proudct code and product number into two columns
refine_tbl1 <- refine_tbl %>% 
     separate(Product.code...number, c("product code", "product number"))

## Create lookup values for product code
lookup_tbl <- c(p = "Smartphone", v = "TV", x = "Laptop", q = "Tablet")
refine_tbl2 <- refine_tbl1 %>%
     mutate(product_category = lookup_tbl[`product code`])

## Group address into one column
refine_tbl3 <- unite(refine_tbl2, full_address, address, city, country, sep = ",")

