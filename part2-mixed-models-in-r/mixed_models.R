## ----setup, include=FALSE------------------------------------------------
options(htmltools.dir.version = FALSE)
# see: https://github.com/yihui/xaringan
# install.packages("xaringan")
# see: 
# https://github.com/yihui/xaringan/wiki
# https://github.com/gnab/remark/wiki/Markdown
options(width=110)
options(digits = 4)


## ---- message=FALSE------------------------------------------------------
# Session -> Set Working Directory ->
# -> To Source File Location
load("ssk16_dat_prepared_ex2.rda") 
# full data: https://osf.io/j4swp/
str(dat2, width=50, strict.width = "cut")


## ---- fig.height=6, dev='svg', message=FALSE-----------------------------
library("tidyverse")
theme_set(theme_bw(base_size = 17))
ggplot(data = dat2) + 
  geom_point(mapping = aes(x = B_given_A, 
                           y = if_A_then_B), 
             alpha = 0.2, pch = 16, size = 3) + 
  coord_fixed()


## ------------------------------------------------------------------------
m_fixed <- lm(if_A_then_B_c ~ B_given_A_c, dat2)
summary(m_fixed)


## ---- echo=FALSE, dpi=300, fig.width=4, fig.height=4, dev='svg'----------
ggplot(data = dat2, aes(x = B_given_A_c, y = if_A_then_B_c)) + 
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(intercept = coef(m_fixed)[1], slope = coef(m_fixed)[2], size = 1.5) +
  coord_fixed() 


## ---- echo=FALSE, fig.width=3.5, fig.height=4, dev='svg'-----------------
ggplot(data = dat2, aes(x = B_given_A_c, y = if_A_then_B_c)) + 
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(intercept = coef(m_fixed)[1], slope = coef(m_fixed)[2], size = 1.5) +
  coord_fixed()


## ---- echo=FALSE, dpi=500, fig.width=3.5, fig.height=4, warning=FALSE, message=FALSE----
library("lme4")
m_tmp <- lmer(if_A_then_B_c ~ B_given_A_c + (0+B_given_A_c|p_id), dat2)
rnd_coefs <- as_tibble(coef(m_tmp)$p_id)

ggplot(data = dat2, aes(x = B_given_A_c, y = if_A_then_B_c)) + 
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(data = rnd_coefs, aes_string(intercept = "`(Intercept)`", 
                                     slope = "B_given_A_c"), 
              color = "lightgrey", size = 1.2) +
  geom_abline(intercept = coef(m_fixed)[1], slope = coef(m_fixed)[2], size = 1.5) +
  coord_fixed()


## ---- echo=FALSE, dpi=300, fig.width=3.5, fig.height=3.5, warning=FALSE, out.width='20%'----
m_tmp <- lmer(if_A_then_B_c ~ B_given_A_c + (1+B_given_A_c|p_id), dat2)
rnd_coefs <- as_tibble(coef(m_tmp)$p_id)

ggplot(data = dat2, aes(x = B_given_A_c, y = if_A_then_B_c)) + 
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(data = rnd_coefs, aes_string(intercept = "`(Intercept)`", 
                                     slope = "B_given_A_c"), 
              color = "lightgrey", size = 1.2) +
  geom_abline(intercept = coef(m_fixed)[1], slope = coef(m_fixed)[2], size = 1.5) +
  coord_fixed() 


## ---- echo=FALSE, dpi=300, fig.width=3.5, fig.height=4, warning=FALSE , out.width='25%'----
rnd_coefs <- as_tibble(coef(m_tmp)$p_id)
ggplot(data = dat2, aes(x = B_given_A_c, y = if_A_then_B_c)) + 
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(data = rnd_coefs, aes_string(intercept = "`(Intercept)`", 
                                     slope = "B_given_A_c"), 
              color = "lightgrey", size = 1.2) +
  geom_abline(intercept = coef(m_fixed)[1], slope = coef(m_fixed)[2], size = 1.5) +
  coord_fixed()


## ------------------------------------------------------------------------
library("lme4")
m_r <- lmer(if_A_then_B_c ~ B_given_A_c + (1+B_given_A_c|p_id), dat2)
summary(m_r)


