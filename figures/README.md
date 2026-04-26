# Figures

The IDL routines in this directory generate the figures for the article "Modeling Flare Continuum Emission Observed by Hinode/EIS: Instrument Calibration and Element Composition Results" by Peter R. Young and Biswajit Mondal.

Each routine is run in the same way with a command such as:

    IDL> w=plot_continuum_properties()

where w is the plot object that is created. No inputs are required for the routines since they automatically access data in the repository. Each routine automatically saves the displayed image to the working directory with a filename such as plot_continuum_properties.png.

## File summary
|File|Type|Format|Summary|
|----|----|------|-------|
|plot_continuum_properties|IDL routine|text|Generates Figure 1 of the paper.|
|plot_context_image_v2|IDL routine|text|Generates Figure 2 of the paper.|
|plot_continuum_cross_section|IDL routine|text|Generates Figure 3 of the paper.|
|plot_ea_spec_comparison|IDL routine|text|Generates Figure 4 of the paper.|
|plot_continuum_fits|IDL routine|text|Generates Figure 5 of the paper.|
|plot_flare_dem|IDL routine|text|Generates Figure 6 of the paper.|
|plot_ea_comparison_v2|IDL routine|text|Generates Figure 7 of the paper.|
|plot_continuum_255_275|IDL routine|text|Generates Figure 8 of the paper.|
|plot_pseudo_continuum|IDL routine|text|Generates Figure 10 of the paper.|
|plot_dark_current|IDL routine|text|Generates Figure 11 of the paper.|

