;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
;



undef("read_ocean_land_colormap")
function read_ocean_land_colormap(num_ocean)
local cmap_ocn, cmap_lnd
begin
  cmap_ocn = read_colormap_file("GMT_ocean")
  cmap_lnd = read_colormap_file("OceanLakeLandSnow")
  newcmap = array_append_record(cmap_ocn(0:num_ocean-1,:),cmap_lnd(2::2,:),0)
  return(newcmap)
end
;
undef("read_elev_data")
function read_elev_data(topo_file)
local nlat, nlon, topo_file, lat, lon
begin
;---Read data as a straight binary file
  nlat = 2160
  nlon = 4320
  setfileoption("bin","ReadByteOrder","BigEndian")
  elev = cbinread(topo_file,(/nlat,nlon/),"short")

;---Create 1D coordinate arrays
  lat       = fspan(90,-90,nlat)
  lon       = fspan(0,360,nlon)
  lat!0     = "lat"
  lon!0     = "lon"
  lat@units = "degrees_north"
  lon@units = "degrees_east"
  lat&lat   = lat
  lon&lon   = lon

;---Attach the coordinate arrays
  elev!0    = "lat"
  elev!1    = "lon"
  elev&lat  = lat
  elev&lon  = lon
 
  return(elev)
end
;
undef("calc_levels_and_colors")
function calc_levels_and_colors(wks,emin,emax,split_elev,num_ocean_values)
local start_ocean, ocean_range, land_range, olevels, llevels, nol, nll, clen
begin
  cmap = read_ocean_land_colormap(num_ocean_values)
  clen = dimsizes(cmap(:,0))

  start_ocean = 0
  end_ocean   = num_ocean_values-1
  start_land  = end_ocean+1
  ocean_range = end_ocean-start_ocean+1
  land_range  = clen-start_land+1
  olevels     = fspan(emin,split_elev,ocean_range)
  llevels     = fspan(split_elev,emax,land_range)
  nol         = dimsizes(olevels)
  nll         = dimsizes(llevels)
  levels      = new((nol-1)+(nll-2),float)
  levels(0:nol-2) = olevels(1:)
  levels(nol-1:)  = llevels(1:nll-2)
  return([/levels,cmap/])
end





begin
do tforwrf=1,1
  date = (/1512,1515,1518,1521,1600,1603,1606,1609,1612,1615,1618,1621,1700,1703,1706,1709,1712/)
 ; ndatestart=((dimsizes(date)+1)/2)*3-2
  ndatestart=6
  ndateobs=(19+1)/2
;
  sdate = sprinti("%4.0i",date)
if(tforwrf .eq. 1) then
  fold = addfile("old/mynnera5_lekima/wrfout_d03_2019-08-08_18:00:00","r")
  fnew = addfile("new/mynnera5_lekima/wrfout_d03_2019-08-08_18:00:00","r")
end if
if(tforwrf .eq. 1) then
  fold = addfile("old/mynnera5_lekima/wrfout_d03_2019-08-09_06:00:00","r")
  fnew = addfile("new/mynnera5_lekima/smallerz0/wrfout_d03_2019-08-09_06:00:00","r")
end if
if(tforwrf .eq. 2) then
  fold = addfile("old/mynnera5_lekima/wrfout_d03_2019-08-09_18:00:00","r")
  fnew = addfile("new/mynnera5_lekima/smallerz0/wrfout_d03_2019-08-09_18:00:00","r")
end if
 ; 
  lat2d = fold->XLAT(0,:,:)
  lon2d = fold->XLONG(0,:,:)
  dimll = dimsizes(lat2d)
  nlat  = dimll(0)
  mlon  = dimll(1)
;
 timewrf=wrf_user_list_times(fold)
 ndate=dimsizes(timewrf)
 slpold = wrf_user_getvar(fold,"slp",0)
 slpnew = wrf_user_getvar(fnew,"slp",0)
  dims = dimsizes(slpnew)
  time = new(ndate,string)
  iminold = new(ndate,integer)
  jminold = new(ndate,integer)
  sminold = new(ndate,integer)
  iminnew = new(ndate,integer)
  jminnew = new(ndate,integer)
  sminnew = new(ndate,integer)
  iminobs = new(ndateobs,float)
  jminobs = new(ndateobs,float)
;
  do ifs=0,ndate-1
    time(ifs) =timewrf(ifs)
    slp2dold = wrf_user_getvar(fold,"slp",ifs)
    slp2dnew = wrf_user_getvar(fnew,"slp",ifs)