## ---- echo=FALSE, dpi=500, fig.width=7, fig.height=4, warning=FALSE, out.width='80%'----
ggplot(dat2, aes(y = if_A_then_B_c, x = B_given_A_c)) +
  geom_point(alpha = 0.2, pch = 16, size = 3) +
  facet_wrap(~ rel_cond) + 
  coord_fixed()


## ---- message=FALSE------------------------------------------------------
afex::set_sum_contrasts()
m_fixed <- lm(if_A_then_B_c ~ 
                B_given_A_c*rel_cond, dat2)
summary(m_fixed)


## ---- echo=FALSE, dpi=500, fig.width=7, fig.height=4, warning=FALSE------
slopes <- data_frame(
  intercept = coef(m_fixed)[1] + c(1, -1)*coef(m_fixed)[3],
  slope = coef(m_fixed)[2] + c(1, -1)*coef(m_fixed)[4],
  rel_cond = factor(c("PO", "IR"), levels = c("PO", "IR"))
)
ggplot(dat2, aes(y = if_A_then_B_c, x = B_given_A_c)) +
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(data = slopes, aes(intercept = intercept, slope = slope),
              size = 1.5) +
  facet_wrap(~ rel_cond) + 
  coord_fixed()


## ---- echo=FALSE, dpi=500, fig.width=7, fig.height=4---------------------
ggplot(dat2, aes(y = if_A_then_B_c, x = B_given_A_c)) +
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(data = slopes, aes(intercept = intercept, slope = slope), 
              size = 1.5) +
  facet_wrap(~ rel_cond) + 
  coord_fixed()


## ---- echo=FALSE, dpi=500, fig.width=7, fig.height=4, warning=FALSE------
m_tmp <- lmer(if_A_then_B_c ~ B_given_A_c*rel_cond + (0+B_given_A_c|p_id), dat2)
rnd_coefs <- as_tibble(coef(m_tmp)$p_id)

rnd_coefs2 <- bind_rows(
  tibble(
    rel_cond = factor("PO", levels = c("PO", "IR")),
    intercept = rnd_coefs$`(Intercept)` + rnd_coefs$rel_cond1,
    slope = rnd_coefs$B_given_A_c + rnd_coefs$`B_given_A_c:rel_cond1`
  ),
  tibble(
    rel_cond = factor(c("IR"), levels = c("PO", "IR")),
    intercept = rnd_coefs$`(Intercept)` - rnd_coefs$rel_cond1,
    slope = rnd_coefs$B_given_A_c - rnd_coefs$`B_given_A_c:rel_cond1`
  )
)

ggplot(dat2, aes(y = if_A_then_B_c, x = B_given_A_c)) +
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(data = rnd_coefs2, aes(intercept = intercept, slope = slope), 
              size = 1.2, color = "lightgrey") +
  geom_abline(data = slopes, aes(intercept = intercept, slope = slope), 
              size = 1.5) +
  facet_wrap(~ rel_cond) + 
  coord_fixed()


## ---- echo=FALSE, dpi=500, fig.width=7, fig.height=3.5, warning=FALSE----
m_tmp <- lmer(if_A_then_B_c ~ B_given_A_c*rel_cond + (1+B_given_A_c|p_id), dat2)
rnd_coefs <- as_tibble(coef(m_tmp)$p_id)
rnd_coefs2 <- bind_rows(
  tibble(
    rel_cond = factor("PO", levels = c("PO", "IR")),
    intercept = rnd_coefs$`(Intercept)` + rnd_coefs$rel_cond1,
    slope = rnd_coefs$B_given_A_c + rnd_coefs$`B_given_A_c:rel_cond1`
  ),
  tibble(
    rel_cond = factor(c("IR"), levels = c("PO", "IR")),
    intercept = rnd_coefs$`(Intercept)` - rnd_coefs$rel_cond1,
    slope = rnd_coefs$B_given_A_c - rnd_coefs$`B_given_A_c:rel_cond1`
  )
)

