function plot_continuum_properties, data = data
  compile_opt idl2

  ;+
  ; NAME:
  ;   plot_continuum_properties.pro
  ;
  ; PURPOSE:
  ;   Plot the properties of the continuum emission for the flare DEM
  ;   using CHIANTI
  ;
  ; CALLING SEQUENCE:
  ;   plot_continuum_properties, data=data
  ;
  ; INPUTS:
  ;   None.
  ;
  ; OPTIONAL INPUTS:
  ;   data:  The structure containing the continuum properties. Call
  ;          the routine once to populate it, then it can be used as
  ;          an input for the next call to save time..
  ;
  ; OUTPUTS:
  ;   A plot of the continuum properties. The plot is also saved as
  ;   the PNG file plot_continuum_properties.png in the working
  ;   directory.
  ;
  ; OPTIONAL OUTPUTS:
  ;   data: The structure containing the continuum properties.
  ;
  ; MODIFCATION HISTORY:
  ;    Ver.1, 21-Apr-2026, Peter Young
  ;-

  wvl = findgen(123) + 170.
  logt = findgen(21) / 10. + 5.5

  if n_elements(data) eq 0 then begin
    d = ch_continuum(10. ^ logt, wvl, /photon, abund = !abund_file, adv = 0, ioneq_file = !ioneq_file)
    data = d
  endif else begin
    d = data
  endelse

  scl = 1d18

  x0 = 0.015
  x1 = 0.985
  dx = (x1 - x0) / 3.
  ddx = 0.04
  y0 = 0.12
  y1 = 0.98

  xdim = 1000
  ydim = 400
  w = window(dim = [xdim, ydim])

  th = 2
  fs = 12
  xtl = 0.015
  ytl = 0.017

  p1 = plot(d.wvl, d.int[*, 20] * scl, th = th, $
    xth = th, yth = th, /current, $
    ; pos=[x0+ddx,y0+ddy+dy,x1,y1], $
    pos = [x0 + ddx, y0, x0 + dx, y1], $
    ymin = 1, xmin = 1, $
    ytitle = 'Intensity (photon cm!u-2!n s!u-1!n sr!u-1!n ' + string(197b) + '!u-1!n', $
    xtitle = 'Wavelength (' + string(197b) + ')', $
    /xsty, $
    xticklen = xtl, yticklen = ytl, $
    font_size = fs, name = 'logT=7.5')

  p2 = plot(/overplot, d.wvl, d.int[*, 15] * scl, color = color_tol('blue'), $
    th = th, name = 'logT=7.0')

  p3 = plot(/overplot, d.wvl, d.int[*, 10] * scl, color = color_tol('red'), $
    th = th, name = 'logT=6.5')

  p4 = plot(/overplot, d.wvl, d.int[*, 5] * scl, color = color_tol('magenta'), $
    th = th, name = 'logT=6.0')

  pl = legend(target = [p1, p2, p3, p4], font_size = fs - 1, th = th, $
    /data, pos = [285, 6.8])

  plbl = text(x0 + ddx + 0.01, y1 - 0.07, '(a)', font_size = fs + 2)

  ;
  ; (b) Continuum components at 195 Ang.
  ; ------------------------------------
  getmin = min(abs(wvl - 195), imin)
  q1 = plot(alog10(d.temp), d.int[imin, *] * scl, th = th, $
    xth = th, yth = th, /current, $
    pos = [x0 + dx + ddx, y0, x0 + 2 * dx, y1], /xsty, $
    ymin = 1, $
    xticklen = xtl, yticklen = ytl, $
    font_size = fs, name = 'total')

  q2 = plot(alog10(d.temp), d.int_ff[imin, *] * scl, th = th, $
    color = color_tol('blue'), name = 'free-free', $
    /overplot)

  q3 = plot(alog10(d.temp), d.int_fb[imin, *] * scl, th = th, $
    color = color_tol('red'), name = 'free-bound', $
    /overplot)

  qlbl = text(x0 + dx + ddx + 0.01, y1 - 0.07, $
    '(b)', font_size = fs + 2)

  qlbl2 = text(7, 1.5, '195 ' + string(197b), font_size = fs, /data, target = q1)

  qleg = legend(target = [q1, q2, q3], font_size = fs - 1, $
    th = th, pos = [7.43, 9.7], /data)

  ;
  ; (c) Continuum components at 270 Ang
  ; -----------------------------------
  getmin = min(abs(wvl - 270), imin)
  r1 = plot(alog10(d.temp), d.int[imin, *] * scl, th = th, $
    xth = th, yth = th, /current, $
    xticklen = xtl, yticklen = ytl, $
    ymin = 1, $
    pos = [x0 + 2 * dx + ddx, y0, x0 + 3 * dx, y1], /xsty, $
    font_size = fs, name = 'total')

  r2 = plot(alog10(d.temp), d.int_ff[imin, *] * scl, th = th, $
    color = color_tol('blue'), name = 'free-free', $
    /overplot)

  r3 = plot(alog10(d.temp), d.int_fb[imin, *] * scl, th = th, $
    color = color_tol('red'), name = 'free-bound', $
    /overplot)

  rlbl = text(x0 + 2 * dx + ddx + 0.01, y1 - 0.07, '(c)', font_size = fs + 2)

  rlbl2 = text(7, 1.5 / 2., '270 ' + string(197b), font_size = fs, /data, target = r1)

  rleg = legend(target = [r1, r2, r3], font_size = fs - 1, $
    th = th, pos = [7.43, 9.7 / 2.], /data)

  xtxt = text((x1 + x0 + dx + ddx) / 2., 0.02, align = 0.5, $
    'Log ( Temperature (K) )', $
    font_size = fs)

  w.save, 'plot_continuum_properties.png', width = 2 * xdim

  return, w
end
