#####nainstaluji balíky, pokud ještě nemám
install.packages("dplyr")
install.packages("forcats")


#####nahraji balíky
library(dplyr)
library(forcats)


#####nahraji data (zkontroluj svou path)
data <- readRDS("_RDS/01_data_pro_test.RDS")

############co v datech mám?
str(data)
colnames(data)
head(data)
glimpse(data)
nrow(data)  ###1286 středních škol

###########################01 kolik škol, je v každém kraj?
##najdu v dplyr cheat_sheet správnou funkci => count()

data %>% 
  count(kraj)

##########################02 zmeňte sloupec kraj na faktor dle pořadí NUTS3. 
##co za proměnnou je teď kraj?
class(data$kraj)


##je to „character vector" a my chceme factor (viz vámi vytvořené myšlenkové mapy, připomeň si faktory)

##v dplyr měníme sloupce, jako bychom tvořili nové, takže funkce mutate()

#data <- data %>% 
# mutate(kraj = "?????") ###co tam doplnit?


####prozkoumejme funkci fct_relevel
?fct_relevel()

####vytvoříme zkušební vektor 
vektor <- c("b", "b", "a")
class(vektor) ##opět „character vektor"

###chceme ho změnit na facktor, kde "a" je první hodnota a "b" je druhá hodnota
new_vector <- fct_relevel(vector, "a", "b")

levels(new_vector)
##vida, "a" je první a lze "sortovat" (změnit pořadí dle pořadí faktorů)
sort(new_vector) 

##pojďme tedy zpátky k původnímu zadání
data <- data %>% 
  mutate(NUTS3 = kraj, #ponecháme původní sloupec v podobě NUT3 
         kraj = fct_relevel(kraj, c("Praha", "Středočeský", "Jihočeský", "Plzeňský", "Karlovarský",
                                    "Ústecký", "Liberecký","Královéhradecký", "Pardubický", "Vysočina", 
                                    "Jihomoravský", "Olomoucký", "Zlínský", "Moravskoslezský"))) %>% 
  arrange(kraj)  ####seřadit dle pořadí faktorů


data  ###první už jsou pražské školy

##########################03 přiřaďte školy do správných NUTS2
##mám 1286 SŠ, které potřebuji přiřadit do správných NUTS2

##vytvořím dataframe, který použiji jako převodník

prevodnik <- tibble(NUTS3 = c("Praha", "Středočeský", "Jihočeský", "Plzeňský", 
                              "Karlovarský","Ústecký", "Liberecký","Královéhradecký", "Pardubický", 
                              "Vysočina", "Jihomoravský", "Olomoucký", "Zlínský", "Moravskoslezský"),
                    NUTS2 = c("CZ01", "CZ02", "CZ03", "CZ03", 
                              "CZ04", "CZ04", "CZ05", "CZ05", "CZ05",
                              "CZ06", "CZ06", "CZ07", "CZ07", "CZ08"))

prevodnik


##použiji klíč data$NUTS3<=> prevodnik$NUTS2, abych přiřadil NUTS2 k df data

data <- data %>% 
  left_join(prevodnik, by = "NUTS3")


data # a je to :)