ggplot(dat2, aes(y = if_A_then_B_c, x = B_given_A_c)) +
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(data = rnd_coefs2, aes(intercept = intercept, slope = slope), 
              size = 1.2, color = "lightgrey") +
  geom_abline(data = slopes, aes(intercept = intercept, slope = slope), 
              size = 1.5) +
  facet_wrap(~ rel_cond) + 
  coord_fixed()


## ---- message=FALSE------------------------------------------------------
library("lme4")
m_p_max <- 
  lmer(if_A_then_B_c ~ B_given_A_c*rel_cond + 
         (B_given_A_c*rel_cond|p_id), dat2)
summary(m_p_max)$varcor
summary(m_p_max)$coefficients



## ---- echo=FALSE, dpi=500, fig.width=7, fig.height=4, warning=FALSE------
rnd_coefs <- as_tibble(coef(m_p_max)$p_id)
rnd_coefs2 <- bind_rows(
  tibble(
    rel_cond = factor("PO", levels = c("PO", "IR")),
    intercept = rnd_coefs$`(Intercept)` + rnd_coefs$rel_cond1,
    slope = rnd_coefs$B_given_A_c + rnd_coefs$`B_given_A_c:rel_cond1`
  ),
  tibble(
    rel_cond = factor(c("IR"), levels = c("PO", "IR")),
    intercept = rnd_coefs$`(Intercept)` - rnd_coefs$rel_cond1,
    slope = rnd_coefs$B_given_A_c - rnd_coefs$`B_given_A_c:rel_cond1`
  )
)

ggplot(dat2, aes(y = if_A_then_B_c, x = B_given_A_c)) +
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(data = rnd_coefs2, aes(intercept = intercept, slope = slope), 
              size = 1.2, color = "lightgrey") +
  geom_abline(data = slopes, aes(intercept = intercept, slope = slope), 
              size = 1.5) +
  facet_wrap(~ rel_cond) + 
  theme_light() + coord_fixed() +
  theme(text = element_text(size=20))


## ------------------------------------------------------------------------
m_max <- lmer(if_A_then_B_c ~ B_given_A_c*rel_cond + 
                (B_given_A_c*rel_cond|p_id) + 
                (B_given_A_c*rel_cond|i_id), 
              dat2)


## ------------------------------------------------------------------------
summary(m_max)


## ---- echo=FALSE, message=FALSE, warning=FALSE, results='hide'-----------
library("broom")
no_pooling_estimates <- dat2 %>% 
  group_by(p_id, rel_cond) %>% 
  do(tidy(lm(if_A_then_B_c~B_given_A_c, .))) %>% 
  filter(term == "B_given_A_c") %>% 
  rename(no_pooling = estimate)

partial_pooling_estimates <- data.frame(p_id = rownames(coef(m_max)$p_id),
           PO = coef(m_max)$p_id[,2] + coef(m_max)$p_id[,4],
           IR = coef(m_max)$p_id[,2] - coef(m_max)$p_id[,4])
partial_pooling_estimates <- tidyr::gather(partial_pooling_estimates, key = "rel_cond", value = "partial_pooling", PO, IR)

estimates <- left_join(no_pooling_estimates, partial_pooling_estimates)



## ---- echo=FALSE, out.width='500px', out.height='300px', dpi = 500, fig.width=7, fig.height=7*3/5----

ggplot(data = estimates) + 
  geom_point(mapping = aes(x = no_pooling, y = partial_pooling), alpha = 1.0, pch = 16) + 
  facet_grid(rel_cond ~ .) + 
  coord_fixed() + 
  geom_abline(slope = 1, intercept = 0) + 
  theme(text=element_text(size=18))



## ---- echo=FALSE, out.width='400px', out.height='350px', dpi = 500, fig.width=7, fig.height=7*35/40----
estimates_l <- estimates %>% 
  gather("key","estimate",no_pooling, partial_pooling) 

ggplot(data = estimates_l, aes(estimate)) + 
  geom_histogram(binwidth = 0.2) + 
  facet_grid(key ~ rel_cond) +
  theme(text=element_text(size=18))


## ---- echo=FALSE, out.width='1000px', out.height='500px', dpi = 500, fig.width=10, fig.height=5----

