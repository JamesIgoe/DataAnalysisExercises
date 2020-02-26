# R - Logistic Regression
rm(list = ls())

stateData <- read.table("CostByStateAndSalary.csv", header = TRUE, sep = ",")
am.data = glm(formula = Liberal ~ Y2014, data = stateData, family = binomial)
print(summary(am.data))


# R - Chi Square
rm(list = ls())
stateData <- read.table("CostByStateAndSalary.csv", header = TRUE, sep = ",")

# Create vectors 
affluence.median <- median(stateData$Y2014, na.rm = TRUE)
affluence.v <- ifelse(stateData$Y2014 > affluence.median, 1, 0)
liberal.v <- stateData$Liberal

# Solve
pol.Data = table(liberal.v, affluence.v)
result <- chisq.test(pol.Data)
print(result)
print(pol.Data)


# LM - Multiple Regression  

# Load the data into a matrix  
oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")

# Access the vectors  
v1 <- oecdData$IQ
v2 <- oecdData$HofstederPowerDx
v3 <- oecdData$HofstederMasculinity
v4 <- oecdData$HofstederIndividuality
v5 <- oecdData$HofstederUncertaintyAvoidance
v6 <- oecdData$Diversity_Ethnic
v7 <- oecdData$Diversity_Linguistic
v8 <- oecdData$Diversity_Religious
v9 <- oecdData$Gini

# Gini ~ Hofstede  
relation1 <- lm(v9 ~ v2 + v3 + v4 + v5)
print(relation1)
print(summary(relation1))
print(anova(relation1))

# IQ ~ Hofstede Individuality, Linguistic Diversity  
relation1 <- lm(v1 ~ v4 + v7)
print(relation1)
print(summary(relation1))
print(anova(relation1))

plot(v4, v7, col = "blue", main = "Diversity", abline(lm(v7 ~ v4)), cex = 1.3, pch = 16, xlab = "Individuality", ylab = "Linguistic Diversity")


# LM - Linear Regression  

# Load the data into a matrix  
oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")
print(names(oecdData))

# Access the vectors  
v1 <- oecdData$IQ
v2 <- oecdData$HofstederPowerDx
v3 <- oecdData$HofstederMasculinity
v4 <- oecdData$HofstederIndividuality
v5 <- oecdData$HofstederUncertaintyAvoidance
v6 <- oecdData$Diversity_Ethnic
v7 <- oecdData$Diversity_Linguistic
v8 <- oecdData$Diversity_Religious
v9 <- oecdData$Gini
v10 <- oecdData$LifeExpectancy
v11 <- oecdData$InfantDeath

# IQ ~ Gini  
relation1 <- lm(v1 ~ v9)
print(relation1)
print(summary(relation1))

# IQ ~ Diversity_Linguistic  
relation2 <- lm(v1 ~ v7)
print(relation2)
print(summary(relation2))

plot(v1, v9, col = "blue", main = "Gini v IQ", abline(lm(v9 ~ v1)), cex = 1.3, pch = 16, xlab = "IQ", ylab = "Gini")

plot(v1, v7, col = "blue", main = "Linguistic Diversity v IQ", abline(lm(v7 ~ v1)), cex = 1.3, pch = 16, xlab = "IQ", ylab = "Linguistoc Diversity")

cor.test(v1, v8)

plot(v1, v8, col = "blue", main = "Religious Diversity v IQ", abline(lm(v8 ~ v1)), cex = 1.3, pch = 16, xlab = "IQ", ylab = "Religious Diversity")

oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")
gini.v <- oecdData$Gini
death.v <- oecdData$InfantDeath
cor.test(gini.v, death.v)
plot(gini.v, death.v, col = "blue", main = "Infant Death v Gini", abline(lm(death.v ~ gini.v)), cex = 1.3, pch = 16, xlab = "Gini", ylab = "Infant Death")

v12 <- oecdData$Obesity
cor.test(v9, v12)
plot(v9, v11, col = "blue", main = "Obesity v Gini", abline(lm(v11 ~ v9)), cex = 1.3, pch = 16, xlab = "Gini", ylab = "Obesity")


# Attempt to plot Logistic Regression
rm(list = ls())

stateData <- read.table("CostByStateAndSalary.csv", header = TRUE, sep = ",")
lib.v = stateData$Liberal
income.v = stateData$Y2014
am.data = glm(formula = Liberal ~ Y2014, data = stateData, family = binomial)
print(summary(am.data))

