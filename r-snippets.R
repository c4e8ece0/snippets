##############################
# Sape lookup
##############################
all <- read.table("export_linksseo_20150516134057.tsv", header=TRUE, sep="\t", quote="")
names(all)
sape <- all[all["Статус"]=="OK" & all["Цена"]<300, c("УВ", "ТиЦ", "ВС", "Цена", "Страниц.в.Google", "Страниц.в.Yandex")]
dim(sape) # [1] 7842    6
for(s in c("Страниц.в.Google", "Страниц.в.Yandex", "ТиЦ")) {
    sape[s] = log(sape[s])
}
plot(sape)

#############################
# Clustering of categorical
#############################
all <- read.table(filename, header = TRUE);
sel <- sample(1:nrow(all), min(10000,nrow(all)))
tab <- all[sel,]
res = kmodes(tab, 50, iter.max=10, weighted=TRUE)
f <- cbind(tab, res$cluster)
