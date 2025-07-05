library(dplyr)
library(ggplot2)
library(tidyr)


# CSV dosyas??n?? i??e aktar
heart <- read.csv("C:/Rproject/heart.csv")

# Ba??ar??l?? olup olmad??????n?? kontrol etmek i??in ilk birka?? sat??ra bak
head(heart)




# Veri setindeki s??tun adlar??n??, veri tiplerini ve yap??s??n?? kontrol ediyoruz
str(heart)

# G??zlem ve de??i??ken say??s??n?? ????reniyoruz
dim(heart)

# T??m s??tunlara dair h??zl?? bir genel ??zet
summary(heart)



# Sadece say??sal s??tunlar??n ??zetini g??ster (opsiyonel)
summary(heart[, sapply(heart, is.numeric)])






# YAS ILERLEDIKCE DINLENME HALI NABZIN DUSUSU GOZLEMLENDI
plot(heart$Age, heart$MaxHR,
     main = "Age vs Max Heart Rate",
     xlab = "Age",
     ylab = "MaxHR",
     col = "tomato",
     pch = 19)




# COK ANLAMLI VERI URETMESE DE AGIR HIPERTANSIYON HASTALARI 40 YAS USTU
plot(heart$RestingBP, heart$Age,
     main = "Resting BP vs Age",
     xlab = "Resting Blood Pressure",
     ylab = "Age",
     col = "darkgreen",
     pch = 16)




#  Belirli bir ko??ula g??re filtreleme : Kalp hastas?? olan ve ya???? 50???den b??y??k olanlar?? se??
heart_filtered <- heart %>%
  filter(HeartDisease == 1, Age > 50)




# Kategorik bir de??i??kene g??re gruplama ve say??sal de??i??kenin ortalamas??n?? alma
#Cinsiyete g??re ortalama maksimum kalp at???? h??z??
mean_maxhr_by_sex <- heart %>%
  group_by(Sex) %>%
  summarise(mean_maxhr = mean(MaxHR, na.rm = TRUE))



#Say??sal bir de??i??kene g??re azalan s??rayla s??ralama
# Kolesterol???e g??re b??y??kten k????????e s??ralama
heart_sorted <- heart %>%
  arrange(desc(Cholesterol))




# Yeni bir de??i??ken olu??turma
# Kolesterol / ya?? oran?? (kendi hesaplad??????n bir sa??l??k g??stergesi gibi)
heart <- heart %>%
  mutate(chol_per_age = Cholesterol / Age)







#  1: Histogram ??? Cholesterol Da????l??m??
ggplot(heart, aes(x = Cholesterol)) +
  geom_histogram(binwidth = 10, fill = "steelblue", color = "black") +
  labs(title = "Cholesterol Distribution",
       x = "Cholesterol (mg/dl)",
       y = "Count")

#  2: Scatter Plot ??? Age vs MaxHR
ggplot(heart, aes(x = Age, y = MaxHR)) +
  geom_point(color = "darkred", size = 2) +
  labs(title = "Age vs Max Heart Rate",
       x = "Age",
       y = "Max Heart Rate")

#  3: Bar Plot ??? Cinsiyet Da????l??m??
ggplot(heart, aes(x = Sex)) +
  geom_bar(fill = "orange", color = "black") +
  labs(title = "Gender Distribution",
       x = "Sex",
       y = "Count")


#  Sadece HeartDisease == 1 olan bireylerin Cholesterol histogram??
heart_filtered <- heart %>%
  filter(HeartDisease == 1)

ggplot(heart_filtered, aes(x = Cholesterol)) +
  geom_histogram(binwidth = 10, fill = "royalblue", color = "black") +
  labs(title = "Cholesterol Distribution (Heart Disease Patients)",
       x = "Cholesterol (mg/dl)",
       y = "Count")







#  Cinsiyete g??re MaxHR ortalamas??n?? hesaplay??p bar plot ??iziyoruz
grouped_means <- heart %>%
  group_by(Sex) %>%
  summarise(mean_maxhr = mean(MaxHR, na.rm = TRUE))

ggplot(grouped_means, aes(x = Sex, y = mean_maxhr, fill = Sex)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Max Heart Rate by Gender",
       x = "Gender",
       y = "Average Max Heart Rate") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")













#  ChestPainType'a g??re mean/median Oldpeak hesapl??yoruz
summary_stats <- heart %>%
  group_by(ChestPainType) %>%
  summarise(mean_oldpeak = mean(Oldpeak, na.rm = TRUE),
            median_oldpeak = median(Oldpeak, na.rm = TRUE))

#  Veriyi uzun formata ??eviriyoruz
summary_stats_long <- summary_stats %>%
  pivot_longer(cols = c(mean_oldpeak, median_oldpeak),
               names_to = "statistic",
               values_to = "value")

