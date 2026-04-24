function plot_context_image_v2, map = map
  compile_opt idl2

  ;+
  ; NAME:
  ;   plot_context_image_v2.pro
  ;
  ; PURPOSE:
  ;   Plot the context images for the flare, including AIA 131 and EIS Fe XXI 187.93, and the SW and LW continua. The plot is saved as the PNG
  ;
  ; INPUTS:
  ;   None.
  ;
  ; OUTPUTS:
  ;   Creates an IDL plot object, and saves it as the file plot_context_image_v2.jpg.
  ;
  ; MODIFCATION HISTORY:
  ;   Ver.1, 21-Apr-2026, Peter Young
  ;-

  if n_elements(map) eq 0 then begin
    file = eis_find_file('30-sep-2024 23:30', /lev)
    eis_make_image, file, 187.93, map, /map
    eis_make_image, file, 195.65, map_sw, /map
    eis_make_image, file, 269.66, map_lw, /map
  endif

  emap = map

  xoffset = 20
  yoffset = -8
  emap.xc = emap.xc + xoffset
  emap.yc = emap.yc + yoffset

  xr = [-500, -460] + xoffset
  yr = [-407, -342] + yoffset
  sub_map, emap, semap, xra = xr, yra = yr
  c = map_pix2coord(semap, 0, 0)
  xr[0] = c[0]
  yr[0] = c[1]

  aiadir = file_dirname(file_which('continuum_processing_script.pro'))
  aiadir = concat_dir(aiadir, 'data')
  aia_file = concat_dir(aiadir, 'aia.lev1_euv_12s.2024-09-30T235559Z.131.image.fits')

  amap = sdo2map(aia_file)
  sub_map, amap, samap, xra = [-510, -420], yra = [-450, -340]

  xdim = 700
  ydim = 850
  w = window(dim = [xdim, ydim])

  ddx = 0.07
  x0 = 0.10
  x1 = 0.56
  x2 = x1 + ddx
  x3 = 0.98
  y0 = 0.01
  y1 = 0.98
  dy = (y1 - y0) / 2.
  ddy = 0.05

  th = 2
  fs = 9
  xtl = 0.015
  ytl = 0.017

  samap.data = (samap.data > 0) ^ 0.3333
  p = plot_map_obj(samap, rgb_table = aia_rgb_table(131), $
    pos = [x0, y0 + ddy + dy, x1, y1], /current, $
    font_size = fs, $
    ymin = 1, xmin = 1, $
    xth = th, yth = th, $
    xtitle = '', ytitle = '', $
    xtickdir = 1, ytickdir = 1, $
    title = '', $
    xticklen = xtl, yticklen = ytl)

  pbox = plot(/overplot, [xr[0], xr[1], xr[1], xr[0], xr[0]], $
    [yr[0], yr[0], yr[1], yr[1], yr[0]], $
    th = th, color = 'yellow')

  tstr = anytim2utc(/ccsds, /time, /trunc, samap.time) + ' UT'
  ptxt = text(x0 + 0.04, y1 - 0.01, '(a) AIA 131 ' + string(197b) + ', ' + tstr, $
    font_size = fs, color = 'white', vertical_align = 1.0)

  ytl = 0.020
  semap.data = (semap.data > 0) ^ 0.3333
  q = plot_map_obj(semap, rgb_table = matplotlib_rgb_table(/inferno), $
    /current, dmin = 1.5, $
    pos = [x2, y0 + ddy + dy, x3, y1], $
    xth = th, yth = th, $
    font_size = fs, $
    ymin = 1, xmin = 1, $
    title = '', $
    xtitle = '', ytitle = '', $
    xtickdir = 1, ytickdir = 1, $
    xtickvalues = [-470, -460, -450, -440], $
    xticklen = xtl, yticklen = ytl)
  c = map_pix2coord(semap, 0, 0)
  ql = plot(/overplot, th = th, q.xrange, (c[1] + 18) * [1, 1], $
    color = 'white', linesty = '--')

  c = map_pix2coord(semap, 2, 21)

  x = make_array(6, /float, value = c[0])
  y = findgen(6) + c[1]

  qs = plot(x, y, linesty = 'none', symbol = 'square', $
    sym_size = 0.5, $
    sym_filled = 1, color = 'dodger blue', /overplot)

  qtxt = text(x2 + 0.045, y1 - 0.01, '(b) EIS Fe XXI 187.93 ' + string(197b) + '!c      23:41-23:59 UT', $
    font_size = fs, color = 'white', vertical_align = 1.0)

  ;
  ; BOTTOM ROW
  ; ==========
  x0 = -0.05
  x3 = 0.88
  dx = (x3 - x0) / 2.
  ddx = 0.15

  emap = map_sw
  emap.xc = emap.xc + xoffset
  emap.yc = emap.yc + yoffset

  xr = [-500, -460] + xoffset
  yr = [-407, -342] + yoffset
  sub_map, emap, semap, xra = xr, yra = yr
  c = map_pix2coord(semap, 0, 0)
  xr[0] = c[0]
  yr[0] = c[1]

  semap_save = semap

  ;
  ; get rid of missing data column.
  ;
  semap.data[13, *] = (semap.data[12, *] + semap.data[14, *]) / 2.

  semap.data = semap.data / 1000.

  ytl = 0.020
  ; semap.data=(semap.data>0)^0.3333
  r = plot_map_obj(semap, rgb_table = matplotlib_rgb_table(/viridis), $
    /current, $
    pos = [x0 + ddx, y0 + ddy, x0 + dx, y0 + dy], $
    xth = th, yth = th, $
    font_size = fs, $
    title = '', $
    xtitle = '', $
    ytitle = '', $
    ymin = 1, xmin = 1, $
    xtickdir = 1, ytickdir = 1, $
    xtickvalues = [-470, -460, -450, -440], $
    xticklen = xtl, yticklen = ytl)

  dxc = 0.02
  xoff_c = 0.01

  rc = colorbar(target = r, orientation = 1, /border_on, $
    thick = th, font_size = fs, $
    minor = 1, textpos = 1, $
    pos = [x0 + dx + xoff_c, y0 + ddy, x0 + dx + xoff_c + dxc, y0 + dy], $
    title = 'Intensity (x10!u3!n erg cm!u-2!n s!u-1!n sr!u-1!n ' + string(197b) + '!u-1!n)')

  rlbl = text(x0 + ddx + 0.025, y0 + dy - 0.01, '(c) SW continuum (195.65 ' + string(197b) + ')', $
    font_size = fs, color = 'white', vertical_align = 1.0)

  emap = map_lw
  emap.xc = emap.xc + xoffset
  emap.yc = emap.yc + yoffset

  xr = [-500, -460] + xoffset
  yr = [-407, -342] + yoffset
  sub_map, emap, semap, xra = xr, yra = yr
  c = map_pix2coord(semap, 0, 0)
  xr[0] = c[0]
  yr[0] = c[1]

  semap_save.data = 0.
  semap_save.data[*, 18 : *] = semap.data
  semap = semap_save

  semap.data = semap.data / 1000.

  ytl = 0.020
  ; semap.data=(semap.data>0)^0.3333
  s = plot_map_obj(semap, rgb_table = matplotlib_rgb_table(/viridis), $
    /current, $
    pos = [x0 + dx + ddx, y0 + ddy, x0 + 2 * dx, y0 + dy], $
    xth = th, yth = th, $
    font_size = fs, $
    title = '', $
    ytitle = '', $
    ymin = 1, xmin = 1, $
    xtickdir = 1, ytickdir = 1, $
    xtitle = '', $
    xtickvalues = [-470, -460, -450, -440], $
    xticklen = xtl, yticklen = ytl)

  sc = colorbar(target = s, orientation = 1, /border_on, $
    thick = th, font_size = fs, $
    minor = 1, textpos = 1, $
    pos = [x0 + 2 * dx + xoff_c, y0 + ddy, x0 + 2 * dx + xoff_c + dxc, y0 + dy], $
    title = 'Intensity (x10!u3!n erg cm!u-2!n s!u-1!n sr!u-1!n ' + string(197b) + '!u-1!n)')

  slbl = text(x0 + dx + ddx + 0.025, y0 + dy - 0.01, '(d) LW continuum (269.66 ' + string(197b) + ')', $
    font_size = fs, color = 'white', vertical_align = 1.0)

  xt = text(0.5, 0.01, 'X (arcsec)', font_size = fs + 1, $
    align = 'center')

  yt = text(0.02, y0 + ddy + (2 * dy - ddy) / 2., orient = 90, align = 0.5, $
    font_size = fs + 1, 'Y (arcsec)')

  w.save, 'plot_context_image_v2.jpg', width = 2 * xdim

  return, w
end
