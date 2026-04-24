function plot_pseudo_continuum
  compile_opt idl2

  ;+
  ; NAME:
  ;    PLOT_PSEUDO_CONTINUUM
  ;
  ; PURPOSE:
  ;    Plots the CHIANTI synthetic spectrum for the flare, with the model
  ;    continuum overplotted as well as the measured continuum intensities.
  ;
  ; INPUTS:
  ;    None.
  ;
  ; OUTPUTS:
  ;    Creates an IDL plot object and saves it as the file
  ;    plot_pseudo_continuum.png in the local directory.
  ;
  ; MODIFICATION HISTORY:
  ;    Ver.1, 23-Apr-2026, Peter Young
  ;-

  datadir = file_dirname(file_which('continuum_processing_script.pro'))
  datadir = concat_dir(datadir, 'data')

  dem_file = concat_dir(datadir, 'flare_mcmc_calib_v1.dem')
  lpress = 17.3
  abund_file = concat_dir(datadir, 'sun_photospheric_fip_bias_0_57.abund')
  ioneq_file = concat_dir(datadir, 'chianti_p1730.ioneq')

  if n_elements(y) eq 0 then begin
    ch_synthetic, 170, 292, output = output, pressure = 10. ^ lpress, adv = 0, ioneq_name = ioneq_file, dem_name = dem_file, /lookup, /photon
    ;
    junk = temporary(lambda)
    make_chianti_spec, output, lambda, spectrum1, abund_name = abund_file, /continuum, /lookup, instr_fwhm = 0.06, bin_size = 0.0223, /photon, /all
    ;
    junk = temporary(lambda)
    make_chianti_spec, output, lambda, spectrum2, abund_name = abund_file, /lookup, instr_fwhm = 0.06, bin_size = 0.0223, /photon, /all
  endif

  x = spectrum1.lambda

  y = spectrum1.spectrum
  yc = y - spectrum2.spectrum

  th = 2
  fs = 11

  xdim = 700
  ydim = 350
  w = window(dim = [xdim, ydim])

  x0 = 0.09
  x1 = 0.975
  y0 = 0.115
  y1 = 0.98

  ;
  ; SW plot
  ; ------
  xr = [190, 200]
  scl = 1e13
  yr = [0, 2e14] / scl

  p = plot(x, y / scl, /stairstep, th = th, xth = th, yth = th, $
    xrange = xr, yrange = yr, /xsty, /ysty, /current, $
    pos = [x0, y0, x1, y1], $
    font_size = fs, $
    xticklen = 0.018, $
    yticklen = 0.012, $
    xtitle = 'Wavelength (' + string(197b) + ')', $
    ytitle = 'Intensity (x10!u13!n photon cm!u-2!n s!u-1!n sr!u-1!n ' + string(197b) + '!u-1!n)')

  q = plot(x, yc / scl, color = 'blue', th = th, /overplot)

  d = sg_read_avg_int(concat_dir(datadir, 'sw_continuum_ints.txt'))

  k = where(d.wvl ge xr[0] and d.wvl le xr[1], nk)
  d = d[k]

  c_int = fltarr(nk)
  c_diff = fltarr(nk)
  c_diff_perc = fltarr(nk)
  for i = 0, nk - 1 do begin
    getmin = min(abs(x - d[i].wvl), imin)
    c_int[i] = yc[imin]
    c_diff[i] = y[imin] - yc[imin]
    c_diff_perc[i] = c_diff[i] / yc[imin] * 100.
  endfor

  r = plot(d.wvl, c_int / scl, symbol = 'X', sym_size = 2, color = 'red', /overplot, $
    sym_thick = th)

  w.save, 'plot_pseudo_continuum.png', width = 2 * xdim

  return, w
end