#  Grouped Bar Plot ??iziyoruz
ggplot(summary_stats_long, aes(x = ChestPainType, y = value, fill = statistic)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Mean and Median Oldpeak by Chest Pain Type",
       x = "Chest Pain Type",
       y = "Oldpeak Value",
       fill = "Statistic") +
  theme_minimal()




#  Normalization (scale ile)
#  Sadece say??sal s??tunlar?? se??iyoruz
numeric_vars <- heart[, c("Age", "RestingBP", "Cholesterol", "MaxHR", "Oldpeak")]

#  scale() fonksiyonu ile normalize ediyoruz
normalized_vars <- as.data.frame(scale(numeric_vars))

#  Normalize edilmi?? veriyi orijinal veri setine ekliyoruz
heart_normalized <- cbind(heart, normalized_vars)

# ???? ??lk birka?? sat??r?? kontrol ediyoruz
head(heart_normalized)











#  ANOVA Testi 1: ChestPainType'a g??re Cholesterol farkl?? m???
anova_cp_chol <- aov(Cholesterol ~ ChestPainType, data = heart)

#  ANOVA sonu??lar??n?? g??r??nt??l??yoruz
summary(anova_cp_chol)

# ChestPainType'a g??re Cholesterol boxplot
ggplot(heart, aes(x = ChestPainType, y = Cholesterol, fill = ChestPainType)) +
  geom_boxplot() +
  labs(title = "Cholesterol Levels by Chest Pain Type",
       x = "Chest Pain Type",
       y = "Cholesterol (mg/dl)") +
  theme_minimal()

# ChestPainType gruplar?? aras??nda kolesterol d??zeyleri anlaml?? ??ekilde farkl??d??r.
#??zellikle ASY (asemptomatik) grubu, hem en y??ksek medyan kolesterol seviyesine,
#hem de daha fazla de??i??kenli??e ve ayk??r?? de??ere sahiptir.
#Bu durum hem grafiksel olarak hem de ANOVA testiyle (p < 0.001) do??rulanm????t??r.
# ASY T??P?? G??????S A??RISINA SAH??P K??????LER??N KOLESTEROL D??ZEY?? 0-240 C??VARI ARASINDA
# MEDYANLARI ??SE 230, HER ASYS?? OLAN 200 ??ST?? KOLESTEROLE SAH??P DE????L AMA D????ERLER??NDE HEMEN HEMEN ??YLE








# ANOVA Testi 2: Cinsiyete g??re MaxHR farkl?? m???
anova_sex_maxhr <- aov(MaxHR ~ Sex, data = heart)

# ANOVA sonu??lar??n?? g??r??nt??l??yoruz
summary(anova_sex_maxhr)

# Grafik: Cinsiyete g??re MaxHR boxplot
ggplot(heart, aes(x = Sex, y = MaxHR, fill = Sex)) +
  geom_boxplot() +
  labs(title = "Max Heart Rate by Gender",
       x = "Sex",
       y = "Max Heart Rate") +
  theme_minimal()

#p-value = 7.63e-09 ??? Bu de??er 0.05???ten ??ok k??????k ???
#Hatta 0.001???ten bile k??????k, yani ??ok anlaml?? bir sonu??.
#Cinsiyete g??re MaxHR (maksimum kalp h??z??) de??erlerinde istatistiksel olarak anlaml?? bir fark var.
#Kad??nlar??n erkeklere nazaran daha y??ksek maksimum nab??z de??eri var












# ANOVA Testi: FastingBS'e g??re MaxHR farkl?? m???
anova_fastingbs_maxhr <- aov(MaxHR ~ FastingBS, data = heart)

# ANOVA sonu??lar??n?? g??r??nt??l??yoruz
summary(anova_fastingbs_maxhr)

#Boxplot: FastingBS gruplar??na g??re MaxHR da????l??m??
ggplot(heart, aes(x = as.factor(FastingBS), y = MaxHR, fill = as.factor(FastingBS))) +
  geom_boxplot() +
  labs(title = "Max Heart Rate by Fasting Blood Sugar Status",
       x = "Fasting Blood Sugar (0 = Normal, 1 = High)",
       y = "Maximum Heart Rate (bpm)") +
  theme_minimal()

#Hem ANOVA testi (p < 0.001) hem de boxplot grafi??i, 
#a??l??k kan ??ekeri durumu ile maksimum kalp at??m h??z?? aras??nda 
#istatistiksel olarak anlaml?? bir fark oldu??unu g??stermektedir.
#Y??ksek kan ??ekeri olan bireylerin MaxHR de??erleri, 
#normal bireylerin de??erlerinden anlaml?? ??ekilde daha d??????kt??r.





