function plot_flare_dem
  compile_opt idl2

  ;+
  ; NAME:
  ;    PLOT_FLARE_DEM
  ;
  ; PURPOSE:
  ;    Creates a two-panel plot. The left panel shows the derived flare DEM,
  ;    and the right panel shows the DEM convolved with the continuum
  ;    emissivity.
  ;
  ; INPUTS:
  ;    None.
  ;
  ; OUTPUTS:
  ;    Creates an IDL plot object and saves it as the file
  ;    plot_flare_dem.png in the local directory.
  ;
  ; MODIFICATION HISTORY:
  ;    Ver.1, 23-Apr-2026, Peter Young
  ;-

  datadir = file_dirname(file_which('continuum_processing_script.pro'))
  datadir = concat_dir(datadir, 'data')

  restore, concat_dir(datadir, 'mcmc_dem_calib0.sav')
  o1 = output
  restore, concat_dir(datadir, 'mcmc_dem_calib_v1.sav')
  o2 = output

  xdim = 850
  ydim = 400
  w = window(dim = [xdim, ydim])

  x0 = -0.01
  x1 = 0.99
  dx = (x1 - x0) / 2.
  ddx = 0.10
  y0 = 0.12
  y1 = 0.98

  th = 2
  fs = 11
  xtl = 0.018
  ytl = 0.018

  demerr = fltarr(2, 22)
  demerr[0, *] = o2.dem - reform(o2.demerr[*, 0])
  demerr[1, *] = reform(o2.demerr[*, 1]) - o2.dem

  p = errorplot(o2.ltemp, o2.dem, demerr, $
    /stairstep, $
    th = th, font_size = fs, /current, xsty = 3, $
    xth = th, yth = th, $
    pos = [x0 + ddx, y0, x0 + dx, y1], $
    /ylog, $
    ymin = 4, $
    errorbar_th = th, $
    xtickdir = 1, ytickdir = 1, $
    yrange = [2e20, 4e24], /ysty, $
    xticklen = xtl, yticklen = ytl, $
    xtitle = 'Log ( Temperature (K) )', $
    ytitle = 'Log ( DEM (cm!u-5!n K!u-1!n) )')

  pt = text(font_size = fs, x0 + ddx + 0.02, y1 - 0.02, '(a)', $
    vertical_align = 1.0)

  ;
  ; Plot the continuum contribution function multiplied by the DEM.
  ;
  ab_file = concat_dir(datadir, 'sun_photospheric_fip_bias_0_57.abund')
  ioneq_file = concat_dir(datadir, 'chianti_p1730.ioneq')
  c = ch_continuum(10. ^ o2.ltemp, 195.79, pressure = 2.04e17, $
    abund_file = ab_file, $
    ioneq_file = ioneq_file, adv = 0, /phot)

  scl = 1e12
  q = plot(o2.ltemp, reform(c.int) * 10. ^ o2.ltemp * o2.dem * alog(10.) * 0.1 / scl, $
    /stairstep, $
    th = th, font_size = fs, /current, xsty = 3, $
    xth = th, yth = th, $
    pos = [x0 + dx + ddx, y0, x0 + 2 * dx, y1], $
    xtickdir = 1, ytickdir = 1, $
    xticklen = xtl, yticklen = ytl, $
    xtitle = 'Log ( Temperature (K) )', $
    ytitle = 'P!d!9l!3!n ( x10!u12!n photon cm!u-2!n s!u-1!n sr!u-1!n ' + string(197b) + '!u-1!n )')

  q2 = plot(o2.ltemp, reform(c.int_fb) * 10. ^ o2.ltemp * o2.dem * alog(10.) * 0.1 / scl, $
    /stairstep, $
    color = 'blue', /overplot, th = th)

  qt = text(font_size = fs, x0 + ddx + dx + 0.02, y1 - 0.02, '(b)', $
    vertical_align = 1.0)

  w.save, 'plot_flare_dem.png', wdith = 2 * xdim

  return, w
end
