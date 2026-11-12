# 🌊 10M Record Buoy Climate Data Pipeline & Analytics

A high-throughput, memory-optimized data engineering pipeline built to process and aggregate over **10.4 Million records (10,410,410 rows)** of raw marine meteorological and oceanographic buoy climate time-series data. 

Engineered entirely on **bare-metal restricted hardware** using R (`tidyverse`, `readr`) with zero cloud dependencies, this pipeline cleans, filters, transforms, and aggregates large-scale climate records into structured summaries for interactive visualization in **Tableau Public**.

---

## 📌 Project Overview

* **Dataset Size:** 10,410,410 Rows × 15 Columns (Marine Meteorological Time-Series Data)
* **Domain:** Oceanographic & Marine Climate Telemetry (NDBC Buoy Stations)
* **Core Task:** ETL (Extract, Transform, Load), Type-Casting, Vectorized Filtering, Station Aggregation, & Tableau Export
* **Key Challenge:** Memory-constrained local processing under strict physical hardware limits without triggering out-of-memory (OOM) faults.

---

## 💻 Hardware Constraints & Operating Environment

This pipeline was designed and executed under strict bare-metal hardware constraints without cloud instance scaling or external compute assistance:

| Component | Specification / Constraint Details |
| :--- | :--- |
| **Processor (CPU)** | Intel® Core™ i3 @ 1.20 GHz |
| **Installed RAM** | 4.0 GB Physical System Memory |
| **OS Overhead** | Windows 10 (~2.0 GB OS Memory Allocation) |
| **Available Heap Memory** | **~2.0 GB Net RAM Available for Execution** |
| **Cloud Compute Support** | **0% (100% Local Bare-Metal Execution)** |
| **Peak RAM Footprint** | Memory footprint managed via R C++ vectorized memory management |

---

## 🛠️ Tools & Technologies Used

* **Programming Language:** R (v4.6.1)
* **Data Processing Libraries:**
  * `readr` (Fast C++ backed CSV ingestion)
  * `tidyverse` / `dplyr` (Vectorized manipulation & aggregation)
* **Data Visualization & Analytics:** Tableau Public
* **Development Environment:** RStudio IDE

---

## 🏗️ System Architecture & Data Flow

```
+-------------------------------+
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
```

---

## 📜 Core Pipeline Code (R Script)

Below is the production-ready script (`Buoy_Climate_10M_data_script.R`) used for high-performance ingestion and transformation:

```R
# ==============================================================================
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
```

---

## 📊 Dashboard & Telemetry Metrics

After executing the pipeline over **10,410,410 observation rows**, the data engine successfully aggregated the telemetry into station-level benchmarks:

| Station ID | Avg Wind Speed (`wspd`) | Avg Water Temp (`wtmp` °C) | Total Observations (`Total_Station`) |
| :--- | :--- | :--- | :--- |
| **44007** | 5.60 m/s | 9.87 °C | **316,774** |
| **42002** | 6.26 m/s | 26.40 °C | **315,044** |
| **46001** | 7.41 m/s | 7.95 °C | **305,189** |
| **42001** | 5.90 m/s | 26.50 °C | **300,273** |
| **46026** | 5.58 m/s | 12.60 °C | **296,634** |
| **46013** | 6.49 m/s | 11.70 °C | **295,436** |
| **41009** | 5.76 m/s | 25.50 °C | **291,594** |
| **46022** | 5.69 m/s | 11.80 °C | **269,237** |
| **44025** | 6.59 m/s | 13.60 °C | **259,415** |
| **41008** | 5.64 m/s | 21.60 °C | **254,313** |

*Note: The pipeline compressed 10.4M raw readings down to 42 high-value station aggregates, reducing dataset volume by **99.99%** for instant dashboard rendering.*

---

## 💡 Actionable Insights & Value Delivered

1. **Offshore Renewable Energy Site Selection:**
   * Station **46001** demonstrated the highest average wind speed (**7.41 m/s**), making its ocean region a prime candidate for offshore wind farm installations.
2. **Thermal & Oceanic Climate Monitoring:**
   * Warm-water telemetry stations such as **42001 (26.5°C)** and **42002 (26.4°C)** provide critical baseline metrics for monitoring sea surface temperature (SST) anomalies and marine ecosystem shifts.
3. **Sensor Reliability & Equipment Lifecycle:**
   * Top-performing stations (e.g., **44007 with 316.7k observations**) highlight buoys with exceptionally high operational uptime, aiding in preventative maintenance scheduling for remote maritime hardware.
4. **Zero-Cost Big Data Infrastructure:**
   * Demonstrated that 10M+ row datasets can be ingested, cleaned, and aggregated locally without incurring expensive cloud compute or data warehouse fees (e.g., AWS EMR, Snowflake, Databricks).

---

## 👤 Author Information

**Niaz Mohammad Shoyab**  
*Data Engineer & Analytics Specialist*

* **Email:** [talkmridul@gmail.com](mailto:talkmridul@gmail.com)
* **LinkedIn:** [linkedin.com/in/niaz-shoyab-495061b8](https://www.linkedin.com/in/niaz-shoyab-495061b8)
* **GitHub:** [github.com/talkmridul-bit](https://github.com/talkmridul-bit)