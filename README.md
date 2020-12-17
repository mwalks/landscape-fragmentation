# landscape-fragmentation
WIP research with [the Human Complexity Lab](https://u.osu.edu/hclab/projects/) at The Ohio State University

## Fragmentation Analysis of Swidden Mosaics in Belize

THEORETICAL MOTIVATION

The potential merits – and risks – of the practice of swidden agriculture, where farmers cultivate subsistence crops such as maize in patches of forests cleared by a process commonly known as “slash and burn,” have been widely debated across disciplines. Often, these discussions are focused on ascertaining whether swidden is inherently destructive of tropical forest environments (Malthus 1826; Boserup 1965), or whether it can exhibit sustainability. Two predominant, opposing theories emerged as potential explanations for the complex functions of swidden agriculture: the first argues that swidden is strictly limited by ecological carrying capacity, or the maximum sustainable population size given the availability of resources, and therefore subjects natural environments to overexploitation and deforestation (Food and Agriculture Organization 1985); the second approach, contrary to ‘Western scientific’ management practices, conceives of ‘coupled human and natural systems’ in which human cultures develop detailed knowledge of their local environments and the processes which best conserve and protect this ecosystem – a collective understanding also known as Traditional Ecological Knowledge, or TEK. However, despite the significant corpora of research, which span questions about the integration of swidden in ecology, culture, society, and religion (Conklin 1954; Geertz 1963), how swidden can be practiced sustainably and augment forest resilience (Balée 2013), or even the role of swidden systems in a globalized, technological world (Weinstock 2015), the relationships between specific social and spatial dynamics and ecological features such as carrying capacities and stock effects remain unclear. 
Despite the negative connotation of the phrase “slash and burn,” swidden agriculture is how many indigenous communities across the world have been sustainably producing food for thousands of years. This repeated, counterintuitive success of swidden has been the subject of ongoing research led by Dr. Sean Downey in The Ohio State University’s Human Complexity Lab (HCL), which focuses on the Q’eqchi’ Maya of southern Belize.
There are a number of complex cultural and historical contexts which are needed to analyze the swidden practices of Q’eqchi’ Maya communities. Importantly, Q’eqchi’ social institutions do not actively protect common forest resources (Downey 2009). The resources are instead collectively managed through reciprocal exchanges of labor. This is a consequence of the colonial period when access to government land for swidden production – both subsistence and market-oriented – was largely unregulated, making land a common property resource available to Q’eqchi’ farmers (Downey 2015). In most villages, labor exchanges – which occur when one farmer asks a group of men to help with a difficult task such as planting or clearing the forest – have become the key social process involved with swidden agriculture (Wilk 1997). After each workgroup, a farmer is expected to close his debt to each man who helped him by reciprocating a day of labor.
The guiding research question here is: how do indigenous social norms like those surrounding this practice of common resource management help regulate the use of a natural resource such as the forest, making sure it remains sustainable (at a ‘group optimum’) rather than using it at its maximum rate (‘Nash equilibrium’; Nash 1950)? This project considers one facet of this larger coupled system, landscape fragmentation, extracting spatial analysis from a classified map of the land around Crique Sarco and Graham Creek.
Ultimately, findings from this research could illuminate the complex array of factors which promote effective management of natural resources at the local level. A cohesive understanding of these processes could lay the foundation for healthier, more efficiently managed public lands at a significant cost savings. Furthermore, knowledge about patterns of fragmentation and diversity within forests, especially those subject to controlled burns, could assist in predicting and preventing catastrophic wildfires.

RESEARCH DESIGN

The long-term goal of this project is to link social and cultural norms with tropical forest ecology. One lens for exploring this complex relationship is that of forest resilience, or how well the landscape ecology can resist and recover from disturbances at different scales. Although we lack general analytical tools to evaluate variation in resilience, particularly – sometimes by design – in social portions of coupled systems, we can still benefit from analyzing real systems by applying a more quantitative approach. 
In addition to behavioral economics experiments like the Milpa Game, household surveys and farmer land use interviews, the team at HCL pieced together high-resolution, multi-spectral drone data to help explore how communities affect the land around them. The photos, once stitched together into geo-referenced, three-dimensional photo-mosaics and verified by farm plots surveys, can be classified and analyzed to understand how these environments provide for the local communities, how they are affected by human activity, and how forests persist over time.
There are two main components to the landscape-level spatial analysis: fragmentation and biodiversity. The first uses a classified map and the [landscapemetrics package](https://r-spatialecology.github.io/landscapemetrics/) in R to calculate dozens of spatial metrics such as the Shannon diversity index, which quantifies the uncertainty in predicting species abundance:

where p_i is the proportion of individuals belonging to the ith species. The ‘species’ in this case are the various land-classes of our map: for example, a patch labeled as ‘0-4 years old.’ Spatial statistics can also be measured at the class-level, which considers the relationships within individual patch clusters instead of across all patches.

One of the early iterations of a classification map resulted in a map that could be visualized as:
 
Fig. 1: An early classification map of Crique Sarco and Graham Creek regions.

Fig. 2: Calculated SHDI values across Graham Creek region 
where each shade in Fig. 1 corresponds to a different ‘class,’ or age group, and the right plot shows variation over Graham Creek in terms of the Shannon’s diversity index. Other metrics, such as Connectedness Index, can provide information about the structure of the landscape patterns, such as how isolated groups are.
The second analysis focuses on measuring species biodiversity through unsupervised learning. Using only the spectral signatures of the landscape as detected by the drone’s MicaSense RedEdge-MX LiDAR sensor and the biodivMapR package, land-classes can be identified and grouped organically to approximate alpha and beta diversity. The sensor data included 5 spectral bands: Blue, Green, Red, Red Edge, and NIR. These unsupervised results can then be used to cross-reference the first analysis and uncover new information about how farming activity has impacted local biodiversity.
Producing the final statistics and plots was both computationally expensive and time-consuming, sometimes taking upwards of 20 or more hours to complete on the full raster. To combat this, small subsets of the full map were used until the code was working as expected. Parallelizing the process of calculating the spatial statistics in R also helped significantly, reducing overall computation time to under 1 hour. The Ohio Supercomputer Center was instrumental in making this a possibility, as the data, once split into smaller cells, could be distributed across many cores without significant loss of information when re-combined. Successfully implementing and iterating upon this workflow was a technical challenge, but one that has dramatically improved the time it takes to analyze future data.

  
Fig. 2: Plots of Patch Cohesion Index distribution across various sampling cell sizes.

To get the appropriate ‘cell’ size to grid the classification map for distributed computing, many iterations over the tuning parameter (brackets) can be plotted for each metric until the preferred inflection point is found. Frequently, a cell half-length of 250 map units was determined to be the ideal parameter value.
Another important consideration was edge data; that is, what to do with cells that are potentially 30% landscape, 70% empty.

 
Fig. 3: Class-level Density of Aggregation Index across cell sizes and data thresholds.
To remedy this, the relative difference in densities can be visualized before and after thresholding the data by how complete each cell is. This was tested over many cell sizes. Eventually, a heuristic of >70% seemed significant enough to exclude extreme outliers but not so extreme that the edges of the map were unaccounted for.


RESULTS AND DISCUSSION

Current results neither fully support or reject the models in our hypothesis and represent a work in progress. The fragmentation analysis is farthest along, but the critical interpretation of each plot’s ecological meaning remains incomplete until a final iteration of the classification process is accepted.

 
Fig. 4: Preliminary comparison between area mean, edge density, and patch density across classes at Crique Sarco (red) and Graham Creek (blue).

The plot above is one example of pairwise analysis that may be used in the future for inferences about groups of spatial metrics, allowing not only comparison across village, but across land-class and relative metric frequencies as well. In tandem with Pearson’s correlation heatmaps, this can reveal important spatial relationships and interactions previously undetectable. This plot can also help anomaly detection: for example, we might be suspicious that class 13 makes up the vast majority of area mean measurements within Crique Sarco, and class 1 composing the majority in Graham Creek; this could be a misclassification error or a consequence of the metric itself.
  
Fig. 5: Left: Landscape densities of patch area metric colored by region; Right: Mean euclidean nearest neighbor distance by land-class colored by region.

Most plots generated for the final analysis will look something like Fig. 5, which shows examples of both landscape-level and class-level metric differences across regions, now including the Primary Forest, a large region of old (50+ years) trees that surrounds both villages and serves almost as a ‘control’ group in comparisons.

   
Fig. 6: Left: Complete data workflow (Féret 2019); Right: Early visualization of species PCA.

With the focus so far being that of finishing the fragmentation analysis, the biodiversity analysis is still early in the early stages of development. However, there are promising signs that soon a full analysis can be pushed through the custom [biodivMapR package](https://github.com/jbferet/biodivMapR) once the data is reformatted and prepared.
REFERENCES
Balée, W. (2013). Cultural forests of the Amazon: a historical ecology of people and their landscapes. University of Alabama Press.
Boserup, E. (1965). The conditions of agricultural growth: the economics of agrarian change under population pressure. G. Allen and Unwin.
Conklin, H. C. (1954). Section of anthropology: an ethnoecological approach to shifting agriculture. Transactions of the New York Academy of Sciences, 17(2 Series II):133–142.
Downey, S. S. 2010. Can properties of labor-exchange networks explain the resilience of swidden agriculture? Ecology and Society 15(4): 15. [online] URL: http://www.ecologyandsociety.org/vol15/iss4/art15/
Downey, S. S. (2015). Q’eqchi’ Maya swidden agriculture, settlement history, and colonial enterprise in modern Belize. Ethnohistory, 57(3):389–414.
Downey, S.S., Gerkey, D. & Scaggs, S.A. The Milpa Game: a Field Experiment Investigating the Social and Ecological Dynamics of Q’eqchi’ Maya Swidden Agriculture. Hum Ecol 48, 423–438 (2020). https://doi.org/10.1007/s10745-020-00169-x
Rappaport, R. A. (1967). Ritual regulation of environmental relations among a New Guinea people. Ethnology, 6(1):17.
Féret, J.-B., de Boissieu, F., 2019. biodivMapR: an R package for α‐ and β‐diversity mapping using remotely‐sensed images. Methods Ecol. Evol. 00:1-7. https://doi.org/10.1111/2041-210X.13310
Féret, J.-B., Asner, G.P., 2014. Mapping tropical forest canopy diversity using high-fidelity imaging spectroscopy. Ecol. Appl. 24, 1289–1296. https://doi.org/10.1890/13-1824.1
Food and Agriculture Organization (1985). Tropical forestry: action plan. Food & Agriculture Organiza- tion of the United Nations.
Geertz, C. (1963). Agricultural involution: the processes of ecological change in Indonesia. University of California Press.
Hesselbarth, M.H.K., Sciaini, M., With, K.A., Wiegand, K., Nowosad, J. 2019. landscapemetrics: an open‐source R tool to calculate landscape metrics. Ecography, 42: 1648-1657 (ver. 0).
Malthus, T. R. (1826). An essay on the principle of population. J. Murray.
Nash, J. F. et al. (1950). Equilibrium points in n-person games. Proceedings of the National Academy of Sciences, 36(1):48–49.
Weinstock, J. A. (2015). The future of swidden cultivation. In Cairns, M. F., (ed.), Shifting cultivation and environmental change: indigenous people, agriculture, and forest conservation. Routledge, pp. 179–85.
Wilk, R. R. (1997). Household ecology. Northern Illinois University Press.
