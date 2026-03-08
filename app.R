remotes::install_github("sebastien-plutniak/spatialCatalogueViewer", upgrade = "never")

# log.df <- read.csv( "../openarcheocsean-log.csv")
# write.csv(rbind(log.df, "date" = format(Sys.Date())), "../openarcheocsean-log.csv", row.names = F)

try(lingocsean.df <- read.csv("data/open-lingocsean-data_formated.csv", check.names=FALSE), silent=TRUE)

if( ! exists("lingocsean.df")){
  # data preparation  ----
  lingocsean.df <- read.csv("data/open-lingocsean-data.csv")
  
  # remove lines with no coordinates: ----
  idx <- apply(lingocsean.df[, c("lon", "lat",	"bbox.lon1",	"bbox.lat1", "bbox.lon2",	"bbox.lat2")], 1,
               function(x) sum(is.na(x)))
  lingocsean.df <- lingocsean.df[idx < 6, ]
  
  # resource name and link to data ----
  lingocsean.df$resource.name.html <- lingocsean.df$resource.name
  idx <- which(lingocsean.df$data.link != "")
  lingocsean.df[idx,]$resource.name.html <- paste0("<a href=", lingocsean.df[idx,]$data.link,
                        " title='", lingocsean.df[idx,]$resource.name, "' target=_blank>", lingocsean.df[idx,]$resource.name, "</a> ")
  
  # languages ----
  
  # use Glottolog link if available, otherwise use OLAC:
  lingocsean.df$lang1.link <- lingocsean.df$lang1.glottolog
  idx <- which(lingocsean.df$lang1.link == "")
  lingocsean.df[idx, ]$lang1.link  <- lingocsean.df[idx, ]$lang1.olac
  
  lingocsean.df$lang1.html <- paste0(lingocsean.df$lang1, "  <nobr>[<a href=", lingocsean.df$lang1.link, " title='Glottolog reference' target=_blank><img height=12px src=logo-glottolog.png></a>]</nobr>")
  
  lingocsean.df$lang2.html <- ""
  idx <- which(lingocsean.df$lang2 != "")
  lingocsean.df[idx,]$lang2.html <- paste0(lingocsean.df[idx,]$lang2, " <nobr>[<a href=", lingocsean.df[idx,]$lang2.glottolog, " title='Glottolog reference'  target=_blank><img height=12px src=logo-glottolog.png></a>]</nobr>")
  
  lingocsean.df$lang3.html <- ""
  idx <- which(lingocsean.df$lang3 != "")
  lingocsean.df[idx,]$lang3.html <- paste0(lingocsean.df[idx,]$lang3, " <nobr>[<a href=", lingocsean.df[idx,]$lang3.glottolog, "  title='Glottolog reference'  target=_blank><img height=12px src=logo-glottolog.png></a>]</nobr>")
  
  
  
  
  # places  ----
  idx <- which(lingocsean.df$place != "")
  lingocsean.df[idx,]$place <- paste0("<a href=", lingocsean.df[idx,]$place.geonames, " target=_blank>", lingocsean.df[idx,]$place, "</a> ")
  
  
  # licences  -----
  # idx <- which(lingocsean.df$licence == "Paradisec")
  # lingocsean.df[idx, ]$licence <- "<a href=https://www.paradisec.org.au/deposit/access-conditions/ target=_blank>Paradisec</a>"
  
  
  # popup ----
  lingocsean.df$popup <- paste0("<b>", lingocsean.df$resource.name.html, "</b><br>", 
                                # lingocsean.df$description, ".<br>",
                                "<b>Languages:</b> ", lingocsean.df$lang1, ", ", lingocsean.df$lang2, ", ", lingocsean.df$lang3, "<br>",
                                 "<b>Licence:</b> ", lingocsean.df$licence, "<br>",
                                 "<b>Access:</b> ", lingocsean.df$access)
  
  
  # export -----
  lingocsean.df <- lingocsean.df[ , c("lon", "lat", "bbox.lon1", "bbox.lat1", "bbox.lon2", "bbox.lat2", "resource.name",  "resource.name.html", "lang1.html", "lang2.html", "lang3.html", "country", "place", "contents.type", "words.count",  "collection.date.start", "collection.date.end", "access", "licence", "popup") ]
  
  colnames(lingocsean.df) <- c("lon", "lat", "bbox.lon1", "bbox.lat1", "bbox.lon2", "bbox.lat2", "resource.name", "Data name", "Language 1", "Language 2", "Language 3", "Country", "Place", "Contents", "Words count", "Collection start", "Collection end",  "Access", "Licence", "popup")
  
  write.csv(lingocsean.df, "data/open-lingocsean-data_formated.csv", row.names = FALSE)
}

