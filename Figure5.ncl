load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
;
begin
  fold=addfile("WRF_v-field.nc","r")

;
  lat2d = f->lat2d
  lon2d = f->lon2d
  dimll = dimsizes(lat2d)
  nlat  = dimll(0)
  mlon  = dimll(1)


;
 date=6*4+5
; date=7

 vold_500      = f->vold
 vnew_500      = f->vnew
 
 
 printVarSummary(slpold)
;
  wks_type="x11"
  ;wks_type@wkWidth=5000
  ;wks_type@wkHeight=5000
wks=gsn_open_wks(wks_type,"cross_section_speeddiff")
res=True
res@gsnDraw=False
res@gsnFrame=False
res@gsnMaximize=True
res@cnLinesOn=False
res@cnFillOn=True
  res@mpGeophysicalLineColor = "Black"
  res@mpGeophysicalLineThicknessF = 10.0
res@tmXBLabelFontHeightF    = 0.02     ;set the size of x-Axis words
res@tmYLLabelFontHeightF    = 0.02    ;set the size of y-Axis words
res@lbTitleFontHeightF         = 0.025
res@lbLabelFontHeightF         = 0.025
;res@lbTopMarginF              = 0.0
res@tiMainFontHeightF                 = 0.03
res@tiMainFontThicknessF          =0.5
res@tiMainFont           =21
;res@gsnRightString             ="m/s"
res@lbOrientation        = "vertical"
;
res = wrf_map_resources(fold,res)
Xstart       =200
Xend         =400
Ystart       =250
Yend         =450
res@ZoomIn=True
res@Xstart   =Xstart
res@Xend     =Xend
res@Ystart   =Ystart
res@Yend     =Yend
res = wrf_map_resources(fold,res)
;
res@lbAutoManage         = False
res@cnLevelSelectionMode="ExplicitLevels"
;
  res@tfDoNDCOverlay      = True          ; Tell NCL you are doing a native plot
  res@gsnAddCyclic        = False
;
;print(res@Ystart)

vold_500zoom=vold_500(Ystart:Yend,Xstart:Xend)
vnew_500zoom=vnew_500(Ystart:Yend,Xstart:Xend)

;
plot=new(2,graphic)

delete(res@cnLevels)
res@tiMainString="New-operational (Pressure difference, hPa)"
res@tiMainString="Friction velocity difference (m/s)"
res@tiMainString="100-m longitudinal wind difference (m/s)"
res@lbAutoManage         = False
res@lbTitleOn               = True
res@lbTitleString              = ""
res@lbTitleFontHeightF         = 0.025                 ; make title smaller
res@lbTitlePosition            = "Right"            ; title position
res@lbTitleDirection           = "Across"            ; title direction
res@lbLabelFontHeightF         = 0.022
res@lbTitleAngleF              = 270
res@cnFillPalette       = "BlueWhiteOrangeRed"
res@cnLevels=fspan(-10,10,11)
plot1=gsn_csm_contour_map(wks,vnew_500zoom-vold_500zoom,res) 


  draw(plot1)                                  ; draw the temperature plot (with the U-wind plot overlaid)
  frame(wks)





;
pres                 = True
 pres@gsnPanelRowSpec = True                   ; tell panel what order to plot

 pres@gsnPanelCenter  = False
;gsn_panel(wks,plot,(/2,2/),pres)


end
