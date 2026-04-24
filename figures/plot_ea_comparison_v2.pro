function plot_ea_comparison_v2
  compile_opt idl2

  ;+
  ; NAME:
  ;    PLOT_EA_COMPARISON_V2
  ;
  ; PURPOSE:
  ;    Creates a six-panel plot. Panels (a) and (b) compare the new effective
  ;    area curves for the SW and LW channels with those of Del Zanna et al.
  ;    (2025) and the pre-launch curves. Panels (c) and (d) plot the ratios of
  ;    the new curves to DZWW25, and panels (e) and (f) plot the ratios of
  ;    relative to the pre-launch curves.
  ;
  ; INPUTS:
  ;    None.
  ;
  ; OUTPUTS:
  ;    Creates an IDL plot object and saves it as the file
  ;    plot_ea_comparison_v2.png in the local directory.
  ;
  ; MODIFICATION HISTORY:
  ;    Ver.1, 23-Apr-2026, Peter Young
  ;-

  xdim = 850
  ydim = 550
  w = window(dim = [xdim, ydim])

  x0 = 0.015
  x1 = 0.99
  dx = (x1 - x0) / 2.
  ddx = 0.06
  y0 = 0.08
  y1 = 0.28
  y2 = 0.45
  y3 = 0.98

  th = 2
  fs = 11
  xtl = 0.015
  xtl2 = 0.040
  ytl = 0.015

  ;
  ; Left panel: SW
  ; --------------
  wvl = findgen(38) + 175.
  ea_new = read_effective_area(wvl)

  p1 = plot(wvl, ea_new * 100., th = th + 1, color = color_tol('orange'), $
    /xsty, /current, font_size = fs, $
    pos = [x0 + ddx, y2, x0 + dx, y3], $
    ytitle = 'Effective area (mm!u2!n)', $
    xth = th, yth = th, xticklen = xtl, yticklen = ytl, $
    yrange = [0, 20], $
    xmin = 4, $
    xshowtext = 0, $
    /ysty, name = 'New')

  ea_pre = eis_eff_area(wvl)
  p2 = plot(wvl, ea_pre * 100. * 0.55, $
    th = th, color = 'blue', $
    linesty = '--', $
    /overplot, name = 'PL x0.55')

  ea_gdz = interpol_eis_ea('30-sep-2024', wvl)
  p3 = plot(wvl, ea_gdz * 100, th = th, /overplot, name = 'DZWW25')

  pt1 = text(x0 + ddx + 0.015, y3 - 0.03, vertical_align = 1.0, $
    '(a) SW', font_size = fs + 1)

  ;
  ; Plot ratio of effective areas
  ;
  p4 = plot(wvl, ea_new / ea_gdz, th = th, /current, $
    pos = [x0 + ddx, y1, x0 + dx, y2], $
    yrange = [0.45, 1.55], /ysty, /xsty, $
    font_size = fs, $
    xmin = 4, ymin = 0, $
    xshowtext = 0, $
    xth = th, yth = th, xticklen = xtl2, yticklen = ytl, $
    ytitle = 'Ratio')
  p4l = plot(/overplot, p1.xrange, [1, 1], linesty = ':', th = th)

  pt2 = text(x0 + ddx + 0.015, y2 - 0.015, vertical_align = 1.0, $
    '(c) New/DZWW25', font_size = fs + 1)

  k = where(wvl eq 195.)
  ratio_ref = ea_new[k] / ea_pre[k]

  p5 = plot(wvl, ea_new / ea_pre, th = th, /current, $
    pos = [x0 + ddx, y0, x0 + dx, y1], $
    yrange = [ratio_ref * 0.45, ratio_ref * 1.55], /ysty, /xsty, $
    font_size = fs, $
    xmin = 4, ymin = 0, $
    xth = th, yth = th, xticklen = xtl2, yticklen = ytl, $
    ytitle = 'Ratio')
  p5l = plot(/overplot, p1.xrange, [1, 1], linesty = ':', th = th)

  pt3 = text(x0 + ddx + 0.015, y1 - 0.015, vertical_align = 1.0, $
    '(e) New/PL', font_size = fs + 1)

  pleg = legend(target = [p1, p2, p3], font_size = fs - 1, $
    th = th, pos = [200.5, 6], /data, sample_width = 0.08)

  k = where(wvl ge 180 and wvl le 210)
  print, format = '("Minmax of SW ratio: ",2f10.3)', minmax(ea_new[k] / ea_gdz[k])

  ;
  ; Right panel: LW
  ; ----------------
  wvl = findgen(47) + 246.
  ea_new = read_effective_area(wvl)

  q1 = plot(wvl, ea_new * 100, th = th + 1, color = color_tol('orange'), $
    /xsty, /current, font_size = fs, $
    pos = [x0 + dx + ddx, y2, x0 + 2 * dx, y3], $
    xth = th, yth = th, xticklen = xtl, yticklen = ytl, $
    xmin = 4, $
    ymin = 1, $
    xshowtext = 0, $
    yra = [0, 4.5], $
    /ysty, name = 'New')

  ea_pre = eis_eff_area(wvl)
  q2 = plot(wvl, ea_pre * 100. * 0.30, $
    linesty = '--', $
    th = th, color = 'blue', /overplot, name = 'PL x0.30')

  ea_gdz = interpol_eis_ea('30-sep-2024', wvl)
  q3 = plot(wvl, ea_gdz * 100, th = th, /overplot, name = 'DZWW25')

  qt1 = text(x0 + dx + ddx + 0.015, y3 - 0.03, vertical_align = 1.0, $
    '(b) LW', font_size = fs + 1)

  q4 = plot(wvl, ea_new / ea_gdz, th = th, /current, $
    pos = [x0 + dx + ddx, y1, x0 + 2 * dx, y2], $
    yrange = [0.45, 1.55], /ysty, /xsty, $
    xmin = 4, $
    ymin = 0, $
    font_size = fs, $
    xshowtext = 0, $
    xth = th, yth = th, xticklen = xtl2, yticklen = ytl)
  q4l = plot(/overplot, q1.xrange, [1, 1], linesty = ':', th = th)

  getmax = max(ea_new / ea_gdz, imax)
  print, format = '("LW: max New/DZWW25 ratio: ",f6.2," (",f6.2,")")', getmax, wvl[imax]
  getmin = min(ea_new / ea_gdz, imin)
  print, format = '("LW: min New/DZWW25 ratio: ",f6.2," (",f6.2,")")', getmin, wvl[imin]

  ratio_ref = 0.27

  q5 = plot(wvl, ea_new / ea_pre, th = th, /current, $
    pos = [x0 + dx + ddx, y0, x0 + 2 * dx, y1], $
    yrange = [ratio_ref * 0.45, ratio_ref * 1.55], /ysty, /xsty, $
    font_size = fs, $
    xmin = 4, ymin = 0, $
    ytitle = '', $
    xth = th, yth = th, xticklen = xtl2, yticklen = ytl)
  q5l = plot(/overplot, q1.xrange, [1, 1], linesty = ':', th = th)

  xt = text(x0 + ddx + (2 * dx - ddx) / 2., 0.005, font_size = fs, align = 0.5, $
    'Wavelength (' + string(197b) + ')')

  pt2 = text(x0 + dx + ddx + 0.015, y2 - 0.015, vertical_align = 1.0, $
    '(d) New/DZWW25', font_size = fs + 1)

  pt3 = text(x0 + dx + ddx + 0.015, y1 - 0.04, vertical_align = 1.0, $
    '(f) New/PL', font_size = fs + 1)

  qleg = legend(target = [q1, q2, q3], font_size = fs - 1, $
    th = th, pos = [276, 1.5], /data, sample_width = 0.08)

  w.save, 'plot_ea_comparison_v2.png', width = 2 * xdim
  return, w
end
