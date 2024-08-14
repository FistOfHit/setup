# Carbon emissions estimation

Estimating CO2e (carbon dioxide equivalent) emissions from compute usage.s

## Includes

- `requirements.txt` - Python requirements to be installed
- `get_carbon_emissions.py` - Script for calculating carbon emissions by energy use

## Notes

- Run within a virtual env with venv or conda-env depending on your setup
- install requirements with `python3 -m pip install requirements.txt`

## Following these sources

- [Emissions factors - source 1](https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fwww.seai.ie%2Fdata-and-insights%2Fseai-statistics%2Fconversion-factors%2FSEAI-conversion-and-emission-factors.xlsx&wdOrigin=BROWSELINK)
- [Emissions factors - source 2](https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fwww.eia.gov%2Fenvironment%2Femissions%2Fxls%2FCO2_coeffs_detailed.xls&wdOrigin=BROWSELINK)
- [Emissions factors - source 3](https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fjeodpp.jrc.ec.europa.eu%2Fftp%2Fpublic%2FJRC-OpenData%2FCoM%2FEmissionsFactorElectricity%2FCoM-Emission-factors-for-national-electricity-2024.xlsx&wdOrigin=BROWSELINK)

## Future work plans
- Add timeseries calculation capability, move to pandas
- Add plots
- Add checks and make integration with power APIs easy
- Add export to CSV
