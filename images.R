library(debug)
library(ggplot2)
data <- rbind(read.csv('images-hadoop.csv', header=F, col.names=c('time', 'index', 'bytes'), sep=' '),
              read.csv('images-local.csv', header=F, col.names=c('time', 'index', 'bytes'), sep=' '))
png("images.png")
ggplot(data=data, aes(x=time, y=bytes, col=index)) +
  geom_point() +
  stat_smooth(method=lm)

dev.off()