lingocsean.df$Licence <- factor(lingocsean.df$Licence)
lingocsean.df$Country <- factor(lingocsean.df$Country)
lingocsean.df$Access <- factor(lingocsean.df$Access)
lingocsean.df$Contents <- factor(lingocsean.df$Contents)
lingocsean.df$`Collection start` <- as.numeric(lingocsean.df$`Collection start`)
lingocsean.df$`Collection end` <- as.numeric(lingocsean.df$`Collection end`)

# css ----
css <- '
.tooltip {
  pointer-events: none;
}
.tooltip > .tooltip-inner {
  pointer-events: none;
  background-color: #FFFFFF;
  color: #000000;
  border: 1px solid black;
  padding: 5px;
  font-size: px;
  text-transform: none;
  font-weight: normal;
  text-align: left;
  max-width: 300px;
  content: <b>aa</b>;
}
.tooltip > .arrow::before {
  border-right-color: #73AD21;
}
'

js <- "
$(function () {
  $('[data-toggle=tooltip]').tooltip()
})
"

# texts ----

text.title <- "<h1>
             <a href=https://www.ocsean.eu/  target=_blank><img height='40px' src=logo-ocsean.jpg></a> 
             <i><a href=https://github.com/sebastien-plutniak/open-lingocsean target=_blank>Open-lingOcsean</a></i>
              </h1>"

## left----

text.left <- "<div style=width:90%;, align=left>
             <h2>Presentation</h2>
    <p>
      <i>Open-lingOcsean</i> is a catalogue of language data collected  in the course of the <a href=https://www.ocsean.eu  target=_blank><i>OCSEAN. Oceanic and Southeast Asian Navigators</i></a> project.
    </p>
    <p>
    The primary goal of OCSEAN’s linguistic work was to develop a dense and uniform language resource to support both phylogenetic and contact-based analyses in Island Southeast Asia and Oceania, particularly when combined with high‑resolution genetic data. To achieve this, the project created a comprehensive wordlist of 1,128 concepts, including many culturally significant terms specific to the region. This list surpasses standard linguistic inventories and enables deeper cross‑disciplinary insights. It covers semantic domains expected to contain both historically stable, potentially inherited vocabulary (e.g., natural and physical environments) and domains more susceptible to borrowing, particularly those related to social organization.
    </p>
    <i>Open-lingOcsean</i>'s code source and data are available on <a href=https://github.com/sebastien-plutniak/open-lingocsean target=_blank><i>github</i></a> and archived on <a href=https://doi.org/10.5281/zenodo.TODO target=_blank><i>Zenodo</i></a>.
    </p>
      </div>"

## bottom ----
text.bottom <- "Click on the [<img height=12px src=logo-glottolog.png>] symbol to access <i>Glottolog</i> documentation."

## credits ----
credits.tab <-  "<div  style=width:50%;, align=left> 
                <h2>Credits </h2>
                <p>
                  OCSEAN's linguistic work was carried out by local researchers, cultural workers, and multilingual community members, who served both as data collectors and as informants. Foundational training in language documentation was provided by OCSEAN EU members during the <a href=https://www.ocsean.eu/post/linguistic-workshop-held-at-uppsala-university target=_blank>Uppsala Summer School</a> in 2022 and through <a href=https://www.ocsean.eu/post/ocsean-linguistic-workshops-in-indonesia-and-the-philippines-april-june-2023 target=_blank>workshops</a> held in Indonesia and the Philippines in 2023. These activities strengthened community ownership and built local capacity. In many cases, the learning process itself contributed to data generation. Data collection occurred during the 2022-2023 training events and through fieldwork in the Philippines and Indonesia in 2023 and 2024, resulting in a sustainable network of local expertise and collaboration extending beyond the OCSEAN funding cycle.</p>
                  <p>
