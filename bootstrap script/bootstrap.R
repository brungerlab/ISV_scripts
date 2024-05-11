setwd(r4projects::get_project_wd())

data <- readxl::read_xlsx("data/2024_1_28/vATPaseCount.xlsx")

dir.create("data_analysis/2024_1_28")
setwd("data_analysis/2024_1_28")

data <-
  data[, -1]

library(tidyverse)

ko <-
  data.frame(protein_number = unname(unlist(c(data[2, 1:9, drop = TRUE]))),
             number = unname(unlist(c(data[1, 1:9, drop = TRUE])))) %>%
  dplyr::mutate(number = as.numeric(number)) %>%
  dplyr::mutate(protein_number = as.numeric(stringr::str_replace(protein_number, "#", "")))

wt <-
  data.frame(protein_number = unname(unlist(c(data[2, 12:17, drop = TRUE]))),
             number = unname(unlist(c(data[1, 12:17, drop = TRUE])))) %>%
  dplyr::mutate(number = as.numeric(number)) %>%
  dplyr::mutate(protein_number = as.numeric(stringr::str_replace(protein_number, "#", "")))

ko_data <-
  1:nrow(ko) %>%
  purrr::map(function(i) {
    rep(ko$protein_number[i], ko$number[i])
  }) %>%
  unlist()

wt_data <-
  1:nrow(wt) %>%
  purrr::map(function(i) {
    rep(wt$protein_number[i], wt$number[i])
  }) %>%
  unlist()

###chisq.test
ko_data1 <-
  ko_data[ko_data != 0]

wt_data1 <-
  wt_data[wt_data != 0]

data <-
  rbind(c(sum(ko_data1 == 1),
          sum(ko_data1 == 2),
          sum(ko_data1 > 2)),
        c(sum(wt_data1 == 1),
          sum(wt_data1 == 2),
          sum(wt_data1 > 2)))

rownames(data) <- c("ko", "wt")
colnames(data) <- c("1", "2", ">2")

test_result <- chisq.test(data)

# 输出结果
test_result

library(ggpie)
library(ggsci)

number_color <-
  ggsci::pal_npg()(n = 9)

names(number_color) <- as.character(0:8)

ko_pie_with_0 <-
  data.frame(ko_data) %>%
  dplyr::mutate(ko_data = as.character(ko_data)) %>%
  ggpie(
    group_key = "ko_data",
    count_type = "full",
    label_info = "all",
    label_type = "horizon",
    label_split = NULL,
    label_size = 4,
    label_pos = "out"
  ) +
  scale_fill_manual(values = number_color)
ko_pie_with_0
ggsave(ko_pie_with_0,
       filename = "ko_pie_with_0.pdf",
       width = 7,
       height = 7)

wt_pie_with_0 <-
  data.frame(wt_data) %>%
  dplyr::mutate(wt_data = as.character(wt_data)) %>%
  ggpie(
    group_key = "wt_data",
    count_type = "full",
    label_info = "all",
    label_type = "horizon",
    label_split = NULL,
    label_size = 4,
    label_pos = "out"
  ) +
  scale_fill_manual(values = number_color)
wt_pie_with_0
ggsave(wt_pie_with_0,
       filename = "wt_pie_with_0.pdf",
       width = 7,
       height = 7)

ko_pie_without_0 <-
  data.frame(ko_data) %>%
  dplyr::filter(ko_data != 0) %>%
  dplyr::mutate(ko_data = as.character(ko_data)) %>%
  ggpie(
    group_key = "ko_data",
    count_type = "full",
    label_info = "all",
    label_type = "horizon",
    label_split = NULL,
    label_size = 4,
    label_pos = "out"
  ) +
  scale_fill_manual(values = number_color)

ggsave(
  ko_pie_without_0,
  filename = "ko_pie_without_0.pdf",
  width = 7,
  height = 7
)

wt_pie_without_0 <-
  data.frame(wt_data) %>%
  dplyr::filter(wt_data != 0) %>%
  dplyr::mutate(wt_data = as.character(wt_data)) %>%
  ggpie(
    group_key = "wt_data",
    count_type = "full",
    label_info = "all",
    label_type = "horizon",
    label_split = NULL,
    label_size = 4,
    label_pos = "out"
  ) +
  scale_fill_manual(values = number_color)
wt_pie_without_0
ggsave(
  wt_pie_without_0,
  filename = "wt_pie_without_0.pdf",
  width = 7,
  height = 7
)

ko_barplot_without_0 <-
  data.frame(ko_data) %>%
  dplyr::filter(ko_data != 0) %>%
  dplyr::mutate(ko_data = as.character(ko_data)) %>%
  dplyr::count(ko_data) %>% 
  dplyr::mutate(percentage = n * 100/ sum(n)) %>%
  ggplot(aes(x = 1, y = percentage)) +
  geom_bar(aes(fill = ko_data), stat = "identity") +
  scale_fill_manual(values = number_color) +
  theme_bw() +
  labs(x = "", y = "Percentage (%)") +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))
