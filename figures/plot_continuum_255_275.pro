function plot_continuum_255_275
  compile_opt idl2

  ;+
  ; NAME:
  ;    PLOT_CONTINUUM_255_275
  ;
  ; PURPOSE:
  ;    Plots the wavelength region 255-275 A, and overplots the modeled
  ;    continuum and the continuum modeled using DZWW25 effective area.
  ;
  ; INPUTS:
  ;    None.
  ;
  ; OUTPUTS:
  ;    Creates an IDL plot object and saves it as the file
  ;    plot_continuum_255_275.png in the local directory.
  ;
  ; MODIFICATION HISTORY:
  ;    Ver.1, 23-Apr-2026, Peter Young
  ;-

  datadir = file_dirname(file_which('continuum_processing_script.pro'))
  datadir = concat_dir(datadir, 'data')

  make_bg_subtracted_continuum_spectrum, swspec = swspec, lwspec = lwspec

  xdim = 900
  ydim = 400
  w = window(dim = [xdim, ydim])

  x0 = 0.08
  x1 = 0.98
  y0 = 0.11
  y1 = 0.98
  ; dy=(y1-y0)/2.
  ; ddy=0.06

  th = 2
  fs = 11
  xtl = 0.018
  ytl = 0.009

  extra = {thick: th, $
    xthick: th, $
    ythick: th, $
    font_size: fs, $
    xticklen: xtl, $
    yticklen: ytl, $
    xstyle: 1}

  wvl = rebin(swspec.wvl, 1024)
  int = rebin(swspec.int, 1024)

  ;
  ; Get the continuum intensity from the DEM.
  ;
  log_press = 17.3
  abund_file = concat_dir(datadir, 'sun_photospheric_fip_bias_0_57.abund')
  ioneq_file = concat_dir(datadir, 'chianti_p1730.ioneq')
  dem_file = concat_dir(datadir, 'flare_mcmc_calib_v1.dem')
  read_dem, dem_file, logt_dem, log_dem
  dwvl_sw = mean(swspec.wvl[1 : *] - swspec.wvl[0 : -2])
  wvl_sw = findgen(2048) * dwvl_sw + 170.
  ;
  dwvl_lw = mean(lwspec.wvl[1 : *] - lwspec.wvl[0 : -2])
  wvl_lw = findgen(2048) * dwvl_lw + 246.
  ;
  c_dem_lw = ch_continuum(10. ^ logt_dem, wvl_lw, /photon, press = 10. ^ log_press, $
    abund_file = abund_file, adv = 0, ioneq_file = ioneq_file, $
    dem_int = 10. ^ log_dem, /sum)

  t_exp = swspec.exposure_time
  slit_size = 2.0

  ;
  ; Plot LW spectrum in lower panel
  ;
  wvl = rebin(lwspec.wvl, 1024)
  int = rebin(lwspec.int, 1024)
  q = plot(wvl, int, /stairstep, $
    pos = [x0, y0, x1, y1], $
    _extra = extra, /current, $
    xrange = [255, 275], $
    ymin = 1, $
    xtitle = 'Wavelength (' + string(197b) + ')', $
    ytitle = 'Detected photons per pixel', $
    yrange = [0, 150])

  synt_spec = c_dem_lw.int * 2.349e-11 * dwvl_lw * t_exp * slit_size * read_effective_area(wvl_lw)

  q2 = plot(/overplot, c_dem_lw.wvl, synt_spec, color = color_tol('blue'), $
    th = 3)

  synt_spec = c_dem_lw.int * 2.349e-11 * dwvl_lw * t_exp * slit_size * interpol_eis_ea('30-sep-2024', wvl_lw)

  q3 = plot(/overplot, c_dem_lw.wvl, synt_spec, color = color_tol('red'), $
    th = 3)

  c = sg_read_avg_int(concat_dir(datadir, 'lw_continuum_ints.txt'))

  q4 = plot(/overplot, c.wvl, c.int, symbol = 'X', color = color_tol('orange'), $
    sym_thick = 3, sym_size = 3, linesty = 'none')

  w.save, 'plot_continuum_255_275.png', width = 2 * xdim

  return, w
end