plot(lib.v ~ income.v, abline(glm(lib.v ~ income.v, family = binomial)), xlab = "Income", ylab = "Liberal")



# LM - Multiple Regression - New Hofsteder, LTO and Ind
# Load the  data into a mattrix
rm(list = ls())

# setwd("C:/Users/James/Documents/visual studio 2015/Projects/rTutorial/TutorialsPoint/Data")
# setwd("H:/Personal/Code/TFS2013/RTutorials/TutorialsPoint/Data")
setwd("../Data")

oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")
print(names(oecdData))

# Access the vectors
v1 <- oecdData$IQ
v2 <- oecdData$HofstederPowerDx
v3 <- oecdData$HofstederMasculinity
v4 <- oecdData$HofstederIndividuality
v5 <- oecdData$HofstederUncertaintyAvoidance
v6 <- oecdData$HofstederLongtermOritentation
v7 <- oecdData$HofstederIndulgence

v9 <- oecdData$Gini
v10 <- oecdData$Obesity
v26 <- oecdData$Assaultsandthreats


# Conclusion, higher LTO countries have higher average IQ scores
# IQ ~ Hofstede
relation1 <- lm(v1 ~ v2 + v3 + v4 + v5 + v6 + v7)
print(relation1)
print(summary(relation1))
print(anova(relation1))


# Corr - LTO ~ IQ
cor.test(v1, v6)
plot(v1, v6, col = "blue", main = "LTO ~ IQ", abline(lm(v6 ~ v1)), cex = 1.3, pch = 16, xlab = "IQ", ylab = "LTO")


# Conclusion, both high individuality and low LTO contribute to obesity
#    but inversely correlated with each other
# Obesity ~ Hofstede
relation1 <- lm(v10 ~ v2 + v3 + v4 + v5 + v6 + v7)
print(relation1)
print(summary(relation1))
print(anova(relation1))

# Corr - Obesity ~ LTO
cor.test(v6, v10)
plot(v10, v6, col = "blue", main = "Obesity ~ LTO", abline(lm(v6 ~ v10)), cex = 1.3, pch = 16, xlab = "Obesity", ylab = "LTO")

# Corr - Obesity ~ Idv
cor.test(v4, v10)
plot(v10, v4, col = "blue", main = "Obesity ~ Individuality", abline(lm(v4 ~ v10)), cex = 1.3, pch = 16, xlab = "Obesity", ylab = "Individuality")

# Corr - Idv, LTO
cor.test(v4, v6)

# Refined linear model
# IQ ~ Hofstede
relation1 <- lm(v1 ~ v4 + v6)
print(relation1)
print(summary(relation1))
print(anova(relation1))



# Conclusion, both high individuality and high indulgence correlate with assault reports
# Assault ~ Hofstede
relation1 <- lm(v26 ~ v2 + v3 + v4 + v5 + v6 + v7)
print(relation1)
print(summary(relation1))
print(anova(relation1))

# Corr - Assault ~ Idv
cor.test(v26, v4)
plot(v26, v4, col = "blue", main = "Assault ~ Individuality", abline(lm(v4 ~ v26)), cex = 1.3, pch = 16, xlab = "Assault", ylab = "Individuality")

# Corr - Assault ~ Ind
cor.test(v26, v7)
plot(v26, v7, col = "blue", main = "Assault ~ Indulgence", abline(lm(v7 ~ v26)), cex = 1.3, pch = 16, xlab = "Assault", ylab = "Indulgence")

# Corr - Assault ~ LTO
cor.test(v26, v6)
plot(v26, v6, col = "blue", main = "Assault ~ LTO", abline(lm(v6 ~ v26)), cex = 1.3, pch = 16, xlab = "Assault", ylab = "LTO")

# Corr - Idv, Ind
cor.test(v4, v7)
# Corr - Idv, LTO
cor.test(v4, v6)
# Corr - Ind, LTO
cor.test(v6, v7)

# Refiend - only individuality matters to assault
# Assault ~ Hofstede
relation1 <- lm(v26 ~ v4 + v6 + v7)
print(relation1)
print(summary(relation1))
print(anova(relation1))



# LM - Multiple Regression - New Hofsteder, PISA
# Load the  data into a mattrix
rm(list = ls())

# setwd("C:/Users/James/Documents/visual studio 2015/Projects/rTutorial/TutorialsPoint/Data")
# setwd("H:/Personal/Code/TFS2013/RTutorials/TutorialsPoint/Data")
setwd("../Data")

oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")
print(names(oecdData))

# Access the vectors
v2 <- oecdData$HofstederPowerDx
v3 <- oecdData$HofstederMasculinity
v4 <- oecdData$HofstederIndividuality
v5 <- oecdData$HofstederUncertaintyAvoidance
v6 <- oecdData$HofstederLongtermOrientation
v7 <- oecdData$HofstederIndulgence

v9 <- oecdData$PISAScience
v10 <- oecdData$PISAMath
v11 <- oecdData$PISAReading
v12 <- oecdData$IQ
v13 <- oecdData$Gini


# PISAMath ~ Hofstede
# Only LTO and Math have a relation
relation1 <- lm(v10 ~ v2 + v3 + v4 + v5 + v6 + v7)
print(relation1)
print(summary(relation1))
print(anova(relation1))

# Corr - LTO ~ PisaMath
# Higher math, Higher LTO
cor.test(v6, v10)


# Gini ~ PISA
# Only math seems to have any relations
relation1 <- lm(v13 ~ v9 + v10 + v11)
print(relation1)
print(summary(relation1))
print(anova(relation1))

# Corr - Gini, PisaMath
# Higher Math, lower Gini
cor.test(v10, v13)

# Corr - LTO ~ PisaMath
# Higher LTO, lower Gini
cor.test(v6, v13)


# IQ ~ PISA
# Both Math and Reading have a relationship
relation1 <- lm(v12 ~ v9 + v10 + v11)
print(relation1)
print(summary(relation1))
print(anova(relation1))

# Corr - Gini, PisaMath
# Higher Math, Higher IQ
cor.test(v10, v12)

# Corr - LTO ~ PisaMath
# Although indicated, Higher Reading does not correlate with higher IQ
cor.test(v11, v12)

# IQ ~ PISA
# Removing science - increases Math relationship
relation1 <- lm(v12 ~ v10 + v11)
print(relation1)
print(summary(relation1))
print(anova(relation1))



# LM - Multiple Regression - Patents, minus Asia
# Clear workspace
rm(list = ls())

# Set working directory
setwd("../../Data")

oecdData <- read.table("OECD - Quality of Life - Minus Asia.csv", header = TRUE, sep = ",")
print(names(oecdData))


# Set Vectors
# Primary focus
vPatents <- oecdData$Patents
vPatentsPerCapita <- oecdData$PatentsPerCapita

# Hofstede
vPowerDx <- oecdData$HofstederPowerDx
vMasculinity <- oecdData$HofstederMasculinity
vIndividuality <- oecdData$HofstederIndividuality
vUncertaintyAvoidance <- oecdData$HofstederUncertaintyAvoidance
vLTO <- oecdData$HofstederLongtermOrientation
vIndulgence <- oecdData$HofstederIndulgence

# Education
vPisaScience <- oecdData$PISAScience
vPisaMath <- oecdData$PISAMath
vPisaReading <- oecdData$PISAReading
vIQ <- oecdData$IQ
vTertiaryEdu <- oecdData$TertiaryEdu
vEduReading <- oecdData$EduReading
vEduScience <- oecdData$EduScience

# Social welfare
vGini <- oecdData$Gini
vLifeExpectancy <- oecdData$LifeExpectancy
vObesity <- oecdData$Obesity
vInfantDeath <- oecdData$InfantDeath
vHoursWorked <- oecdData$HoursWorked


# Patents per Capita ~ Hofstede
# Individuality, Unambiguity Tolerance
Hofstede_PatentsPerCapita <- lm(vPatentsPerCapita ~ vPowerDx + vIndividuality + vMasculinity + vUncertaintyAvoidance + vLTO + vIndulgence)
print(Hofstede_PatentsPerCapita)
print(summary(Hofstede_PatentsPerCapita))
print(anova(Hofstede_PatentsPerCapita))

cor.test(vPatentsPerCapita, vIndividuality)
plot(vPatentsPerCapita, vIndividuality, col = "blue", main = "Patents Per Capita ~ Individuality", abline(lm(vIndividuality ~ vPatentsPerCapita)), cex = 1.3, pch = 16, xlab = "Patents per Capita", ylab = "Individuality")

