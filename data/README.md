# paper_2025_eis_calib / data

Supporting data for the article "Modeling Flare Continuum Emission Observed by Hinode/EIS: Instrument Calibration and Element Composition Results."

## File summary

|File|Type|Format|Summary|
|----|----|------|-------|
|20240930_225718_continuum_bg.sav|IDL save file|sav|Contains the background spectrum used for the continuum analysis|
|20240930_225718_continuum_spec_calib0.sav|IDL save file|sav|The flare spectrum calibrated with the pre-launch EA curves|
|20240930_225718_continuum_spec.sav|IDL save file|sav|The flare spectrum in photon-event units|
|chianti_p1730.ioneq|CHIANTI ioneq|text|CHIANTI ionization equilibrium calculated for a pressure of 10^17.3 K/cm3|
|data_wvl_lw.sav|IDL save file|sav|Data file for detector background|
|data_wvl_sw.sav|IDL save file|sav|Data file for detector background|
|data_y_lw.sav|IDL save file|sav|Data file for detector background|
|data_y_sw.sav|IDL save file|sav|Data file for detector background|
|eis_eff_area_cont_lw_v1.txt|EA file|text|The final effective area (EA) curve for the EIS LW channel|
|eis_eff_area_cont_sw_v1.txt|EA file|text|The final effective area (EA) curve for the EIS SW channel|
|flare_mcmc_calib_v1.dem|CHIANTI DEM file|text|The DEM derived with the final calibration|
|flare_mcmc_calib0.dem|CHIANTI DEM file|text|The DEM derived with the pre-launch calibration|
|line_list.txt|ch_dem line list|text|List of lines used for the DEM in ch_dem format|
|line_list_v1.tex|Latex file|tex|Latex table giving list of line intensities|
|lw_cont_fit.sav|IDL save file|sav|Contains the spline fit to the LW continuum|
|sw_cont_fit.sav|IDL save file|sav|Contains the spline fit to the SW continuum|
|lw_continuum_ints.txt|Intensity file|text|The continuum intensity measurements for the LW channel|
|sw_continuum_ints.txt|Intensity file|text|The continuum intensity measurements for the SW channel|
|mcmc_dem_calib0.sav|IDL save file|sav|DEM solution with initial effective area curves|
|mcmc_dem_calib_v1.sav|IDL save file|sav|DEM solution with final effective area curves|
|spec_gauss_fits_calib0.txt|Intensity file|text|The emission line intensities using the pre-launch calibration|
|spec_gauss_fits_calib_v1.txt|Intensity file|text|The emission line intensities using the final calibration|
|sun_photospheric_fip_bias_0_57.abund|Abundance file|text|The CHIANTI photospheric abundance file modified to lower the low FIP element abundances by 0.57|

## How the files are used

The observed spectra in 20240930_225718_continuum_bg.sav and 20240930_225718_continuum_spec.sav are combined by 
the routine make_bg_subtracted_continuum_spectrum.pro to yield the background-subtracted continuum spectrum from which the 
continuum intensities (sw_ and lw_continuum_ints.txt) are measured using the SSW routine spec_gauss_eis.pro (use the /continuum keyword).

The flare emission line intensities in spec_gauss_fits_calib0.txt are measured from the spectrum in 20240930_225718_continuum_spec_calib0.sav 
using  the SSW Gaussian fitting routine spec_gauss_eis.pro.

