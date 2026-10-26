# DTS 201 lecture-note practical, Week 12A: Image, text, audio, video
# Run from the project root (open DTS201_R.Rproj first).

# 1. Text: tokenise and count words
review <- c("The delivery was fast and the packaging was good",
            "Packaging was poor and delivery was slow",
            "Good price and fast delivery")
words <- unlist(strsplit(tolower(review), "[^a-z]+"))
sort(table(words), decreasing = TRUE)

# A tiny sentiment score using a word list
positive <- c("good", "fast"); negative <- c("poor", "slow")
sapply(strsplit(tolower(review), "[^a-z]+"), function(w) sum(w %in% positive) - sum(w %in% negative))

# 2. Audio: a 440 Hz tone sampled at 8,000 Hz for 0.01 seconds
fs <- 8000
t  <- seq(0, 0.01, by = 1 / fs)
wave <- sin(2 * pi * 440 * t)
plot(t, wave, type = "l", xlab = "Time (s)", ylab = "Amplitude", main = "440 Hz tone")
length(wave)                                  # number of samples

# 3. Image: an 8 x 8 grayscale picture is just a matrix
set.seed(42)
img <- matrix(0, 8, 8)
img[3:6, 3:6] <- 255                          # a bright square
img <- img + matrix(rnorm(64, 0, 20), 8, 8)   # add noise
image(t(img[8:1, ]), col = gray.colors(256, start = 0, end = 1), axes = FALSE, main = "Noisy square")
mean(img > 128)                               # share of 'bright' pixels

# 4. Video: a video is a list of such matrices (frames)
frames <- lapply(1:5, function(i) { m <- matrix(0, 8, 8); m[3:6, i:(i + 1)] <- 255; m })
sapply(frames, mean)                          # average brightness in each frame

