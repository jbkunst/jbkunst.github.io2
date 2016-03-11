#' ---
#' title: "rchess a Chess Package for R"
#' author: "Joshua Kunst"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: yes
#' categories: R
#' layout: post
#' featured_image: /images/rchess-a-chess-package-for-r/rchess.jpg
#' ---
#+ setup, echo=FALSE, warning=FALSE, message=FALSE, results='hide'
rm(list = ls())
source(dir(pattern = "r_posts_helpers.R", recursive = TRUE, full.names = TRUE))

#' A lot time ago I wonder for some R package for chess. Python, JS, Java, C have chess libraries, why R not? But then the
#' [htmlwidgets](https://github.com/ramnathv/htmlwidgets) and [V8](https://github.com/jeroenooms/v8) packages were born and now
#' possibilities are *almost* endless. Anyone can make a wrapper for a JS library :D. And this is how [rchess](https://github.com/jbkunst/rchess)
#' came out.
#' 
#' The [rchess](https://github.com/jbkunst/rchess) package is a chess move, generation, validator; piece placement, movement,
#' and check/checkmate/stalemate detection. All this powered
#' by [V8](https://github.com/jeroenooms/v8) package and [chessjs](https://github.com/jhlywa/chess.js) javascript library.
#' 
#' The main parts about this package are:
#' 
#' - [V8](https://github.com/jeroenooms/v8) package and [chessjs](https://github.com/jhlywa/chess.js) javascript library. So this
#' is not about performance but have the things done (just like Just [@hrbrmstr](http://datadrivensecurity.info/blog/posts/2015/Oct/getting-into-the-zones-with-r-jsonlite/)
#' saids).
#' - [R6](https://github.com/wch/R6/) package for the OO system.
#' - [htmlwidgets](https://github.com/ramnathv/htmlwidgets) package and [chessboardjs](http://chessboardjs.com/) javascript library.
#' 
#' Now let's take a look what this package can do.

# devtools::install_github("jbkunst/rchess")
library("rchess")
chss <- Chess$new()

plot(chss)

#' WHOA chessboardjs have a nice look. Right?
#' 
#' The basic usage is the same as the [chessjs](https://github.com/jhlywa/chess.js) api. I'm just implemented only the calls to
#' this api. Anyway, to see the possibles moves you can use the *moves* method and if you make a move use the *move*
#' function.
chss$moves()

chss$moves(verbose = TRUE)

chss$move("a3")

#' We can also concate  moves, see who plays in the next turn, see the history, etc.:
chss$move("e5")$move("f4")$move("Qe7")$move("fxe5")

plot(chss)


chss$turn()

chss$history(verbose = TRUE)

chss$history()

#' A must have funcionality is load games from PGN and FEN notations:

chssfen <- Chess$new()
 
fen <- "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2"
 
chssfen$load(fen)

#' (Shh you can also plot the chesboard with ggplot. I know I need change that unicode style pieces ;) ). 

plot(chssfen, type = "ggplot")

#' Now load PGN string:

pgn <- system.file("extdata/pgn/kasparov_vs_topalov.pgn", package = "rchess")
pgn <- readLines(pgn, warn = FALSE)
pgn <- paste(pgn, collapse = "\n")

chsspgn <- Chess$new()

chsspgn$load_pgn(pgn)

cat(chsspgn$pgn())

head(chsspgn$history(verbose = TRUE), 20)

plot(chsspgn)

#' 
#' And that's it. If you want to check more funcionalities check the [github repository](https://github.com/jbkunst/rchess) or 
#' [this](http://rpubs.com/jbkunst/rchess2) document.
#' 
#' Bye mate!
