
PRO write_latex_line_list, version

;+
; NAME:
;     WRITE_LATEX_LINE_LIST
;
; PURPOSE:
;     Writes the line list in Table 1 of the paper.
;
; INPUTS:
;     None.
;
; OUTPUTS:
;     Writes a latex table (line_list_v1.tex) that is inserted into
;     the Overleaf article.
;
; MODIFICATION HISTORY:
;     Ver.1, 24-Apr-2026
;-

  ;
  ; This is the location where the data files are.
  ;
  datadir = file_dirname(file_which('continuum_processing_script.pro'))
  datadir = concat_dir(datadir, 'data')

IF n_elements(version) EQ 0 THEN version='v1'

CASE version OF
  'v0': BEGIN
    dem_savefile=concat_dir(datadir,'mcmc_dem_calib0.sav')
    outfile='line_list_v0.tex'
  END
  ELSE: BEGIN
    dem_savefile=concat_dir(datadir,'mcmc_dem_calib_v1.sav')
    outfile='line_list_v1.tex'
  END
ENDCASE 

restore,dem_savefile
line_data=output.line_data

n=n_elements(line_data)

logt_max=string(format='(f4.2)',line_data.logt_max)
sort_string=logt_max+'_'+output.line_data.ion

k=sort(sort_string)
line_data=line_data[k]

openw,lout,outfile,/get_lun

FOR i=0,n-1 DO BEGIN
  name=ch_latex_name(line_data[i].ion)
  s=ch_dem_process_index_string(line_data[i].index)
  ch_dem_get_wvl_aval,line_data[i].ion, s.lower[0],s.upper[0], wvl, aval
  err=sqrt(line_data[i].err^2 + (output.interr_scale*line_data[i].int)^2 )
  errors,line_data[i].model_int,0.,line_data[i].int,err,ratio,ratio_err,/silent
  printf,lout,format='(a15," & ",f10.3," & ",f10.3," && $",f7.1," \pm ",f7.1,"$ & ",f7.1," & $",f7.2," \pm ",f7.2,"$ & ",f6.2," & ",f6.2,"\\")', $
         name, $
         wvl, $
         line_data[i].obs_wvl, $
         line_data[i].int, $
         err, $
         line_data[i].model_int, $
         ratio,ratio_err, $
         line_data[i].logt_max, $
         line_data[i].logt_eff
         
ENDFOR 

free_lun,lout

message,/info,/cont,'Created the file '+outfile+'.'

END