;p  = wrf_user_getvar(fold, "pressure",ifs)  
;hgt=wrf_user_getvar(fold, "geopotential",ifs)
;slp2dold = wrf_user_intrp3d(hgt,p,"h",700,0.,False)
;p  = wrf_user_getvar(fnew, "pressure",ifs)
;hgt=wrf_user_getvar(fnew, "geopotential",ifs)
;slp2dnew = wrf_user_intrp3d(hgt,p,"h",700,0.,False)
;delete(p)
;delete(hgt)
;
    slp1dold     = ndtooned(slp2dold)
    sminold(ifs) = minind(slp1dold)
    slp1dnew     = ndtooned(slp2dnew)
    sminnew(ifs) = minind(slp1dnew)
;   
   if(ifs .eq. 0) then
       minij     = ind_resolve(ind(slp1dold.eq.min(slp2dold)),dims)
       iminold(ifs) = minij(0,0)
       jminold(ifs) = minij(0,1)
       slp2dold(iminold(ifs),jminold(ifs))=slp2dold@_FillValue
   end if
;
print(ifs)
    minij     = ind_resolve(ind(slp1dold.eq.min(slp2dold)),dims)
    iminold(ifs) = minij(0,0)
    jminold(ifs) = minij(0,1)
    delete(minij)
    minij     = ind_resolve(ind(slp1dnew .eq. min(slp2dnew)),dims)
    iminnew(ifs) = minij(0,0)
    jminnew(ifs) = minij(0,1)
    delete(minij)
   if(ifs .eq. 0) then
       minij     = ind_resolve(ind(slp1dold.eq.min(slp2dold(20:mlon-20,20:nlat-20))),dims)
       iminold(ifs) = minij(0,0)
       jminold(ifs) = minij(0,1)
       minij     = ind_resolve(ind(slp1dnew.eq.min(slp2dnew(20:mlon-20,20:nlat-20))),dims)
       iminnew(ifs) = minij(0,0)
       jminnew(ifs) = minij(0,1)
       sminold(ifs) = ind(slp1dold.eq.min(slp2dold(20:mlon-20,20:nlat-20)))
       sminnew(ifs) = ind(slp1dnew.eq.min(slp2dnew(20:mlon-20,20:nlat-20)))
   end if
    sminold(0)=sminold(1)
    sminnew(0)=sminnew(1)
    iminold(0)=iminold(1)
    iminnew(0)=iminnew(1)
    jminold(0)=jminold(1)
    jminnew(0)=jminnew(1)
  end do
  if(tforwrf .eq. 2) then
    sminold(ndate-1)=sminold(ndate-3)
    sminnew(ndate-1)=sminnew(ndate-3)
    iminold(ndate-1)=iminold(ndate-3)
    iminnew(ndate-1)=iminnew(ndate-3)
    jminold(ndate-1)=jminold(ndate-3)
    jminnew(ndate-1)=jminnew(ndate-3)
  end if
;
if(tforwrf .eq. 1) then
  sminnew(6*7)=sminnew(6*7+5)
  iminnew(6*7)=iminnew(6*7+5)
  jminnew(6*7)=jminnew(6*7+5)
    sminnew(ndate-1)=sminnew(ndate-1)-2
    iminnew(ndate-1)=iminnew(ndate-1)-2
    jminnew(ndate-1)=jminnew(ndate-1)-2
end if
  printVarSummary(slp2dold)
delete([/slp1dold,slp1dnew,slp2dold,slp2dnew/])
  ; 
;mangkhut
iminobs(0) = 118.6
jminobs(0) = 19.3
iminobs(1) = 117.1
jminobs(1) = 19.6
iminobs(2) = 115.8
jminobs(2) = 20.4
iminobs(3) = 113.8
jminobs(3) = 21.4
iminobs(4) = 112.0
jminobs(4) = 21.9
iminobs(5) = 110.1
jminobs(5) = 22.4
iminobs(6) = 108.8
jminobs(6) = 22.8
iminobs(7) = 107.6
jminobs(7) = 23.5
iminobs(8) = 106.6
jminobs(8) = 24
;lekima
iminobs(0) = 122.6
jminobs(0) = 27
iminobs(1) = 122
jminobs(1) = 27.5
iminobs(2) = 121.4
jminobs(2) = 28.3
iminobs(3) = 120.8
jminobs(3) = 28.9
iminobs(4) = 120.3
jminobs(4) = 29.9
iminobs(5) = 120.3
jminobs(5) = 30.7
iminobs(6) = 120.4
jminobs(6) = 31.7
iminobs(7) = 120.2
jminobs(7) = 33.6
iminobs(8) = 119.9
jminobs(8) = 34.8
iminobs(9) = 120.2
jminobs(9) = 35.8
;
if(tforwrf .eq. 1) then
  wks_type="png"
  wks_type@wkWidth=5000
  wks_type@wkHeight=5000
  wks=gsn_open_wks(wks_type,"track2")              ; Open PS file.