ko_barplot_without_0
ggsave(
  ko_barplot_without_0,
  filename = "ko_barplot_without_0.pdf",
  width = 3,
  height = 7
)

wt_barplot_without_0 <-
  data.frame(wt_data) %>%
  dplyr::filter(wt_data != 0) %>%
  dplyr::mutate(wt_data = as.character(wt_data)) %>%
  dplyr::count(wt_data) %>% 
  dplyr::mutate(percentage = n * 100/ sum(n)) %>%
  ggplot(aes(x = 1, y = percentage)) +
  geom_bar(aes(fill = wt_data), stat = "identity") +
  scale_fill_manual(values = number_color) +
  theme_bw() +
  labs(x = "", y = "Percentage (%)") +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))
wt_barplot_without_0
ggsave(
  wt_barplot_without_0,
  filename = "wt_barplot_without_0.pdf",
  width = 3,
  height = 7
)


###sankey plot
library(ggalluvial)
###sankey plot for wt_data and ko_data, left is wt_data, right is ko_data
temp_data <-
  rbind(
    data.frame(ko_data) %>%
      dplyr::filter(ko_data != 0) %>%
      dplyr::mutate(ko_data = as.character(ko_data)) %>%
      dplyr::count(ko_data) %>% 
      dplyr::mutate(percentage = n * 100/ sum(n)) %>% 
      dplyr::mutate(class = "ko") %>%
      dplyr::rename(number = ko_data),
    data.frame(wt_data) %>%
      dplyr::filter(wt_data != 0) %>%
      dplyr::mutate(wt_data = as.character(wt_data)) %>%
      dplyr::count(wt_data) %>% 
      dplyr::mutate(percentage = n * 100/ sum(n)) %>% 
      dplyr::mutate(class = "wt") %>%
      dplyr::rename(number = wt_data)    
  ) %>% 
  dplyr::mutate(class = factor(class, levels = c("wt", "ko"))) %>% 
  dplyr::mutate(number = as.character(number)) %>% 
  dplyr::mutate(number = factor(number, levels = rev(sort(unique(number)))))

plot <- 
ggplot(temp_data, aes(
  x = class,
  y = percentage,
  stratum = number,
  alluvium = number,
  fill = number
)) +
  ggalluvial::geom_alluvium(width = 0.3, alpha = 0.5) +
  ggalluvial::geom_stratum(width = 0.5) +
  scale_fill_manual(values = number_color) +
  theme_bw() +
  scale_x_discrete(expand = expansion(mult = c(0, 0))) +
  scale_y_continuous(expand = expansion(mult = c(0, 0))) +
  labs(x = "", y = "Percentage (%)")
plot
ggsave(plot, filename = "sankey_plot.pdf", width = 7, height = 7)

###bootstrap
# wt_bootstrap <-
#   1:10000 %>%
# purrr::map(function(i){
#   cat(i, " ")
# data.frame(value = wt_data[sample(1:length(wt_data), length(wt_data), replace = TRUE)]) %>%
#     dplyr::count(value) %>%
#     dplyr::mutate(ratio = n * 100/sum(n)) %>%
#     dplyr::mutate(type = "wt")
# }
# ) %>%
#   do.call(rbind, .) %>%
#   as.data.frame()
#
# save(wt_bootstrap, file = "wt_bootstrap.rda")
load("wt_bootstrap.rda")

# ko_bootstrap <-
#   1:10000 %>%
#   purrr::map(function(i){
#     cat(i, " ")
#     data.frame(value = ko_data[sample(1:length(ko_data), length(ko_data), replace = TRUE)]) %>%
#       dplyr::count(value) %>%
#       dplyr::mutate(ratio = n * 100/sum(n)) %>%
#       dplyr::mutate(type = "ko")
#   }
#   ) %>%
#   do.call(rbind, .) %>%
#   as.data.frame()
#
# save(ko_bootstrap, file = "ko_bootstrap.rda")
load("wt_bootstrap.rda")

# ##bootstrap
# wt_bootstrap_withou_0 <-
#   1:10000 %>%
# purrr::map(function(i){
#   cat(i, " ")
#   wt_data1 <-
#     wt_data[wt_data != 0]
# data.frame(value = wt_data1[sample(1:length(wt_data1), length(wt_data1), replace = TRUE)]) %>%
#     dplyr::count(value) %>%
#     dplyr::mutate(ratio = n * 100/sum(n)) %>%
#     dplyr::mutate(type = "wt")
# }
# ) %>%
#   do.call(rbind, .) %>%
#   as.data.frame()
# 
# save(wt_bootstrap_withou_0, file = "wt_bootstrap_withou_0.rda")
load("wt_bootstrap_withou_0.rda")

