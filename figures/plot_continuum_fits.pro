function plot_continuum_fits
  compile_opt idl2

  ;+
  ; NAME:
  ;    PLOT_CONTINUUM_FITS
  ;
  ; PURPOSE:
  ;    Shows the measured continuum intensities, with the cubic spline
  ;    fit over-plotted.
  ;
  ; INPUTS:
  ;    None.
  ;
  ; OUTPUTS:
  ;    Creates an IDL plot object and saves it as the file
  ;    plot_continuum_fits.png in the local directory.
  ;
  ; MODIFICATION HISTORY:
  ;    Ver.1, 23-Apr-2026, Peter Young
  ;-

  datadir = file_dirname(file_which('continuum_processing_script.pro'))
  datadir = concat_dir(datadir, 'data')

  xdim = 850
  ydim = 400
  w = window(dim = [xdim, ydim])

  x0 = 0.03
  x1 = 0.99
  dx = (x1 - x0) / 2.
  ddx = 0.05
  y0 = 0.11
  y1 = 0.98

  th = 2
  fs = 11
  xtl = 0.015
  ytl = 0.015

  ;
  ; SW channel
  ;
  restore, concat_dir(datadir, 'sw_cont_fit.sav')
  ;
  xx = ea_cont_fit.xx
  yy = ea_cont_fit.yy
  ee = ea_cont_fit.ee
  k = where(yy gt 0.)
  xx = xx[k]
  yy = yy[k]
  ee = ee[k]
  p = errorplot(xx, yy, ee, $
    symbol = 'x', $
    linesty = 'none', /current, $
    pos = [x0 + ddx, y0, x0 + dx, y1], $
    th = th, font_size = fs, xth = th, yth = th, $
    xticklen = xtl, yticklen = ytl, $
    xsty = 3, xmin = 4, $
    ymin = 1, $
    yrange = [0, 550], /ysty, $
    sym_thick = th, errorbar_th = th, $
    ytitle = 'Detected photons per pixel')

  xi = findgen(43) + 170.
  y2 = spl_init(ea_cont_fit.x_spl, ea_cont_fit.aa)
  yi = spl_interp(ea_cont_fit.x_spl, ea_cont_fit.aa, y2, xi)
  ;
  po = plot(/overplot, color = 'blue', $
    xi, exp(yi), th = th)

  n_spl = n_elements(ea_cont_fit.x_spl)
  for i = 0, n_spl - 1 do pl = plot(/overplot, ea_cont_fit.x_spl[i] * [1, 1], $
    p.yrange, th = th, color = 'light salmon', transparen = 0.7)

  pt = text(x0 + ddx + 0.02, y1 - 0.02, vertical_align = 1.0, $
    '(a) SW', font_size = fs + 1)

  ;
  ; LW channel
  ;
  restore, concat_dir(datadir, 'lw_cont_fit.sav')
  ;
  q = errorplot(ea_cont_fit.xx, ea_cont_fit.yy, ea_cont_fit.ee, $
    symbol = 'x', $
    linesty = 'none', /current, $
    pos = [x0 + dx + ddx, y0, x0 + 2 * dx, y1], $
    th = th, font_size = fs, xth = th, yth = th, $
    xticklen = xtl, yticklen = ytl, $
    yrange = [0, 85], /ysty, $
    xsty = 3, xmin = 4, $
    sym_thick = th, errorbar_th = th)

  xi = findgen(47) + 246.
  y2 = spl_init(ea_cont_fit.x_spl, ea_cont_fit.aa)
  yi = spl_interp(ea_cont_fit.x_spl, ea_cont_fit.aa, y2, xi)
  ;
  qo = plot(/overplot, color = 'blue', $
    xi, exp(yi), th = th)

  for i = 0, 7 do ql = plot(/overplot, ea_cont_fit.x_spl[i] * [1, 1], $
    q.yrange, th = th, color = 'light salmon', transparen = 0.7)

  qt = text(x0 + dx + ddx + 0.02, y1 - 0.02, vertical_align = 1.0, $
    '(b) LW', font_size = fs + 1)

  xt = text(x0 + ddx + (2 * dx - ddx) / 2., 0.01, 'Wavelength (' + string(197b) + ')', $
    font_size = fs, align = 0.5)

  w.save, 'plot_continuum_fits.png', width = 2 * xdim

  return, w
end