Beyond scientific research, the OCSEAN dataset functions as a living community archive that supports language preservation and revitalization. When communities expressed interest, additional materials were documented, including stories, ethnobotanical knowledge, and recordings of rituals. These efforts also led to the development of educational resources such as storybooks, picture dictionaries, and orthography guides, helping cultivate respect for local languages and cultural heritage. Many of these secondary materials will also assist future linguistic research.
                  </p>
                  <p>
                  <ul>
                     <li> The <i>Open-lingOcsean</i> dataset is a collective product by OCSEAN's participants.</li>
                     <li> The <i>Open-lingOcsean</i> application is maintained by Sébastien Plutniak (CNRS, France) and Monika Karmin (Estonian Biocenter, University of Tartu, Estonia).</li>
                  </ul>
                </p>
                   <h2>Citation</h2>
                    <p>To cite <i>Open-lingOcsean</i>, use:
                      <ul><li>
                      <b>Plutniak S., M. Karmin. 2026</b>. 'Open-lingOcsean: an interactive catalogue of language data from the Pacific and Southeast Asia regions (v0.1)'. <i>Zenodo</i>, doi: <a href=https://doi.org/10.5281/zenodo.TODO target=_blank>10.5281/zenodo.TODO</a>.
                      </li></ul>
                    </p>
                  <h2>Terms of Use</h2>
                  <p>
                    The use of the  <i>Open-lingOcsean</i> catalogue denotes agreement with the following terms:
                    <ul>
                        <li> <i>Open-lingOcsean</i> is provided free of charge and is distributed under open licences:
                          <ul>
                            <li> All metadata and data are made available under the terms of the <a href=https://creativecommons.org/licenses/by/4.0/ target_blank>CC-BY-4.0</a> license.</li>
                            <li>The software code draws on the <a href=https://CRAN.R-project.org/package=spatialCatalogueViewer target=_blank><i>spatialCatalogueViewer</i></a> R package, which is distibuted under a <a href=https://www.r-project.org/Licenses/GPL-3 target_blank>GPL-3</a> license.</li>
                          </ul>
                        </li>
                        <li> All content is provided “as is” and the user shall hold the content providers free and harmless in connection with its use of such content.</li>
                        <li> These terms of use are subject to change at any time and without notice, other than through posting the updated Terms of Use on this page.</li>
                    </ul>
                    If you have any questions or comments with respect to <i>Open-lingOcsean</i>, or if you are unsure whether your intended use is in line with these Terms of Use, or if you seek permission for a use that does not fall within these Terms of Use, please contact us.
                  </p>
                  <h2>FAIR and CARE</h2>
                  <p>
                   Forthcoming
                  </p>
                  <h2>Support</h2>
                   <div style='text-align:left'>
                      <b> <i>Open-lingOcsean</i></b> is
                      <br><br>
                      <table> 
                        <tr>
                          <td> supported by: &nbsp;  &nbsp; &nbsp; <br> <br> <a href=https://www.ocsean.eu  target=_blank><img height='50px' src=logo-ocsean.jpg></a></td>
                          <td> developped at: &nbsp; &nbsp; &nbsp;  <br> <br> <a href=https://www.cnrs.fr target=_blank><img height='50px' src=logo-cnrs.png></a></td>
                          <td> hosted by:  <br> <br> <a href=https://www.huma-num.fr target=_blank><img height='50px' src=logo-humanum.jpg></a></td>
                          </tr>
                      </table> 
                      <br><br><br>
                      <p>    
                         This project has received funding from the European Union’s Horizon 2020 research and innovation programme under the Marie Skłodowska-Curie grant agreement No <a href=https://cordis.europa.eu/project/id/873207 target_blank>873207</a>.
                      </p>
                  </div></div>"


# exec spatialCatalogueViewer----
spatialCatalogueViewer::spatialCatalogueViewer(data = lingocsean.df,   
                                               text.title = text.title,
                                               text.left = text.left, 
                                               text.bottom = text.bottom,
                                               map.provider = "Esri.WorldPhysical",
                                               map.set.lon = 122, map.set.lat = 0,
                                               map.legend.variable = "Access",
                                               map.legend.labels = c("open",  "closed",  "restricted"),
                                               map.legend.colors = c("darkgreen", "purple", "yellow"),
                                               map.height = 600,
                                               map.area.fill.color = "white",
                                               map.area.fill.opacity = .1,
                                               map.show.areas = T,
                                               map.min.zoom = 4,
                                               table.hide.columns = c("resource.name"),
                                               table.filter = "top", 
                                               table.pageLength = 15,
                                               data.download.button = TRUE,
                                               tabs.contents = list("Credits" = credits.tab),
                                               css = css, js = js,
                                               theme = "cerulean") 