df_gravity <- as.data.frame(summary(emmeans::emtrends(m_fixed, "rel_cond", var = "B_given_A_c")))
df_gravity <- df_gravity %>% 
  select(rel_cond, B_given_A_c.trend) %>% 
  spread(rel_cond, B_given_A_c.trend) %>% 
  mutate(key = "complete_pooling")

estimates_l %>% 
  select(-std.error, -statistic, -p.value) %>% 
  spread(rel_cond, estimate) %>% 
  na.omit() %>% 
  ungroup %>% 
  ggplot() + 
  aes(x = PO, y = IR, color = key) + 
  geom_point(size = 2) + 
  geom_point(data = df_gravity, size = 5) + 
  # Draw an arrow connecting the observations between models
  geom_path(aes(group = p_id, color = NULL, alpha = 0.1), 
            arrow = arrow(length = unit(.02, "npc"))) + 
  theme(legend.position = "bottom") + 
  ggtitle("Pooling of regression parameters") + 
  scale_color_brewer(palette = "Dark2") 



## ---- eval=FALSE---------------------------------------------------------
## library("afex")
## mixed(if_A_then_B_c ~ B_given_A_c*rel_cond + (B_given_A_c*rel_cond|p_id), dat2, dat2, method = "KR")
## mixed(if_A_then_B_c ~ B_given_A_c*rel_cond + (B_given_A_c*rel_cond|p_id), dat2, dat2, method = "S")
## mixed(if_A_then_B_c ~ B_given_A_c*rel_cond + (B_given_A_c*rel_cond|p_id), dat2, method = "LRT")
## # mixed(if_A_then_B_c ~ B_given_A_c*rel_cond + (B_given_A_c*rel_cond|p_id), dat2, method = "PB")


## ---- echo=FALSE, results='hide', message=FALSE--------------------------
library("afex")


## ---- results='hide', message=FALSE--------------------------------------
m_red <- mixed(
  if_A_then_B_c ~ B_given_A_c*rel_cond + 
    (B_given_A_c*rel_cond||p_id), 
  dat2, method = "S", 
  expand_re = TRUE)

## ------------------------------------------------------------------------
summary(m_red)$varcor


## ------------------------------------------------------------------------
m_red


## ---- echo=FALSE, dpi=500, fig.width=7, fig.height=4, warning=FALSE------
rnd_coefs <- as_tibble(coef(m_red$full_model)$p_id)
rnd_coefs2 <- bind_rows(
  tibble(
    rel_cond = factor("PO", levels = c("PO", "IR")),
    intercept = rnd_coefs$`(Intercept)` + 
      rnd_coefs$rel_cond1 + rnd_coefs$re1.rel_cond1,
    slope = rnd_coefs$B_given_A_c + rnd_coefs$`B_given_A_c:rel_cond1` + rnd_coefs$re1.B_given_A_c + rnd_coefs$re1.B_given_A_c_by_rel_cond1
  ),
  tibble(
    rel_cond = factor(c("IR"), levels = c("PO", "IR")),
    intercept = rnd_coefs$`(Intercept)` - 
      (rnd_coefs$rel_cond1 + rnd_coefs$re1.rel_cond1),
    slope = rnd_coefs$B_given_A_c + rnd_coefs$re1.B_given_A_c - (rnd_coefs$`B_given_A_c:rel_cond1` + rnd_coefs$re1.B_given_A_c_by_rel_cond1)
  )
)

ggplot(dat2, aes(y = if_A_then_B_c, x = B_given_A_c)) +
  geom_point(alpha = 0.2, pch = 16, size = 3) + 
  geom_abline(data = rnd_coefs2, aes(intercept = intercept, slope = slope), 
              size = 1.2, color = "lightgrey") +
  geom_abline(data = slopes, aes(intercept = intercept, slope = slope), 
              size = 1.5) +
  facet_wrap(~ rel_cond) + 
  coord_fixed()


## ------------------------------------------------------------------------
library("afex")
ma_1 <- mixed(if_A_then_B_c ~ B_given_A_c*rel_cond + (B_given_A_c*rel_cond|p_id) + 
                (B_given_A_c*rel_cond|i_id), dat2, method = "S") 