# ko_bootstrap_withou_0 <-
#   1:10000 %>%
#   purrr::map(function(i){
#     cat(i, " ")
#     ko_data1 <-
#         ko_data[ko_data != 0]
#     data.frame(value = ko_data1[sample(1:length(ko_data1), length(ko_data1), replace = TRUE)]) %>%
#       dplyr::count(value) %>%
#       dplyr::mutate(ratio = n * 100/sum(n)) %>%
#       dplyr::mutate(type = "ko")
#   }
#   ) %>%
#   do.call(rbind, .) %>%
#   as.data.frame()
# 
# save(ko_bootstrap_withou_0, file = "ko_bootstrap_withou_0.rda")
load("ko_bootstrap_withou_0.rda")

temp_data1 <-
unique(wt_bootstrap_withou_0$value) %>% 
  purrr::map(function(x){
    value <-
    wt_bootstrap_withou_0 %>% 
      dplyr::filter(value == x) %>% 
      pull(ratio)
    data.frame(value = x, 
               type = wt_bootstrap_withou_0$type[1],
               mean = mean(value), sd = sd(value), se = sd(value)/sqrt(length(value)))
  }) %>% 
  do.call(rbind, .) %>% 
  as.data.frame()

temp_data2 <-
  unique(ko_bootstrap_withou_0$value) %>% 
  purrr::map(function(x){
    value <-
      ko_bootstrap_withou_0 %>% 
      dplyr::filter(value == x) %>% 
      pull(ratio)
    data.frame(value = x, 
               type = ko_bootstrap_withou_0$type[1],
               mean = mean(value), sd = sd(value), se = sd(value)/sqrt(length(value)))
  }) %>% 
  do.call(rbind, .) %>% 
  as.data.frame()

temp_data <-
  rbind(temp_data1,
        temp_data2)

library(ggsignif)

wt_ko_color <- c("wt" = ggsci::pal_jco()(2)[1],
                 "ko" = ggsci::pal_jco()(2)[2])

library(ggforce)