cor.test(vPatentsPerCapita, vUncertaintyAvoidance)
plot(vPatentsPerCapita, vUncertaintyAvoidance, col = "blue", main = "Patents Per Capita ~ Uncertainty Avoidance", abline(lm(vUncertaintyAvoidance ~ vPatentsPerCapita)), cex = 1.3, pch = 16, xlab = "Patents per Capita", ylab = "Uncertainty Avoidance")

cor.test(vPatentsPerCapita, vPowerDx)
plot(vPatentsPerCapita, vPowerDx, col = "blue", main = "Patents Per Capita ~ vPowerDx", abline(lm(vPowerDx ~ vPatentsPerCapita)), cex = 1.3, pch = 16, xlab = "Patents per Capita", ylab = "vPowerDx")


# Patents per Capita ~ Social Welfare
# Obesity only
SocialWelfare <- lm(vPatentsPerCapita ~ vHoursWorked + vObesity + vInfantDeath + vLifeExpectancy)
print(SocialWelfare)
print(summary(SocialWelfare))
print(anova(SocialWelfare))

cor.test(vPatentsPerCapita, vObesity)
plot(vPatentsPerCapita, vObesity, col = "blue", main = "vPatentsPerCapita ~ vObesity", abline(lm(vObesity ~ vPatentsPerCapita)), cex = 1.3, pch = 16, xlab = "Patents per Capita", ylab = "Obesity")


# LM - Multiple Regression - Patents, includes Asia
# Clear workspace
rm(list = ls())

# Set working directory
setwd("../../Data")

oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")
print(names(oecdData))

# Set Vectors
# Primary focus
vPatents <- oecdData$Patents
vPatentsPerCapita <- oecdData$PatentsPerCapita

# Hofstede
vPowerDx <- oecdData$HofstederPowerDx
vMasculinity <- oecdData$HofstederMasculinity
vIndividuality <- oecdData$HofstederIndividuality
vUncertaintyAvoidance <- oecdData$HofstederUncertaintyAvoidance
vLTO <- oecdData$HofstederLongtermOrientation
vIndulgence <- oecdData$HofstederIndulgence

# Education
vPisaScience <- oecdData$PISAScience
vPisaMath <- oecdData$PISAMath
vPisaReading <- oecdData$PISAReading
vIQ <- oecdData$IQ
vTertiaryEdu <- oecdData$TertiaryEdu
vEduReading <- oecdData$EduReading
vEduScience <- oecdData$EduScience

# Social welfare
vGini <- oecdData$Gini
vLifeExpectancy <- oecdData$LifeExpectancy
vObesity <- oecdData$Obesity
vInfantDeath <- oecdData$InfantDeath
vHoursWorked <- oecdData$HoursWorked


# Patents per Capita ~ Hofstede
# Individuality, Unambiguity Tolerance
Hofstede_PatentsPerCapita <- lm(vPatentsPerCapita ~ vPowerDx + vIndividuality + vMasculinity + vUncertaintyAvoidance + vLTO + vIndulgence)
print(Hofstede_PatentsPerCapita)
print(summary(Hofstede_PatentsPerCapita))
print(anova(Hofstede_PatentsPerCapita))

cor.test(vPatentsPerCapita, vPisaScience)
plot(vPatentsPerCapita, vPisaScience, col = "blue", main = "vPatentsPerCapita ~ vPisaScience", abline(lm(vPisaScience ~ vPatentsPerCapita)), cex = 1.3, pch = 16, xlab = "Patents per Capita", ylab = "vPisaScience")

cor.test(vPatentsPerCapita, vPisaMath)
plot(vPatentsPerCapita, vPisaMath, col = "blue", main = "vPatentsPerCapita ~ vPisaMath", abline(lm(vPisaScience ~ vPatentsPerCapita)), cex = 1.3, pch = 16, xlab = "Patents per Capita", ylab = "vPisaMath")

cor.test(vPatentsPerCapita, vIQ)
plot(vPatentsPerCapita, vIQ, col = "blue", main = "vPatentsPerCapita ~ vIQ", abline(lm(vIQ ~ vPatentsPerCapita)), cex = 1.3, pch = 16, xlab = "Patents per Capita", ylab = "vIQ")

cor.test(vPatentsPerCapita, vEduScience)
plot(vPatentsPerCapita, vEduScience, col = "blue", main = "vPatentsPerCapita ~ vEduScience", abline(lm(vEduScience ~ vPatentsPerCapita)), cex = 1.3, pch = 16, xlab = "Patents per Capita", ylab = "vEduScience")