end if
  gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; Change color map.
;
  res                     = True
  res@gsnDraw             = False             ; Turn off draw.
  res@gsnFrame            = False             ; Turn off frame advance.
  res@gsnMaximize         = True              ; Maximize plot in frame.
    res@tiMainFont        = "helvetica"
  res@tiMainString = "Typhoon Lekima"       ; Main title
   res@tiMainFontHeightF=0.025
res@mpMaxLatF=40
res@mpMinLatF=25
res@mpMaxLonF=127.5
res@mpMinLonF=112.5
res@mpFillOn                    = False        ; turn off gray fill
  res@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
;  res@mpGeophysicalLineColor      = "Navy"       ; color of cont. outlines
  res@mpGeophysicalLineThicknessF = 1.5          ; thickness of outlines
;res@tiYAxisString="Latitude"
;res@tiXAxisString="Longitude"
res@pmTickMarkDisplayMode = "Always"
res@tmXBLabelFontHeightF    = 0.016     ;set the size of x-Axis words
res@tmYLLabelFontHeightF    = 0.016    ;set the size of y-Axis words
;
;  WRF_map_c(fold,res,0)                          ; Set up map resources
; res = wrf_map_resources(fold,res)


 ;
if(tforwrf .eq. 1) then                                             ;    (plot options)
  plot = gsn_csm_map(wks,res)                 ; Create a map.
  elev = read_elev_data("ETOPO5.DAT")
  ;---Set some plot options
;  res                    = True
  res@gsnMaximize        = True             ; maximize plot in frame
  res@cnFillOn           = True             ; turn on contour fill
  res@cnLevelSpacingF    = 125              ; NCL picks 2000
  res@cnFillMode         = "RasterFill"     ; much faster than AreaFill
  res@cnLinesOn          = False            ; turn off contour lines
  res@cnLineLabelsOn     = False            ; turn off line labels
  res@cnInfoLabelOn      = False            ; turn off info label
  res@lbBoxLinesOn       = False            ; turn off labelbar box lines
  res@gsnAddCyclic       = False            ; don't add longitude cyclic point
  res@mpFillOn           = False            ; turn off map fill
  ;res@tiMainString       = "ETOPO5.DAT"     ; main title
;  res@pmLabelBarWidthF   = 0.8              ; default is too short
res@lbOrientation = "vertical"  
res@cnLevelSelectionMode="ExplicitLevels"
res@cnFillPalette       = "BlueWhiteOrangeRed"
res@cnFillPalette       = "WhiteYellowOrangeRed"
res@lbBoxEndCapStyle     = "TriangleBothEnds"
res@lbAutoManage         = False
res@lbTitleOn               = True
res@lbTitleString              = "Altitude (m)"
res@lbTitleFontHeightF         = 0.025                 ; make title smaller
res@lbTitlePosition            = "Right"            ; title position
res@lbTitleDirection           = "Across"            ; title direction
res@lbLabelFontHeightF         = 0.022
res@lbTitleAngleF              =90
res@cnLevels=ispan(0,1000,100)
  plot = gsn_csm_contour_map(wks,elev({10:40},{100:125}),res)
end if
;
; Set up resources for polymarkers.
  gsres                = True
  gsres@gsMarkerIndex  = 16                  ; filled dot
  gsres@gsMarkerSizeF = 0.015               ; default - 0.007
  gsres@gsMarkerThicknessF   = 30
  cols                  = (/5,160,1/)
;
; Set up resources for polylines.
  res_lines                      = True
  res_lines@gsLineThicknessF     = 30.           ; 3x as thick
;
if(tforwrf .eq. 1) then
  dotold1  = new(ndate,graphic)    ; Make sure each gsn_add_polyxxx call
  lineold1 = new(ndate,graphic)    ; is assigned to a unique variable.
  dotnew1  = new(ndate,graphic)    ; Make sure each gsn_add_polyxxx call
  linenew1 = new(ndate,graphic)    ; is assigned to a unique variable.
