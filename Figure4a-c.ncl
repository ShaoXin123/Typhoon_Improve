load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
;
begin
  fold=addfile("WRF_ustar&wind-field.nc","r")

;
  lat2d = f->lat2d
  lon2d = f->lon2d
  dimll = dimsizes(lat2d)
  nlat  = dimll(0)
  mlon  = dimll(1)

;
 date=6*4+5

 ustarnew = f->ustarnew
 ustarold = f->ustarold

 windold_500      = f->windold
 windnew_500      = f->windnew 

 
 

;
  wks_type="x11"
  ;wks_type@wkWidth=5000
  ;wks_type@wkHeight=5000
wks=gsn_open_wks(wks_type,"cross_section_speedustar")
res=True
res@gsnDraw=False
res@gsnFrame=False
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
Xstart       =215
Xend         =415
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
windold_500zoom=windold_500(Ystart:Yend,Xstart:Xend)
windnew_500zoom=windnew_500(Ystart:Yend,Xstart:Xend)
ustaroldzoom=ustarold(Ystart:Yend,Xstart:Xend)
ustarnewzoom=ustarnew(Ystart:Yend,Xstart:Xend)

;
plot=new(4,graphic)
;res@tiMainString="u*~B~new~N~-u*~B~old~N~"
;res@tiMainString="New-operational (Pressure difference, hPa)"
;res@tiMainString="Friction velocity difference (m/s)"
;res@tiMainString="10-m longitudinal wind difference (m/s)"
res@lbAutoManage         = False
res@lbTitleOn               = True
res@lbTitleString              = ""
res@lbTitleFontHeightF         = 0.025                 ; make title smaller
res@lbTitlePosition            = "Right"            ; title position
res@lbTitleDirection           = "Across"            ; title direction
res@lbLabelFontHeightF         = 0.022
res@lbTitleAngleF              = 270
res@cnFillPalette       = "BlueWhiteOrangeRed"
;res@cnFillPalette       = "WhiteYellowOrangeRed"


res@tiMainString="Momentum Flux Difference (m~S~2~N~/s~S~2~N~)"
res@cnLevels=fspan(-1,1,11)
plot(0)=gsn_csm_contour_map(wks,ustarnewzoom-ustaroldzoom,res) 

;res@cnFillPalette       = "WhiteYellowOrangeRed"
delete(res@cnLevels)
res@tiMainString="300-m wind (New Formula, m/s)"
res@cnLevels=fspan(0,30,16)
plot(2)=gsn_csm_contour_map(wks,windnew_500zoom*1,res)

;res@cnFillPalette       = "WhiteYellowOrangeRed"
res@tiMainString="300-m wind (Operational, m/s)"
delete(res@cnLevels)
res@cnLevels=fspan(0,30,16)
plot(3)=gsn_csm_contour_map(wks,windold_500zoom*1,res)


;
  gsres                = True
  gsres@gsMarkerSizeF = 0.015               ; default - 0.007
  gsres@gsMarkerThicknessF   = 10
gsres@gsMarkerIndex  = 16                  ; filled dot
gsres@gsMarkerColor  = 1
dothangzhou0=gsn_add_polymarker(wks,plot(2),120.946,30.462,gsres)
dothangzhou1=gsn_add_polymarker(wks,plot(3),120.946,30.462,gsres)
gsres@gsMarkerColor  = 234



;
pres                 = True
 pres@gsnPanelRowSpec = True                   ; tell panel what order to plot

 pres@gsnPanelCenter  = False
 pres@gsnPanelFigureStrings            = (/"(a)","(b)","(c)","(d)"/)
 ;pres@amJust   =    "TopLeft"
 pres@amOrthogonalPosF=-0.5
 pres@amParallelPosF=-0.5
 pres@gsnPanelFigureStringsPerimOn=False
gsn_panel(wks,plot,(/2,2/),pres)


end