ma_2 <- mixed(if_A_then_B_c ~ B_given_A_c*rel_cond + (B_given_A_c*rel_cond||p_id) + 
                (B_given_A_c*rel_cond||i_id), dat2, method = "S", expand_re = TRUE) 


## ------------------------------------------------------------------------
summary(ma_2)$varcor

ma_3 <- mixed(if_A_then_B_c ~ B_given_A_c*rel_cond + (B_given_A_c*rel_cond||p_id) + 
                (B_given_A_c+rel_cond||i_id), dat2, method = "S", expand_re = TRUE) 


## ------------------------------------------------------------------------
ma_3 ## or: nice(ma_3)


## ------------------------------------------------------------------------
summary(ma_3) ## lme4 summary() output


## ------------------------------------------------------------------------
summary(ma_3)$varcor


## ------------------------------------------------------------------------
summary(ma_3)$coefficients %>% zapsmall


## ---- message=FALSE------------------------------------------------------
nice(ma_3) %>% as.data.frame()


## ------------------------------------------------------------------------
library("emmeans")
emm_options(lmer.df = "asymptotic") 
# or "Kenward-Roger" or "Satterthwaite"
emmeans(ma_3, "rel_cond")


## ------------------------------------------------------------------------
p1 <- afex_plot(ma_3, "rel_cond")

p2 <- afex_plot(ma_3, "rel_cond", 
                id = "p_id", 
                data_geom = ggpol::geom_boxjitter,
                mapping = "fill")


## ---- fig.width=5.5, fig.height=4, dev='svg'-----------------------------
p2


## ------------------------------------------------------------------------
emm_options(lmer.df = "asymptotic") 
# or "Kenward-Roger" or "Satterthwaite"
emtrends(ma_3, "rel_cond", var = "B_given_A_c")


## ------------------------------------------------------------------------
fixef(ma_3$full_model)[2] + fixef(ma_3$full_model)[4] 


## ---- eval=FALSE---------------------------------------------------------
## m_fhch <- mixed(log_rt ~ task*stimulus*density*frequency*length +
##                   (stimulus*density*frequency*length|id) +
##                   (task|item), fhch2010,
##                 method = "S", expand_re = TRUE)
## 
## ## note: id RE-term has 24 parameters! Estimation of 276 correlations unrealistic!


## ------------------------------------------------------------------------
data("Machines", package = "MEMSS")


## ---- include=FALSE------------------------------------------------------
library("tidyverse")


## ---- fig.height=4, dev='svg', echo=FALSE--------------------------------
ggplot(Machines, aes(x = Machine, y = score)) +
  geom_point() + 
  facet_wrap(~ Worker) + 
  theme_light()


## ------------------------------------------------------------------------
mach1 <- lm(score ~ Machine, Machines)
car::Anova(mach1, type = 3)


## ------------------------------------------------------------------------
data("Machines", package = "MEMSS")


## ---- include=FALSE------------------------------------------------------
library("tidyverse")


## ------------------------------------------------------------------------
mach1 <- lm(score ~ Machine, Machines)
car::Anova(mach1, type = 3)


## ---- results="hide", warning=FALSE, message=FALSE-----------------------
(mach2 <- mixed(score~Machine+
                (Machine|Worker), Machines))


## ---- echo=FALSE, warning=FALSE------------------------------------------
mach2 


## ------------------------------------------------------------------------
pairs(emmeans(mach1, "Machine"),
      adjust = "holm")


## ------------------------------------------------------------------------
emm_options(lmer.df = "Satterthwaite")
## or "Kenward-Roger"
pairs(emmeans(mach2, "Machine"),
      adjust = "holm")


## ---- echo=FALSE, message=FALSE, results='hide'--------------------------
library("sjstats")


## ------------------------------------------------------------------------
m1 <- lmer(if_A_then_B_c ~ 1 + (1|p_id), dat2)
# summary(m1)
# Random effects:
#  Groups   Name        Variance Std.Dev.
#  p_id     (Intercept) 0.00572  0.0757  
#  Residual             0.14607  0.3822  
# Number of obs: 752, groups:  p_id, 94

0.00572 / (0.0057+0.1461)
library("sjstats")
icc(m1)