end if
if(tforwrf .eq. 2) then
  dotold2  = new(ndate,graphic)    ; Make sure each gsn_add_polyxxx call
  lineold2 = new(ndate,graphic)    ; is assigned to a unique variable.
  dotnew2  = new(ndate,graphic)    ; Make sure each gsn_add_polyxxx call
  linenew2 = new(ndate,graphic)    ; is assigned to a unique variable.
end if
if(tforwrf .eq. 3) then
  dotold3  = new(ndate,graphic)    ; Make sure each gsn_add_polyxxx call
  lineold3 = new(ndate,graphic)    ; is assigned to a unique variable.
  dotnew3  = new(ndate,graphic)    ; Make sure each gsn_add_polyxxx call
  linenew3 = new(ndate,graphic)    ; is assigned to a unique variable.
end if
  dotobs  = new(ndateobs,graphic)    ; Make sure each gsn_add_polyxxx call
  lineobs = new(ndateobs,graphic)    ; is assigned to a unique variable.
;
; Loop through each date and add polylines to the plot.
step=6
  do i = ndatestart,ndate-2,step
     res_lines@gsLineColor           = cols(0)
     xx=(/lon2d(iminold(i),jminold(i)),lon2d(iminold(i+step),jminold(i+step))/)
     yy=(/lat2d(iminold(i),jminold(i)),lat2d(iminold(i+step),jminold(i+step))/)
    if(tforwrf .eq. 1) then
     lineold1(i) = gsn_add_polyline(wks,plot,xx,yy,res_lines)
    end if
    if(tforwrf .eq. 2) then
     lineold2(i) = gsn_add_polyline(wks,plot,xx,yy,res_lines)
    end if
    if(tforwrf .eq. 3) then
     lineold3(i) = gsn_add_polyline(wks,plot,xx,yy,res_lines)
    end if
  end do
  do i = ndatestart,ndate-2,step
     res_lines@gsLineColor           = cols(1)
     xx=(/lon2d(iminnew(i),jminnew(i)),lon2d(iminnew(i+step),jminnew(i+step))/)
     yy=(/lat2d(iminnew(i),jminnew(i)),lat2d(iminnew(i+step),jminnew(i+step))/)
    if(tforwrf .eq. 1) then
     linenew1(i) = gsn_add_polyline(wks,plot,xx,yy,res_lines)
    end if
    if(tforwrf .eq. 2) then
     linenew2(i) = gsn_add_polyline(wks,plot,xx,yy,res_lines)
    end if
    if(tforwrf .eq. 3) then
     linenew3(i) = gsn_add_polyline(wks,plot,xx,yy,res_lines)
    end if

  end do
  do i = 1,ndateobs-2
     res_lines@gsLineColor           = cols(2)
     xx=(/(iminobs(i)),(iminobs(i+1))/)
     yy=(/(jminobs(i)),(jminobs(i+1))/)
     lineobs(i) = gsn_add_polyline(wks,plot,xx,yy,res_lines)
  end do
;
  lon1d = ndtooned(lon2d)
  lat1d = ndtooned(lat2d)
;
; Loop through each date and add polymarkers to the plot.
  do i = ndatestart,ndate-1,6
     gsres@gsMarkerColor  = cols(0)
     if(tforwrf .eq. 1) then
         gsres@gsMarkerIndex  = 16                  ; filled dot
         dotold1(i)=gsn_add_polymarker(wks,plot,lon1d(sminold(i)),lat1d(sminold(i)),gsres)
     end if
     if(tforwrf .eq. 2) then
         gsres@gsMarkerIndex  = 3                  ; filled dot
         dotold2(i)=gsn_add_polymarker(wks,plot,lon1d(sminold(i)),lat1d(sminold(i)),gsres)
     end if
     if(tforwrf .eq. 3) then
         gsres@gsMarkerIndex  = 2                  ; filled dot
         dotold3(i)=gsn_add_polymarker(wks,plot,lon1d(sminold(i)),lat1d(sminold(i)),gsres)
     end if
  end do
  do i = ndatestart,ndate-1,6
     gsres@gsMarkerColor  = cols(1)
     if(tforwrf .eq. 1) then
         gsres@gsMarkerIndex  = 16                 ; filled dot
         dotnew1(i)=gsn_add_polymarker(wks,plot,lon1d(sminnew(i)),lat1d(sminnew(i)),gsres)
     end if
     if(tforwrf .eq. 2) then
         gsres@gsMarkerIndex  = 3                  ; filled dot
