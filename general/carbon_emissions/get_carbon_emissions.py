import numpy as np
import seaborn as sns

# List sources of incoming electricity
#   - proportion_of_total: What proportion of the total incoming electric
#     supply (out of 1) this source accounts for
#   - emission_factors: The scaling factors to convert from kWh to KgCO2.
#     List of factors from various sources. Multiple sources will result in
#     an additional stdev output
#     Common conversions:
#       - 1 kWh = 3412.142 Btu
num_sources = 1
energy_sources = {
    "coal": {
        "proportion_of_total": 0.7,
        "emission_factors": [0.3406],
    },
    "gas": {
        "proportion_of_total": 0.2,
        "emission_factors": [0.2293],
    },
    "solar": {
        "proportion_of_total": 0.1,
        "emission_factors": [0.001], #?
    },
}

# Checks on energy sources table
# Check atleast one energy source provided
# Check that proportions all add up to 1
# Check that emissions factors are all list of floats

# Input kWh usage or read from source
kWh_usage = 0.0

# Checks on kWh_usage
# Check its a float

# Calculate CO2e mean (and stdev if multiple emission factors given)
carbon_totals = [0]*num_sources
for source in energy_sources:
    proportion = source["proportion_of_total"]
    emission_factors = source["emission_factor"]

    # Iterate through all emissions factors
    for factor, c in emission_factors, carbon_totals:
        carbon_totals += proportion * factor * kWh_usage
    
# Get mean carbon output
carbon_total_mean = np.mean(carbon_totals)

# Get stdev if applicable
if len(carbon_totals) > 1: 
    carbon_total_stdev = np.sqrt(np.var(carbon_total_mean))