## ------------------------------------------------------------------------
m1 <- lmer(if_A_then_B_c ~ 1 + (1|p_id), dat2)
# summary(m1)
# Random effects:
#  Groups   Name        Variance Std.Dev.
#  p_id     (Intercept) 0.00572  0.0757  
#  Residual             0.14607  0.3822  
# Number of obs: 752, groups:  p_id, 94

icc(m1)


## ---- warning=FALSE, message=FALSE---------------------------------------
m2 <- lmer(if_A_then_B_c ~ 1 + 
             (rel_cond:B_given_A_c|p_id), dat2)
# summary(m2)
 # Groups   Name                   Variance Std.Dev. Corr       
 # p_id     (Intercept)            0.0398   0.200               
 #          rel_condPO:B_given_A_c 1.0186   1.009    -0.94      
 #          rel_condIR:B_given_A_c 0.3262   0.571    -0.48  0.75
 # Residual                        0.0570   0.239               
icc(m2)
## Caution! ICC for random-slope-intercept models usually 
## not meaningful. See 'Note' in `?icc`.


## ---- fig.width=5, fig.height=5------------------------------------------

dat2$residuals <- 
  residuals(ma_3$full_model)
ggplot(dat2, aes(sample = residuals)) +
  stat_qq() + 
  stat_qq_line() +
  theme_bw() +
  theme(text=element_text(size=18))


## ---- fig.width=5, fig.height=2.5, echo=FALSE----------------------------
dat2 %>% 
  select(if_A_then_B, B_given_A) %>% 
  gather(key, value, if_A_then_B, B_given_A) %>% 
  mutate(key = factor(key, levels = c("if_A_then_B", "B_given_A"))) %>% 
  ggplot(aes(x = value)) +
  geom_histogram(bins = 101) +
  facet_wrap(~key) +
  theme_bw() +
  theme(text=element_text(size=18))


## ---- eval=FALSE---------------------------------------------------------
## data("fhch2010")
## fhch2 <- droplevels(fhch2010[fhch2010$task == "lexdec", ] )
## gm1 <- mixed(correct ~ stimulus + (stimulus||id) + (stimulus||item),
##              fhch2, family = binomial,      # implies: binomial(link = "logit")
##              method = "LRT", expand_re = TRUE) # alt: binomial(link = "probit")
## gm1
## ## Mixed Model Anova Table (Type 3 tests, LRT-method)
## ##
## ## Model: correct ~ stimulus + (stimulus || id) + (stimulus | item)
## ## Data: fhch2
## ## Df full model: 7
## ##     Effect df Chisq p.value
## ## 1 stimulus  1  1.19     .28
## ## ---
## ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '+' 0.1 ' ' 1
## ## Warning messages: [...]
## emmeans(gm1, "stimulus", type = "response")
## ##  stimulus   prob       SE df asymp.LCL asymp.UCL
## ##  word     0.9907 0.002323 NA    0.9849    0.9943
## ##  nonword  0.9857 0.003351 NA    0.9774    0.9909
## ##
## ## Confidence level used: 0.95
## ## Intervals are back-transformed from the logit scale


## ---- fig.width=5, fig.height=4------------------------------------------
plot(m_max, 
     resid(.,scaled=TRUE) ~ B_given_A | rel_cond)


## ---- fig.width=4, fig.height=4------------------------------------------
lattice::qqmath(m_max)


## ---- eval=FALSE---------------------------------------------------------
## plot(m_max, p_id ~ resid(., scaled=TRUE) )
## plot(m_max, resid(., scaled=TRUE) ~ fitted(.) | rel_cond)
## ?plot.merMod


## ---- eval=FALSE, include=FALSE------------------------------------------
## library("afex")
## load("ssk16_dat_tutorial.rda")


## ---- eval=FALSE, include=FALSE------------------------------------------
## 
## m_full <- mixed(if_A_then_B_c ~ B_given_A_c*rel_cond +
##                        (rel_cond*B_given_A_c|p_id) +
##                        (rel_cond*B_given_A_c|i_id),
##                      dat,
##                      control = lmerControl(optCtrl = list(maxfun=1e8)),
##                      method = "S")
## 
## save(m_full, file = "fitted_lmms.rda", compress = "xz")

