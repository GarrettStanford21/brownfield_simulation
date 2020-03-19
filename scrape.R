library(pacman)
p_load(tidyverse, here, rvest, lubridate, janitor, magrittr)

main_list<-read_csv(here::here('data', 'raw', 'epa_1.csv')) #load data
main_list<-janitor::clean_names(main_list) #clean names

main_list%<>% filter(brownfields_link_csv != 'NA') #remove non-BF

head(main_list)
html <- read_html('https://obipublic.epa.gov/analytics/saw.dll?PortalPages')
html <- read_html('')
temp<-html%>%
  html_nodes('#sectiontable_d\:dashboard\~p\:i3hckm4kfle2bmd8\~s\:f26p959illu8saam')

html_text(html)
#DashboardPageContentDiv > table:nth-child(6) > tbody > tr > td.PageColumnCell > div > table > tbody > tr:nth-child(3)

#d\:dashboard\~p\:i3hckm4kfle2bmd8\~r\:4h5nfgn0npr8ua3t\~v\:compoundView\!1ViewContainer > table > tbody > tr:nth-child(2) > td > table



https://obipublic.epa.gov/analytics/saw.dll?PortalPages&Action=Navigate&PortalPath=/shared/CIMC/_portal/CIMC&Page=Profile+Page&col1=ACRES_GRANT_EXPORT.PROPERTY_ID&val1=%22119842%22

https://obipublic.epa.gov/analytics/saw.dll?PortalPages&Action=Navigate&PortalPath=/shared/CIMC/_portal/CIMC&Page=Profile+Page&col1=ACRES_GRANT_EXPORT.PROPERTY_ID&val1=%22239867%22

https://obipublic.epa.gov/analytics/saw.dll?PortalPages&Action=Navigate&PortalPath=/shared/CIMC/_portal/CIMC&Page=Profile+Page&col1=ACRES_GRANT_EXPORT.PROPERTY_ID&val1=%22108844%22
108844

https://obipublic.epa.gov/analytics/saw.dll?PortalPages

head(main_list)
janitor::clean_names(main_list)

class(main_list)
main_list%>%filter(brownfields_link_csv != 'NA')%>%nrow()
