# inputs:
#   swiper: object representing somebody swiping left or right in a dating app
#   picture: picture of the person who is being swiped left or right
#   profile: profile text of the person who is being swiped left or right
# output: swipe left / swipe right
swipe <- function(swiper, picture, profile) {
  if (exists(picture)) {
    if (picture$attractive) {
      if (swiper[["sober"]]) {
        if (exists(profile)) {
          if (profile[["red_flags"]]) {
            if (swiper[["lonely"]]) {
              return("swipe right")
            } else {
              return("swipe left")
            }
          } else {
            if (picture %in% swiper[["preferences"]]) {
              if (swiper[["capricious"]]) {
                return("swipe left")
              } else {
                return("swipe right")
              }
            } else {
              return("swipe left")
            }
          }
        } else {
          stop("can't decide without a profile.")
        }
      } else {
        if (picture %in% swiper[["preferences"]]) {
          if (picture[["very_hot"]]) swiper[["take_screenshot"]]()
          return("swipe right")
        } else {
          return("swipe left")
        }
      }
    } else {
      return("swipe left")
    }
  } else {
    stop("can't decide without a picture.")
  }
}
