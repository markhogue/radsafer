bet.df <- readr::read_tsv("C:/R/radsafer/data-raw/bet.dat.tsv")
usethis::use_data(bet.df, compress = "xz")

RN.df <- readr::read_tsv("C:/R/radsafer/data-raw/RN.dat.tsv")
usethis::use_data(RN.df, compress = "xz")