;         gsres@gsMarkerSizeF = 0.05               ; default - 0.007
         dotnew2(i)=gsn_add_polymarker(wks,plot,lon1d(sminnew(i)),lat1d(sminnew(i)),gsres)
     end if
     if(tforwrf .eq. 3) then
         gsres@gsMarkerIndex  = 2                  ; filled dot
;         gsres@gsMarkerSizeF = 0.05               ; default - 0.007
         dotnew3(i)=gsn_add_polymarker(wks,plot,lon1d(sminnew(i)),lat1d(sminnew(i)),gsres)
     end if
  end do
  do i = 1,ndateobs-1
     gsres@gsMarkerColor  = cols(2)
     gsres@gsMarkerIndex  = 16                  ; filled dot
;     gsres@gsMarkerSizeF = 0.05               ; default - 0.007
     dotobs(i)=gsn_add_polymarker(wks,plot,(iminobs(i)),(jminobs(i)),gsres)
  end do
  
write_table("lekima_tracklat.txt","w",[/lat1d(sminold(ndatestart:ndate-1:6)),lat1d(sminnew(ndatestart:ndate-1:6)),jminobs(1:ndateobs-1)/],"%8.4f %8.4f %8.4f")

write_table("lekima_tracklon.txt","w",[/lon1d(sminold(ndatestart:ndate-1:6)),lon1d(sminnew(ndatestart:ndate-1:6)),iminobs(1:ndateobs-1)/],"%8.4f %8.4f %8.4f")

  
;
;delete([/dotold,dotnew,lineold,linenew/])
; Date (Legend)
  txres               = True
  txres@txFontHeightF = 0.02
  txres@txFontColor   = "black"
; 
; Add marker and text for legend. (Or you can just use "pmLegend" instead.)
  txres@txJust = "CenterLeft"
  txid2 = new(5,graphic)
  pmid2 = new(5,graphic)
;  EXP=(/"Operational  (+36h)","New formula (+36h)","Operational","New formula","Observed"/)
  EXP=(/"Operational  (+36h)","New formula (+36h)","WRF-default","New","Observation"/)
  markersize=(/3,3,16,16,16/)
  cols_legend                  = (/5,160,5,160,1/)
  do i = 2,4
     res_lines@gsLineColor           = cols_legend(i)
     txres@txFontColor    =1

     gsres@gsMarkerIndex  = markersize(i)
    gsres@gsMarkerColor  = cols_legend(i)
     ii = ((/22.4,22.4,23.2,23.2,24,24,24.8,24.8,25.6,25.6/))+2.8+8  ; ilat
     jj = ((/111,111.5,111,111.5,111,111.5,111,111.5,111,111.5/))+10.5  ; jlon
     ji = ii*mlon+jj         ; col x row
     pmid2(i) = gsn_add_polymarker(wks,plot,jj(i*2),ii(i*2),gsres)
;     pmid2(i) = gsn_add_polyline(wks,plot,(/jj(i*2),jj(i)+0.25/),(/ii(i),ii(i)/),res_lines)
     txid2(i) = gsn_add_text(wks,plot,EXP(i),jj(i*2+1),ii(i*2+1),txres)
  end do
  txid3 = new(3,graphic)
  pmid3 = new(3,graphic)
  EXP2=(/"Operational  (+36h)","New formula (+36h)"/)
  markersize=(/3,3,4,4,16/)
  do i = 0,1
     gsres@gsMarkerColor  = cols(i)
     txres@txFontColor    = 1
     gsres@gsMarkerIndex  = markersize(i)
;     ii = ((/24,24,24.8,24.8,25,25/))+1.5+6  ; ilat
;     jj = ((/111,111.5,111,111.5,111,111.5/))+10.5  ; jlon
;     ji = ii*mlon+jj         ; col x row
 ;    pmid3(i) = gsn_add_polymarker(wks,plot,jj(i*2),ii(i*2),gsres)
 ;    txid3(i) = gsn_add_text(wks,plot,EXP2(i),jj(i*2+1),ii(i*2+1),txres)
  end do
print(iminold(4*6:5*6))
print(jminold(4*6:5*6))
print(iminnew(4*6:5*6))
print(jminnew(4*6:5*6))
delete([/iminold,jminold,iminnew,jminnew,sminold,sminnew,timewrf,time/])
end do

  draw(plot)

  frame(wks)




end