plot <- 
temp_data %>% 
  dplyr::mutate(type = factor(type, levels = c("wt", "ko"))) %>% 
  ggplot(aes(value, mean, fill = type)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(aes(ymin = mean - sd, 
                    ymax = mean + sd), width = 0.2, position = position_dodge(0.9)) +
  theme_bw() +
  labs(x = "vATPase#", y = "Percentage (%)") +
  scale_fill_manual(values = wt_ko_color) +
  ggforce::facet_zoom(x = value > 3.9 & value < 9,
                      y = mean < 10, zoom.size = 0.2, horizontal = FALSE)

plot

ggsave(plot, filename = "barplot2.pdf", width = 7, height = 7)

library(ggstatsplot)

# for (i in unique(ko_bootstrap_withou_0$value)) {
for (i in c(6:8)) {
  cat(i, " ")
  wt_ratio <-
    wt_bootstrap_withou_0 %>%
    dplyr::filter(value == i) %>%
    select(ratio, type)
  
  ko_ratio <-
    ko_bootstrap_withou_0 %>%
    dplyr::filter(value == i) %>%
    select(ratio, type)
  
  if(nrow(wt_ratio) == 0) {
    wt_ratio <-
      data.frame(ratio = rep(NA, nrow(ko_ratio)), type = "wt")
  }
  
  temp_data <-
    rbind(wt_ratio,
          ko_ratio)
  
  # temp_data <-
  # temp_data %>%
  #   dplyr::mutate(type = case_when(type == "wt" ~ "1wt",
  #                                  type == "ko" ~ "2ko"))
  
  library(gghalves)
  library(ggsignif)
  
  plot1 <-
  temp_data %>%
    # dplyr::mutate(type = factor(type, levels = c("wt", "ko"))) %>%
    ggplot(aes(x = type, y = ratio)) +
    # gghalves::geom_half_dotplot(side = "r", binwidth = 0.02) +
    gghalves::geom_half_violin(side = "r") +
    gghalves::geom_half_boxplot(side = "l", outlier.shape = NA) +
    gghalves::geom_half_point_panel(side = "r", size = 0.2) +
    theme_bw() +
    labs(x = "", y = "Percentage (%)", title = paste0("Number: ", i)) +
    ggsignif::geom_signif(comparisons = list(c("wt", "ko")), map_signif_level = TRUE)
  
  plot2 <-
    plot1 +
    gghalves::geom_half_point_panel(side = "r", size = 0.2)
  
  ggsave(
    plot1,
    filename = paste0("number_", i, "_1.pdf"),
    width = 7,
    height = 7
  )
  
  ggsave(
    plot2,
    filename = paste0("number_", i, "_2.pdf"),
    width = 7,
    height = 7
  )
}




###bootstrap without 0
wt_bootstrap1 <-
  1:10000 %>%
  purrr::map(function(i) {
    cat(i, " ")
    wt_data1 <-
      wt_data[wt_data != 0]
    data.frame(value = wt_data1[sample(1:length(wt_data1), length(wt_data1), replace = TRUE)]) %>%
      dplyr::count(value) %>%
      dplyr::mutate(ratio = n * 100 / sum(n)) %>%
      dplyr::mutate(type = "wt")
  }) %>%
  do.call(rbind, .) %>%
  as.data.frame()

ko_bootstrap1 <-
  1:10000 %>%
  purrr::map(function(i) {
    cat(i, " ")
    ko_data1 <-
      ko_data[ko_data != 0]
    data.frame(value = ko_data1[sample(1:length(ko_data1), length(ko_data1), replace = TRUE)]) %>%
      dplyr::count(value) %>%
      dplyr::mutate(ratio = n * 100 / sum(n)) %>%
      dplyr::mutate(type = "ko")
  }) %>%
  do.call(rbind, .) %>%
  as.data.frame()

library(ggstatsplot)

for (i in unique(wt_bootstrap1$value)) {
  cat(i, " ")
  wt_ratio <-
    wt_bootstrap1 %>%
    dplyr::filter(value == i) %>%
    select(ratio, type)
  
  ko_ratio <-
    ko_bootstrap1 %>%
    dplyr::filter(value == i) %>%
    select(ratio, type)
  
  
  temp_data <-
    rbind(wt_ratio,
          ko_ratio)
  
  temp_data %>%
    dplyr::mutate(type = factor(type, levels = c("wt", "ko"))) %>%
    ggplot(aes(x = type, y = ratio)) +
    geom_boxplot() +
    theme_bw() +
    labs(x = "", y = "Percentage (%)")
  
  plot <-
    temp_data %>%
    dplyr::mutate(type = factor(type, levels = c("wt", "ko"))) %>%
    ggbetweenstats(type,
                   ratio,
                   p.adjust.method = "bh",
                   title = paste0("Number: ", i)) +
    labs(x = "", y = "Percentage (%)") +
    theme_bw()
  
  ggsave(
    plot,
    filename = paste0("Downloads/number_", i, ".pdf"),
    width = 7,
    height = 7
  )
  
}



##1 and 2
wt_ratio <-
  wt_bootstrap1 %>%
  dplyr::filter(value <= 2) %>%
  select(value, ratio, type)

wt_ratio <-
  data.frame(ratio = wt_ratio$ratio[seq(1, 20000, by = 2)] +
               wt_ratio$ratio[seq(2, 20000, by = 2)],
             type = "wt")

ko_ratio <-
  ko_bootstrap1 %>%
  dplyr::filter(value > 2) %>%
  select(value, ratio, type)

ko_ratio <-
  data.frame(ratio = ko_ratio$ratio[seq(1, 20000, by = 2)] +
               ko_ratio$ratio[seq(2, 20000, by = 2)],
             type = "ko")

temp_data <-
  rbind(wt_ratio,
        ko_ratio)

plot <-
  temp_data %>%
  dplyr::mutate(type = factor(type, levels = c("wt", "ko"))) %>%
  ggbetweenstats(type,
                 ratio,
                 p.adjust.method = "bh",
                 title = paste0("Number: ", i)) +
  labs(x = "", y = "Percentage (%)") +
  theme_bw()

ggsave(
  plot,
  filename = paste0("Downloads/number_1-2", i, ".pdf"),
  width = 7,
  height = 7
)




##>2
wt_ratio <-
  wt_bootstrap1 %>%
  dplyr::filter(value <= 2) %>%
  select(value, ratio, type)

wt_ratio <-
  data.frame(ratio = wt_ratio$ratio[seq(1, 20000, by = 2)] +
               wt_ratio$ratio[seq(2, 20000, by = 2)],
             type = "wt")

ko_ratio <-
  ko_bootstrap1 %>%
  dplyr::filter(value > 2) %>%
  select(value, ratio, type)

ko_ratio <-
  data.frame(ratio = ko_ratio$ratio[seq(1, 20000, by = 2)] +
               ko_ratio$ratio[seq(2, 20000, by = 2)],
             type = "ko")

temp_data <-
  rbind(wt_ratio,
        ko_ratio)

plot <-
  temp_data %>%
  dplyr::mutate(type = factor(type, levels = c("wt", "ko"))) %>%
  ggbetweenstats(type,
                 ratio,
                 p.adjust.method = "bh",
                 title = paste0("Number: ", i)) +
  labs(x = "", y = "Percentage (%)") +
  theme_bw()

ggsave(
  plot,
  filename = paste0("Downloads/number_1-2", i, ".pdf"),
  width = 7,
  height = 7
)
