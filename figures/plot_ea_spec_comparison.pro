function plot_ea_spec_comparison
  compile_opt idl2

  ;+
  ; NAME:
  ;    PLOT_EA_SPEC_COMPARISON
  ;
  ; PURPOSE:
  ;    Compares the photon spectra with the pre-launch effective areas.
  ;
  ; INPUTS:
  ;    None.
  ;
  ; OUTPUTS:
  ;    Creates an IDL plot object and saves it as the file
  ;    plot_ea_spec_comparison.png in the local directory.
  ;
  ; MODIFICATION HISTORY:
  ;    Ver.1, 23-Apr-2026, Peter Young
  ;-

  make_bg_subtracted_continuum_spectrum, swspec = swspec, lwspec = lwspec

  xdim = 850
  ydim = 700
  w = window(dim = [xdim, ydim])

  th = 2
  fs = 11
  xtl = 0.020
  ytl = 0.008

  x0 = 0.08
  x1 = 0.915
  y0 = 0.025
  y1 = 0.985
  dy = (y1 - y0) / 2.
  ddy = 0.04

  ;
  ; SW channel
  ;
  xx = rebin(swspec.wvl, 1024)
  yy = rebin(swspec.int, 1024)
  k = where(xx ge 190 and xx le 195 and yy le 0.)
  yy[k] = 1000.
  ;
  scl = 1600.
  ;
  p = plot(xx, yy, /stairstep, th = th, /current, $
    pos = [x0, y0 + dy + ddy, x1, y1], $
    yra = [0, 600], /ysty, $
    xth = th, yth = th, font_size = fs, $
    ymin = 1, $
    ytit = 'Detected photons per pixel', $
    xticklen = xtl, yticklen = ytl, $
    xra = [175, 212], /xsty)
  ax = p.axes
  ax[3].coord_transform = [0, 1. / scl]
  ax[3].color = 'blue'
  ax[3].title = 'Effective area (cm!u2!n)'
  ax[3].showtext = 1

  wvl = findgen(43) + 170.
  ea = eis_eff_area(wvl)

  po = plot(/overplot, wvl, ea * scl, th = th, col = 'blue')

  pt = text(x1 - 0.05, y1 - 0.02, vertical_align = 1.0, $
    align = 1.0, $
    font_size = fs, '(a) SW')

  ;
  ; LW channel
  ;
  xx = rebin(lwspec.wvl, 1024)
  yy = rebin(lwspec.int, 1024)
  ;
  scl = 650.
  ;
  q = plot(xx, yy, /stairstep, th = th, /current, $
    pos = [x0, y0 + ddy, x1, y0 + dy], $
    xth = th, yth = th, font_size = fs, $
    xticklen = xtl, yticklen = ytl, $
    ymin = 1, $
    ytit = 'Deteted photons per pixel', $
    xtit = 'Wavelength (' + string(197b) + ')', $
    yra = [0, 90], /ysty, $
    /xsty)
  ax = q.axes
  ax[3].coord_transform = [0, 1. / scl]
  ax[3].color = 'blue'
  ax[3].title = 'Effective area (cm!u2!n)'
  ax[3].showtext = 1

  wvl = findgen(47) + 246.
  ea = eis_eff_area(wvl)

  qo = plot(/overplot, wvl, ea * scl, th = th, col = 'blue')

  pt = text(x1 - 0.05, y0 + dy - 0.02, vertical_align = 1.0, $
    align = 1.0, $
    font_size = fs, '(b) LW')

  w.save, 'plot_ea_spec_comparison.png', width = xdim

  return, w
end
