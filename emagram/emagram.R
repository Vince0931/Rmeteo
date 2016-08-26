library(gridBase)
library(grid)

#calcul echelle isobare

p0 <- 1013.25

t <- c(-70,-65,-60,-55,-50,-45,-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40)

lv<-c(200,300,350, 400, 450, 500, 550, 600, 650, 700, 
      750, 800, 850, 900, 950, 1000,p0)


z = (0:9)*1000
P = p0 * (1 - 0.0065*z/288.15 )^5.26

zl <- paste0("",z)

par(mar=c(2,6,2,6))


#draw ISOBARES

grille1 <- expand.grid(x = t, y = P )
plot(grille1, ylim= rev(range(grille1$y)), pch=NA_integer_, yaxt = 'n', log = 'y')


#abline(v = t, h = lv, col = "#CCCCCC")
abline(h = lv, col = "#CCCCCC")

axis(2, at = lv, las =2)
axis(4, at= P, labels = zl, las =2)


#draw ISOTHERMES à 45 °
#par(new=TRUE)
#curve(x+1, min(t), max(t)) #, xaxt = 'n', yaxt = 'n')
#par(new=TRUE)
#curve(x+2, min(t), max(t)) #, xaxt = 'n', yaxt = 'n')

#p_iso <- 1050
#t_iso <- 50

#y <- 764.4 - 254.8*log(p_iso)
#x <- 2.91*t_iso + y




#segments(0,p0,45,366.1274,col = "#CCCCCC")
#segments(5,p0,50,406.8082,col = "#CCCCCC")


#par(new=TRUE)




