# 10M-Buoy-Climate-Data-Pipeline-R-Tableau
High-efficiency R &amp; Tableau data pipeline processing 10.4M+ NDBC marine meteorological records locally on constrained hardware (Intel Core i3, 4GB RAM) with zero cloud reliance. Includes vectorized ETL scripts, telemetry benchmarks, and an interactive Tableau dashboard.


🌊 10M Record Buoy Climate Data Pipeline & AnalyticsA high-throughput, memory-optimized data engineering pipeline built to process and aggregate over 10.4 Million records (10,410,410 rows) of raw marine meteorological and oceanographic buoy climate time-series data.Engineered entirely on bare-metal restricted hardware using R (tidyverse, readr) with zero cloud dependencies, this pipeline cleans, filters, transforms, and aggregates large-scale climate records into structured summaries for interactive visualization in Tableau Public.

📌 Project OverviewDataset Size: 10,410,410 Rows × 15 Columns (Marine Meteorological Time-Series Data)Domain: Oceanographic & Marine Climate Telemetry (NDBC Buoy Stations)Core Task: ETL (Extract, Transform, Load), Type-Casting, Vectorized Filtering, Station Aggregation, & Tableau ExportKey Challenge: Memory-constrained local processing under strict physical hardware limits without triggering out-of-memory (OOM) faults

.💻 Hardware Constraints & Operating Environment

This pipeline was designed and executed under strict bare-metal hardware constraints without cloud instance scaling or external compute assistance:

ComponentSpecification / Constraint DetailsProcessor (CPU)Intel® Core™ i3 @ 1.20 GHz
Installed RAM4.0 GB Physical System MemoryOS 
OverheadWindows 10 (~2.0 GB OS Memory Allocation)Available Heap Memory~2.0 GB Net RAM Available for Execution
Cloud Compute Support0% (100% Local Bare-Metal Execution)Peak RAM FootprintMemory footprint managed via R C++ vectorized memory management

🛠️ Tools & Technologies Used

Programming Language: R (v4.6.1)Data Processing Libraries:readr (Fast C++ backed CSV ingestion)tidyverse / dplyr (Vectorized manipulation & aggregation)

Data Visualization & Analytics: Tableau PublicDevelopment Environment: RStudio IDE

🏗️ System Architecture & Data Flow+-------------------------------+
|  Raw Ingestion (readr)        |  --> 10,410,410 Raw Buoy Telemetry Records
|  read_csv(data_raw)           |
+-------------------------------+
                |
                v
+-------------------------------+
|  Deduplication Gate           |  --> Purges exact duplicate rows
|  distinct()                   |
+-------------------------------+
                |
                v
+-------------------------------+
|  Type Casting & Quality Gate  |  --> Casts wspd & wtmp to numeric types
|  mutate() + filter()          |  --> Filters invalid values (wspd > 0 & wtmp > 0)
+-------------------------------+
                |
                v
+-------------------------------+
|  Station-Level Aggregation    |  --> Groups by station_id
|  group_by() + summarise()     |  --> Computes Avg_Wind_Speed, Avg_Wind_Temp & Volume
+-------------------------------+
                |
                v
+-------------------------------+
|  Tableau CSV Export           |  --> Exports compact aggregated dataset (~42 rows)
|  write.csv()                  |  --> Ready for BI Dashboard visualization
+-------------------------------+

📜 Core Pipeline Code (R Script)Below is the production-ready script (Buoy_Climate_10M_data_script.R) used for high-performance ingestion and transformation:# ==============================================================================
# Project: 10M Buoy Climate Data Pipeline & Analytics
# Execution Engine: R (tidyverse + readr)
# Target: High-throughput ingestion & memory-optimized aggregation
# ==============================================================================

library(tidyverse)
library(readr)

# 1. High-speed CSV Ingestion
data_raw <- read_csv(file.choose())

# 2. Inspect Dataset Structure
glimpse(data_raw)

# 3. Vectorized Data Cleaning, Filtering, and Aggregation
final_buoy_10M_data <- data_raw %>% 
  distinct() %>%
  mutate(
    wspd = as.numeric(wspd),
    wtmp = as.numeric(wtmp)
  ) %>% 
  filter(
    wspd > 0.00 & 
    wtmp > 0
  ) %>%
  group_by(station_id) %>%
  summarise(
    Avg_Wind_Speed = mean(wspd),
    Avg_Wind_Temp  = mean(wtmp),
    Total_Station  = n(),
    .groups        = 'drop'
  ) %>% 
  arrange(desc(Total_Station))

# 4. Preview Summarized Output
print(final_buoy_10M_data)

# 5. Export Compact Data Engine File for Tableau Public
write.csv(final_buoy_10M_data, 'Buoy_Climate_10M_data.csv', row.names = FALSE)

# Print Working Directory
getwd()


📊 Dashboard & Telemetry Metrics

After executing the pipeline over 10,410,410 observation rows, the data engine successfully aggregated the telemetry into station-level benchmarks:
Station IDAvg Wind Speed (wspd)Avg Water Temp (wtmp °C)Total Observations (Total_Station)440075.60 m/s9.87 °C316,774420026.26 m/s26.40 °C315,044460017.41 m/s7.95 °C305,189420015.90 m/s26.50 °C300,273460265.58 m/s12.60 °C296,634460136.49 m/s11.70 °C295,436410095.76 m/s25.50 °C291,594460225.69 m/s11.80 °C269,237440256.59 m/s13.60 °C259,415410085.64 m/s21.60 °C254,313Note: The pipeline compressed 10.4M raw readings down to 42 high-value station aggregates, reducing dataset volume by 99.99% for instant dashboard rendering.

💡 Actionable Insights & Value Delivered
      Offshore Renewable Energy Site Selection:Station 46001 demonstrated the highest average wind speed (7.41 m/s), making its ocean region a prime candidate for offshore wind farm installations.
       Thermal & Oceanic Climate Monitoring:
            Warm-water telemetry stations such as 42001 (26.5°C) and 42002 (26.4°C) provide critical baseline metrics for monitoring sea surface temperature (SST) anomalies and marine ecosystem shifts.Sensor 

Reliability & Equipment Lifecycle:

  Top-performing stations (e.g., 44007 with 316.7k observations) highlight buoys with exceptionally high operational uptime, aiding in preventative maintenance scheduling for remote maritime hardware.
       
  Zero-Cost Big Data Infrastructure:Demonstrated that 10M+ row datasets can be ingested, cleaned, and aggregated locally without incurring expensive cloud compute or data warehouse fees (e.g., AWS EMR, Snowflake, Databricks).
        
         
  👤 Author Information
        Niaz Mohammad Shoyab
        Data Engineer & Analytics Specialist
        Email: talkmridul@gmail.com
        LinkedIn: linkedin.com/in/niaz-shoyab-495061b8
