function plot_dark_current
  compile_opt idl2

  ;+
  ; NAME:
  ;    PLOT_DARK_CURRENT
  ;
  ; PURPOSE:
  ;    This is a 4-panel plot showing how the dark current varies in wavelength and y
  ;    for the two detectors.
  ;
  ; INPUTS:
  ;    None.
  ;
  ; OUTPUTS:
  ;    Creates an IDL plot object and saves it as the file
  ;    plot_dark_current.png in the local directory.
  ;
  ; MODIFICATION HISTORY:
  ;    Ver.1, 23-Apr-2026, Peter Young
  ;-

  datadir = file_dirname(file_which('continuum_processing_script.pro'))
  datadir = concat_dir(datadir, 'data')

  xdim = 900
  ydim = 600
  w = window(dim = [xdim, ydim])

  x0 = 0.02
  x1 = 0.99
  dx = (x1 - x0) / 2.
  ddx = 0.05
  y0 = -0.02
  y1 = 0.98
  dy = (y1 - y0) / 2.
  ddy = 0.09

  th = 2
  fs = 10
  xtl = 0.018
  ytl = 0.015

  extra = {thick: th, $
    xthick: th, $
    ythick: th, $
    xticklen: xtl, $
    yticklen: ytl, $
    xtickdir: 1, $
    ytickdir: 1, $
    xstyle: 1, $
    ystyle: 1, $
    xminor: 4, $
    yminor: 1, $
    yrange: [-2, 2], $
    xtitle: '', $
    font_size: fs}

  restore, concat_dir(datadir, 'data_wvl_sw.sav')
  extra.xtitle = data.xtitle
  ;
  p = plot(data.x, data.y, /stairstep, /current, $
    pos = [x0 + ddx, y0 + dy + ddy, x0 + dx, y0 + 2 * dy], $
    ytitle = data.ytitle, $
    _extra = extra)
  pt = text(x0 + ddx + 0.02, y1 - 0.01, '(a)', $
    font_size = fs, vertical_align = 1.0)

  restore, concat_dir(datadir, 'data_wvl_lw.sav')
  ;
  q = plot(data.x, data.y, /stairstep, /current, $
    pos = [x0 + dx + ddx, y0 + dy + ddy, x0 + 2 * dx, y0 + 2 * dy], $
    _extra = extra)
  qt = text(x0 + dx + ddx + 0.02, y1 - 0.01, '(b)', $
    font_size = fs, vertical_align = 1.0)

  ; ------
  restore, concat_dir(datadir, 'data_y_sw.sav')
  extra.xtitle = data.xtitle
  ;
  s = plot(data.x, data.y, /stairstep, /current, $
    pos = [x0 + ddx, y0 + ddy, x0 + dx, y0 + dy], $
    ytitle = data.ytitle, $
    _extra = extra)
  st = text(x0 + ddx + 0.02, y0 + dy - 0.01, '(c)', $
    font_size = fs, vertical_align = 1.0)

  restore, concat_dir(datadir, 'data_y_lw.sav')
  extra.xtitle = data.xtitle
  ;
  r = plot(data.x, data.y, /stairstep, /current, $
    pos = [x0 + dx + ddx, y0 + ddy, x0 + 2 * dx, y0 + dy], $
    _extra = extra)
  rt = text(x0 + dx + ddx + 0.02, y0 + dy - 0.01, '(d)', $
    font_size = fs, vertical_align = 1.0)

  w.save, 'plot_dark_current.png', width = 2 * xdim

  return, w
end
