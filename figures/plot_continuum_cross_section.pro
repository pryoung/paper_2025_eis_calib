function plot_continuum_cross_section
  compile_opt idl2

  ;+
  ; NAME:
  ;    PLOT_CONTINUUM_CROSS_SECTION
  ;
  ; PURPOSE:
  ;    Plot an intensity cross-section along the slit that includes
  ;    the flare location.
  ;
  ; INPUTS:
  ;    None.
  ;
  ; OUTPUTS:
  ;    Creates an IDL plot object and saves it as the file
  ;    plot_continuum_cross_section.png in the local directory.
  ;
  ; MODIFICATION HISTORY:
  ;    Ver.1, 22-Apr-2026, Peter Young
  ;-

  ;
  ; This is the location where the data files are.
  ;
  datadir = file_dirname(file_which('continuum_processing_script.pro'))
  datadir = concat_dir(datadir, 'data')

  restore, concat_dir(datadir, '20240930_225718_continuum_bg.sav')
  mask_bg = mask
  restore, concat_dir(datadir, '20240930_225718_continuum_spec.sav')

  file = 'eis_l1_20240930_225718.fits.gz'
  chck = file_info(file)
  if chck.exists eq 0 then begin
    message, /info, /cont, 'You need to calibrate the EIS level-0 file (eis_l0_20240930_225718.fits) into photon units and put the fits file in the working directory.'
    return, -1
  end
  wd = eis_getwindata(file, 195, /refill)

  getmin = min(abs(wd.wvl - 195.79), imin)
  img195 = average(wd.int[imin - 3 : imin + 3, *, *], 1, missing = wd.missing)

  xdim = 600
  ydim = 400
  w = window(dim = [xdim, ydim])

  s = size(mask.image, /dim)
  y = indgen(s[1])

  int = reform(img195[2, *])

  th = 2
  fs = 12
  xtl = 0.015
  ytl = 0.015

  p = plot(y, int, $
    /stairstep, $
    th = th, yth = th, xth = th, $
    xra = [0, 100], /xsty, $
    font_size = fs, /current, $
    xticklen = xtl, yticklen = ytl, $
    pos = [0.125, 0.12, 0.97, 0.98], $
    ymin = 1, xtitle = 'y pixel position', $
    ytitle = 'Detected photons (s!u-1!n pix!u-1!n)')

  mask_bg_col = reform(mask_bg.image[2, *])
  mask_col = reform(mask.image[2, *])

  k = where(mask_bg_col eq 1)
  int_mask_bg = int - int
  int_mask_bg[k] = int[k]

  print, format = '("Mean intensity in background: ",f7.1)', mean(int_mask_bg[k])

  k = where(mask_col eq 1)
  int_mask = int - int
  int_mask[k] = int[k]

  print, format = '("Mean intensity in flare: ",f7.1)', mean(int_mask[k])

  q = plot(/overplot, y, int_mask, fill_background = 1, fill_color = 'dodger blue', /stairstep, $
    th = th)
  r = plot(/overplot, y, int_mask_bg, fill_background = 1, fill_color = 'salmon', /stairstep, $
    th = th)

  w.save, 'plot_continuum_cross_section.png', width = 2 * xdim

  return, w
end
